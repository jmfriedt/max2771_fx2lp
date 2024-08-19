#!/usr/bin/env python3

import socket
from monitor_pvt_pb2 import MonitorPvt 
import usb
from sys import platform as _platform
import binascii
import struct
import sys
import time

def init_phase(f,dtwanted,foo,sock):
    dt=0
    while dt<2e-10:          # erroneous reading
        data, addr=sock.recvfrom(1500)
        foo.ParseFromString(data)
        df=foo.user_clk_drift_ppm*24
        dt=foo.user_clk_offset
    
    if dt>dtwanted+2e-5:
        f=f-df-300
    if dt<dtwanted-2e-5:
        f=f-df+300    # 300/24e6 = 12 us/s
    ftw0=((f/fclk)*2**32)   # 687194767
    msg=struct.pack('>I',int(ftw0))
    msg+=bytes([1])
    dev.ctrl_transfer(0x40 , 0x50, 0x00, 0, msg) # write msg on SPI bus
    
    dt=1
    m=0
    while abs(dt-dtwanted)>4e-5:
        data, addr=sock.recvfrom(1500)
        foo.ParseFromString(data)
        df=foo.user_clk_drift_ppm*24
        dt=foo.user_clk_offset
        gdop=foo.gdop
        pdop=foo.pdop
        print(f"{m}: TOW={foo.tow_at_current_symbol_ms} dt={dt} x={foo.pos_x} y={foo.pos_y} z={foo.pos_z} df={df} f={f} gdop={gdop} pdop={pdop}" )
    
    f=f-df
    ftw0=((f/fclk)*2**32)   # 687194767
    msg=struct.pack('>I',int(ftw0))
    msg+=bytes([1])
    dev.ctrl_transfer(0x40 , 0x50, 0x00, 0, msg) # write msg on SPI bus
    return f

VID = 0x04B4
PID = 0x1004
fclk=150e6
fmax=0.2 # max frequency variation (Hz/s)
if (len(sys.argv)>=2):
    f=float(sys.argv[1])
else:
    f=24e6
ftw0=((f/fclk)*2**32)   # 687194767
y=0
c=5e-1
Kp=.05*24000000. # .1 # .01
Ki=Kp/3
dtwanted=0.01  # 10 ms

dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

msg=struct.pack('>I',int(ftw0))
msg+=bytes([1])
dev.ctrl_transfer(0x40 , 0x50, 0x00, 0, msg) # write msg on SPI bus

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("127.0.0.1", 1234))
foo = MonitorPvt()

init_phase(f,dtwanted,foo,sock)

m=0
yold=0
oldtime=time.time()

while True:
    data, addr=sock.recvfrom(1500)
    foo.ParseFromString(data)
    df=foo.user_clk_drift_ppm*24
    dt=foo.user_clk_offset
    gdop=foo.gdop
    pdop=foo.pdop
    if dt>2e-10:
        y+=c*((dt-dtwanted)-y)               # low pass IIR with time constant 1/c on error signal
    print(f"{m}: TOW={foo.tow_at_current_symbol_ms} dt={dt} x={foo.pos_x} y={foo.pos_y} z={foo.pos_z} df={df} f={f} gdop={gdop} pdop={pdop}" )
    newtime=time.time()
    if (newtime-oldtime)>200:
        init_phase(f,dtwanted,foo,sock)
        m=0
    oldtime=newtime
    if (m>200):
        dc=Kp*(y-yold)+Ki*y
        if abs(dc)>fmax:
            dc=dc/abs(dc)*fmax
        yold=y
        f-=dc
        print(f"{y} {dc}")
        ftw0=((f/fclk)*2**32)   # 687194767
        msg=struct.pack('>I',int(ftw0))
        msg+=bytes([1])
        dev.ctrl_transfer(0x40 , 0x50, 0x00, 0, msg) # write msg on SPI bus
    m=m+1
