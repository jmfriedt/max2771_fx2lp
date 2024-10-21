#!/usr/bin/env python3

# assumes the PocketSDR firmware complete_fw.c is running
# EEPROM read is vendor request 0x48
# EEPROM write is vendor request 0x49
# this program will damage the first bytes in EEPROM and prevent any program
#   stored there from running unless a new program is transfered

import usb
from sys import platform as _platform
import time
import binascii
import struct
import sys

VID = 0x04B4
PID = 0x1004
dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

ret=dev.ctrl_transfer(0xC0 , 0x48, 0x00, 0, 10) # read EEPROM content (10 bytes starting @ 0)
print(f"before: {binascii.hexlify(ret)}")

msg=bytearray(range(0,10));
time.sleep(.1)
dev.ctrl_transfer(0x40 , 0x49, 0x00, 0, msg)    # write EEPROM content

msgret=dev.ctrl_transfer(0xC0 , 0x48, 0x00, 0, 10) # re-read to check
print(f"after: {binascii.hexlify(msgret)}")
