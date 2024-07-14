#!/usr/bin/env python3

# see https://www.beyondlogic.org/usbnutshell/usb6.shtml
'''
Direction = OUT
ReqType = Vendor
Target = Device
Request Codes:
VR_STAT      0x40       // USB vendor request: Get device info and status
VR_REG_READ  0x41       // USB vendor request: Read MAX2771 register
VR_REG_WRITE 0x42       // USB vendor request: Write MAX2771 register
'''

import usb
from sys import platform as _platform
import time
import binascii
import struct

VID = 0x04B4
PID = 0x1004
dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

# dev.ctrl_transfer(bmRequestType, bRequest, wValue, wIndex, data)
ret=dev.ctrl_transfer(0xC0,0x40, 0, 0, 6)  # read VR_STAT: returns 6 bytes
print(binascii.hexlify(ret))                # cannot use int.from_bytes since interprets 6 bytes as 8

ret=dev.ctrl_transfer(0xC0 ,0x41, 0x03, wIndex=0, data_or_wLength=4)
print(f"03 before: {binascii.hexlify(ret)}")

time.sleep(.1)
msg=bytearray([0x69,0x8c,0x00,0x00]);        # setting for 8 MS/s by XTal x1
msg=bytearray([0x09,0x8c,0x00,0x00]);        # setting for 16 MS/s by XTal x2
msg=struct.pack('>I', 0x098C0000);           # little endian, unsigned int cf https://docs.python.org/3/library/struct.html
dev.ctrl_transfer(0x40 , 0x42, 0x03, 0, msg) # write on SPI bus reg @ 0x03 int msg
ret=dev.ctrl_transfer(0xC0 ,0x41, 0x03, wIndex=0, data_or_wLength=4)
val=int.from_bytes(ret, "big") # big or little
print(f"03 after:  {binascii.hexlify(ret)} {val:#x}")

