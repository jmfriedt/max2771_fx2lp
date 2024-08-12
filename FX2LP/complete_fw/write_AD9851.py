#!/usr/bin/env python3

import usb
from sys import platform as _platform
import time
import binascii
import struct
import sys

print(len(sys.argv))

if (len(sys.argv)>=2):
    f=float(sys.argv[1])
else:
    f=24e6

print(f)

fclk=150e6

ftw=int((f/fclk)*2**32)   # 687194767
msg=struct.pack('>I',ftw) # send LSB first and SDCC is little endian
msg+=bytes([1])
print(msg)
# dec2hex(687194767) ans = 28F5C28F vs print(msg): b'\x8f\xc2\xf5\x28'

VID = 0x04B4
PID = 0x1004
dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

dev.ctrl_transfer(0x40 , 0x50, 0x00, 0, msg) # write msg on SPI bus
