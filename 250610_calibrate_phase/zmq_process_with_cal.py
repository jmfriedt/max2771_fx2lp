#!/usr/bin/env python3

import numpy as np # pkg load signal;
import zmq         # pkg load zeromq;
import array
import time
import scipy
import os
import usb
from sys import platform as _platform
import binascii
import sys
os.environ['PATH'] += os.pathsep + '../../PocketSDR/app/pocket_conf/'

value=0  # or 1
VID = 0x04B4
PID = 0x1004

dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

np.set_printoptions(precision=2, suppress=None) 

fs=4e6
Nt = int(fs//2)
seuil = 3
pl=0
moy=4
decim=30
stdseuil=0.7
Ncal=5      # recalibrate phase every 5 mesurements
jmfdebg=0

if pl==1:
  from matplotlib import pyplot as plt

def create_lut():
  lut=np.zeros(16)+1j*np.zeros(16)
  for i in range(16):
    lut[i]=(-1*(2*((i&2)>>1)-1))*((i&1)*2+1)
    lut[i]=lut[i]+1j*((2*((i&8)>>3)-1))*(((i&4)>>2)*2+1)
  return(lut)

lut=create_lut() 
print(lut)

def calibration(resAm, resBm, fs, pl):
  fr=np.linspace(-fs/2,fs/2-fs/len(resAm),len(resAm)) 
  resAm=resAm-np.mean(resAm)
  resBm=resBm-np.mean(resBm)
  pos=np.argmax(np.abs(resAm))
  if resBm[pos]!=0:
    res=np.angle(resAm[pos]/resBm[pos])
    print(f"res {res:.2f} @ {fr[pos]:.0f}")
  else:
    print(f"ERROR divide by 0")
    res=0
  return(res)

def spoofing_detection(resAm, resBm, calphase, fs, pl):
    resAm[len(resAm)//2-10:len(resAm)//2+10]=0
    resBm[len(resBm)//2-10:len(resBm)//2+10]=0
    if pl==1:
      plt.plot(fr,np.abs(resAm))
    baseline=np.convolve(resAm,np.ones(32)/32) # low pass filter spectrum
    baseline=baseline[15:-16]
    resAm=resAm-baseline
    if pl==1:
      plt.plot(fr,np.abs(resAm))
      plt.show()
    
    res=np.zeros(10)
    m=0
    q=0
    while m<10 and q<100:
      pos=np.argmax(np.abs(resAm))
      if (np.abs(resAm[pos])>np.mean(np.abs(resAm[:100])) * seuil) :
        if (np.abs(resBm[pos])>np.mean(np.abs(resBm[:100])) * seuil) :
          res[m]=np.angle(resAm[pos]/resBm[pos])
          resBm[pos-3:pos+3]=0
          m=m+1
        resAm[pos-3:pos+3]=0
        q=q+1
      else:
        q=100
    print(f"m={m} q={q}",end="")
    res=res[0:m]
    
    if m>0:
      kres = np.where(res < 0)[0]
      res[kres] = res[kres] + 2 * np.pi
      kres = np.where(res > 6.28)[0]
      res[kres] = res[kres] - 2 * np.pi
      kres = np.where(res > 3)[0]
      res[kres] = 2*np.pi - res[kres]
      if m>3:
        res=res-calphase
        med=np.median(abs(res))
        if jmfdebg==1:
          print(f": mea={np.mean(abs(res)):.2f} med={med:.2f} std={np.std(abs(res)):.2f} {res}",end='')
        else :
          print(f": mea={np.mean(abs(res)):.2f} med={med:.2f} std={np.std(abs(res)):.2f} DoA={np.asin(med/2/np.pi/0.5)*180/np.pi:.1f} deg (cal={calphase:.2f})",end='')
        if np.std(abs(res))<stdseuil:
          print(f" /!\\",end='')
    print("")

context = zmq.Context()
b=scipy.signal.firls(63,(0,fs/2/30*2/fs, (fs/2/30+fs/2/64)*2/fs, 1),(1,1,0,0))
calphase=0
calibrage=1
while True:
  resAm=np.zeros(Nt//decim+1)+1j*np.zeros(Nt//decim+1)
  resBm=np.zeros(Nt//decim+1)+1j*np.zeros(Nt//decim+1)
  tim=0
  dat=0
  for m in range(moy):
    sock1 = context.socket(zmq.SUB) 
    sock1.connect("tcp://127.0.0.1:5555");
    sock1.setsockopt(zmq.SUBSCRIBE, b"")
    vector = sock1.recv()
    s=time.time()
    while (len(vector)<Nt):
      raw_recv = sock1.recv()
      vector=vector+raw_recv
    f=time.time()
    tim+=(f-s)
    dat+=len(vector)
    sock1.close()
    resA=np.zeros(len(vector))+1j*np.zeros(len(vector))
    resB=np.zeros(len(vector))+1j*np.zeros(len(vector))
    for k in range(len(vector)):
      resA[k]=lut[vector[k]&0x0f]
      resB[k]=lut[(vector[k]>>4)&0x0f]
    resA=resA[0:Nt]
    resB=resB[0:Nt]
    if calibrage!=0:
      resA=resA*resA  # squared signal
      resB=resB*resB
    resA=resA-np.mean(resA)
    resB=resB-np.mean(resB)
    resA=scipy.signal.lfilter(b,1,resA)
    resB=scipy.signal.lfilter(b,1,resB)
    resA=resA[::decim]
    resB=resB[::decim]
    # fs=fs/decim
    resAm+=np.fft.fftshift(np.fft.fft(resA))
    resBm+=np.fft.fftshift(np.fft.fft(resB))
    print(f"{dat/tim/1e6:.2f} MB/s",end=" ")
  if calibrage==0:
    calphase=calibration(resAm, resBm, fs/decim, pl)
    calibrage=Ncal
    os.system('pocket_conf pocket_L1L1_4MHz.conf')
    value=0
    dev.ctrl_transfer(0x40, 0x51, value, 0) # disable oscillator
  else:
    spoofing_detection(resAm, resBm, calphase, fs/decim, pl)
  if calibrage==1:
    print("Cal",end=" ")
    os.system('pocket_conf pocket_L1L1_4MHz_cal.conf')  # next measurement will be calibration
    value=1
    dev.ctrl_transfer(0x40, 0x51, value, 0) # enable oscillator
  calibrage=calibrage-1
