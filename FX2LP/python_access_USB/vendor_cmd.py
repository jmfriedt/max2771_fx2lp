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

VID = 0x04B4
PID = 0x8613
dev = usb.core.find(idVendor = VID, idProduct = PID)
if not dev:
    print("FX2LP not found")
    exit(1)

if _platform == "linux" or _platform == "linux2":
    if dev.is_kernel_driver_active(0):
        dev.detach_kernel_driver(0)

# dev.ctrl_transfer(bmRequestType, bRequest, wValue, wIndex, data)
msg=bytearray([0x40,0x04,0x55,0xaa]);
ret=dev.ctrl_transfer(bmRequestType=0xC0 ,bRequest=0x41, wValue=0xFF, wIndex=0, data_or_wLength=4)
#  else if (SETUPDAT[1] == VR_REG_READ) {
#    *(uint32_t *)EP0BUF = read_reg(SETUPDAT[3], SETUPDAT[2]);
# returns 4 bytes

# 0x155 to activate second CS#, 0x55 to activate first CS#
dev.ctrl_transfer(0x40 , 0x42, 0x55, 0, msg) # write on SPI bus reg @ 0x55 int msg

ret=dev.ctrl_transfer(0xC0,0x40, 0, 0, 10)  # read VR_STAT
print(binascii.hexlify(ret))                # b'105dc0010100'
# PocketSDR/FE_2CH/FW/v2.1/pocket_fw.c 
#   EP0BUF[0] = VER_FW;             // F/W version            0x10
#   EP0BUF[1] = MSB(F_TCXO);        // TCXO Frequency (kHz)   0x5D
#   EP0BUF[2] = LSB(F_TCXO);                                  0xC0
#   EP0BUF[3] = digitalRead(STAT1); // MAX2771 CH1 PLL status (0:unlock,1:lock)
#   EP0BUF[4] = digitalRead(STAT2); // MAX2771 CH2 PLL status (0:unlock,1:lock)
#   EP0BUF[5] = digitalRead(LED2);  // Bulk transfer status (0:stop,1:start)
# returns 6 bytes

