#!/usr/bin/env python3

# see https://www.beyondlogic.org/usbnutshell/usb6.shtml
'''
VID = 0x04B4
PID = 0x8613
Direction = OUT
ReqType = Vendor
Target = Device
Request Codes:
VR_STAT      0x40       // USB vendor request: Get device info and status
VR_REG_READ  0x41       // USB vendor request: Read MAX2771 register
VR_REG_WRITE 0x42       // USB vendor request: Write MAX2771 register
VR_START     0x44       // USB vendor request: Start bulk transfer
VR_STOP      0x45       // USB vendor request: Stop bulk transfer
VR_RESET     0x46       // USB vendor request: Reset device
VR_SAVE      0x47       // USB vendor request: Save settings to EEPROM
VR_EE_READ   0x48       // USB vendor request: Read EEPROM
VR_EE_WRITE  0x49       // USB vendor request: Write EEPROM
'''

import usb
from sys import platform as _platform
import binascii
import numpy

VID = 0x04B4
PID1 = 0x8613
PID2 = 0x1004
dev = usb.core.find(idVendor = VID, idProduct = PID1)
if not dev:
    dev = usb.core.find(idVendor = VID, idProduct = PID2)
    if not dev:
        print("FX2LP not found")
        exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

# dev.ctrl_transfer(bmRequestType, bRequest, wValue, wIndex, data)
for r in range(11):
    ret=dev.ctrl_transfer(0xC0 ,0x41, r, wIndex=0, data_or_wLength=4)
#    val=int.from_bytes(ret, "little") # byteswap
    print(f"{r:#02x}: {binascii.hexlify(ret)} ")

# version SDCC
# $ sudo /home/jmfriedt/sdr/max2771/PocketSDR/app/pocket_conf/pocket_conf /home/jmfriedt/sdr/max2771/PocketSDR/conf/pocket_L1L1_8MHz.conf
# Write type: 0
# read: 0: a2241ac3
# read: 1: 20550288
# read: 2: eaf21d0
# read: 3: 698c0000
# read: 4: 82008
# read: 5: 8f25970
# read: 6: 8000000
# read: 7: 8000002
# read: 8: 1e0f401
# read: 9: 2
# read: a: c
# read: 0: a2241ac3
# read: 1: 20550288
# read: 2: eaf21d0
# read: 3: 698c0000
# read: 4: 82008
# read: 5: 8f25970
# read: 6: 8000000
# read: 7: 18000002
# read: 8: 1e0f401
# read: 9: 2
# read: a: c
# write: 0: a2241ac3
# write: 1: 20550288
# write: 2: eaf21d0
# write: 3: 698c0000
# write: 4: 82008
# write: 5: 8f25970
# write: 7: 8000002
# write: a: c
# write: 0: a2241ac3
# write: 1: 20550288
# write: 2: eaf21d0
# write: 3: 698c0000
# write: 4: 82008
# write: 5: 8f25970
# write: 7: 18000002
# write: a: c
# Pocket SDR device settings are changed.
# $ max2771_fx2lp/FX2LP/python_access_USB$ sudo ./dumpall.py
# 0x0: b'a2241ac3'
# 0x1: b'20550288'
# 0x2: b'0eaf21d0'
# 0x3: b'698c0000'
# 0x4: b'00082008'
# 0x5: b'08f25970'
# 0x6: b'08000000'
# 0x7: b'08000002'
# 0x8: b'01e0f401'
# 0x9: b'00000002'
# 0xa: b'0000000c'
