#!/usr/bin/env python3

import usb
from sys import platform as _platform
import binascii

VID = 0x04B4
PID = 0x8613
dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

# read EEPROM
ret=dev.ctrl_transfer(0xC0,0xa9, 0, 0, 64)  # read EEPROM content
print(binascii.hexlify(ret))

# write & read EEPROM
msg=bytearray([0xff,0xff,0xff,0xff]);       # write EEPROM (erase)
dev.ctrl_transfer(0x40 , 0xa9, 0x0, 0, msg)
ret=dev.ctrl_transfer(0xC0,0xa9, 0, 0, 64)  # read EEPROM content
print(binascii.hexlify(ret))


