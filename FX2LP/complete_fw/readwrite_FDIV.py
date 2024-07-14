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
ret=dev.ctrl_transfer(0xC0,0x40, 0, 0, 10)  # read VR_STAT
print(binascii.hexlify(ret))                # b'105dc0010100'

#PLL Fractional Division Ratio register 0x05
#default value 0x08000070
#                      ^^ reserved
#dec2hex(586329)
#ans =           08F259
msg=bytearray([0x08,0xF2,0x59,0x70]);
ret=dev.ctrl_transfer(0xC0 ,0x41, 0x05, wIndex=0, data_or_wLength=4)
print(binascii.hexlify(ret))                # b'105dc0010100'

time.sleep(.1)
dev.ctrl_transfer(0x40 , 0x42, 0x05, 0, msg) # write on SPI bus reg @ 0x55 int msg
ret=dev.ctrl_transfer(0xC0 ,0x41, 0x05, wIndex=0, data_or_wLength=4)
print(binascii.hexlify(ret))                # b'105dc0010100'
