#!/usr/bin/env python3

import socket
from monitor_pvt_pb2 import MonitorPvt 
import usb
from sys import platform as _platform
import binascii
import struct
import sys
import time

VID = 0x04B4
PID = 0x1004
fclk=150e6
fmax=0.5 # max frequency variation (Hz)
if (len(sys.argv)>=2):
    f=float(sys.argv[1])
else:
    f=24e6
ftw0=((f/fclk)*2**32)   # 687194767
y=0
c=5e-3
Kp=.05 # .1 # .01
Ki=Kp/3

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

m=0
yold=0
oldtime=time.time()
while True:
    data, addr=sock.recvfrom(1500)
    foo.ParseFromString(data)
    df=foo.user_clk_drift_ppm*24
    dt=foo.user_clk_offset
    y+=c*(df-y)               # low pass IIR with time constant 1/c
    print(f"{m}: TOW={foo.tow_at_current_symbol_ms} dt={dt} x={foo.pos_x} y={foo.pos_y} z={foo.pos_z} df={df} f={f}")
    newtime=time.time()
    if (newtime-oldtime)>200:
        m=0
    oldtime=newtime
    if (m>200):
        dc=Kp*(y-yold)+Ki*y
        if abs(dc)>fmax:
            dc=dc/abs(dc)*fmax
        yold=y
        f-=dc
        ftw0=((f/fclk)*2**32)   # 687194767
        msg=struct.pack('>I',int(ftw0))
        msg+=bytes([1])
        dev.ctrl_transfer(0x40 , 0x50, 0x00, 0, msg) # write msg on SPI bus
    m=m+1
