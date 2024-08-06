# https://github.com/david0/durgod-keymapper/blob/master/remap.py

def tohex(data):
    return ' '.join(map(lambda x: "%02x" % x, data))

import hid

VENDOR_ID=0x1234
PRODUCT_ID=6
RESET = b"\xc9".ljust(31, b"\x00")
device_info = next(device for device in hid.enumerate() if device['vendor_id'] == VENDOR_ID and device['product_id'] == PRODUCT_ID)
device=hid.device()
device.open_path(device_info['path'])
device.write(RESET)
resp=device.read(64, timeout_ms=500)
resp=bytearray(resp).rstrip(b'0x00');
print(tohex(resp))
