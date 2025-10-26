#!/usr/bin/env python3
import usb.core
import usb.util
from sys import platform as _platform
import binascii

N = 512
tout_ms = 1000
vid = 0x04b4
pid = 0x1004 # 0x8613

dev = usb.core.find(idVendor=vid, idProduct=pid)
if dev is None:
  raise ValueError("Device not found")

if _platform == "linux" or _platform == "linux2":
  if dev.is_kernel_driver_active(0):
    dev.detach_kernel_driver(0)

dev.set_configuration()
dev.reset()                       ## needed for running multiple times bulkloop read/write 
usb.util.claim_interface(dev,0)
cfg = dev.get_active_configuration()
interface_number = cfg[(0, 0)].bInterfaceNumber
alternate_setting = usb.control.get_interface(dev, interface_number)
# dev.set_interface_altsetting(interface_number, alternate_setting)

try:
  data = dev.read(0x86, N, tout_ms)  # 0x80 | 6
  print(data)
except usb.core.USBError as e:
  print(str(e))

# dev.set_interface_altsetting(0, 0)
# dev.set_configuration()
# interface = dev.get_active_configuration()[(0, 0)]
# print(interface)
# ep_in = usb.util.find_descriptor ( interface , custom_match = lambda e : \
# usb.util.endpoint_direction (e.bEndpointAddress ) == usb.util.ENDPOINT_IN )
# assert ep_in is not None
# 
# usb.util.claim_interface(dev,0)
# print(dev)
# dev.read(0x86,512,1000)
