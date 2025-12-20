#!/usr/bin/env python3

import usb
from sys import platform as _platform
import binascii
import sys

if len(sys.argv)>1:
    value=int(sys.argv[1])
else:
    value=0  # or 5

VID = 0x04B4
PID = 0x1004
dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

dev.ctrl_transfer(0x40 , 0x51, value, 0) # vendor cmd 0x50 = handle GPIO ; 0 = GPIO value
