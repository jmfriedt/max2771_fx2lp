import numpy as np # pkg load signal;
import zmq         # pkg load zeromq;
import array
import time
import scipy
from matplotlib import pyplot as plt
np.set_printoptions(precision=2, suppress=None) 

fs=4e6
Nt = int(fs//2)
seuil = 3
pl=0
moy=1
decim=30
jmfdebg=0

def create_lut():
  lut=np.zeros(16)+1j*np.zeros(16)
  for i in range(16):
    lut[i]=(-1*(2*((i&2)>>1)-1))*((i&1)*2+1)
    lut[i]=lut[i]+1j*((2*((i&8)>>3)-1))*(((i&4)>>2)*2+1)
  return(lut)

lut=create_lut() 
# print(lut)

context = zmq.Context()
b=scipy.signal.firls(63,(0,fs/2/30*2/fs, (fs/2/30+fs/2/64)*2/fs, 1),(1,1,0,0))
n=0
while n<1:
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
#    resA=resA*resA
#    resB=resB*resB
    resA=resA-np.mean(resA)
    resB=resB-np.mean(resB)
    resA=scipy.signal.lfilter(b,1,resA)
    resB=scipy.signal.lfilter(b,1,resB)
    resA=resA[::decim]
    resB=resB[::decim]
    fs=fs/decim
    fr=np.linspace(-fs/2,fs/2-fs/len(resA),len(resA))
    resAm+=np.fft.fftshift(np.fft.fft(resA))
    resBm+=np.fft.fftshift(np.fft.fft(resB))
 
  # resAm[len(resAm)//2-10:len(resAm)//2+10]=0
  # resBm[len(resBm)//2-10:len(resBm)//2+10]=0
  print(f"{dat/tim/1e6:.2f} MB/s",end=" ")
  if pl==1:
    plt.plot(fr,np.abs(resAm))
  
  fr=np.linspace(-fs/2,fs/2-fs/len(resAm),len(resAm)) 
  pos=np.argmax(np.abs(resAm))
  res=np.angle(resAm[pos]/resBm[pos])
  print(f"{res:.2f} @ {fr[pos]}")
  n=n+1
