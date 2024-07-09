From ``PocketSDR/FE_2CH/FW/v2.1/pocket_fw.c`` we learn that calling 
vendor request 0x40 (VR_STAT) returns 6 bytes with
```
EP0BUF[0] = VER_FW;             // F/W version            0x10
EP0BUF[1] = MSB(F_TCXO);        // TCXO Frequency (kHz)   0x5D
EP0BUF[2] = LSB(F_TCXO);                                  0xC0
EP0BUF[3] = digitalRead(STAT1); // MAX2771 CH1 PLL status (0:unlock,1:lock)
EP0BUF[4] = digitalRead(STAT2); // MAX2771 CH2 PLL status (0:unlock,1:lock)
EP0BUF[5] = digitalRead(LED2);  // Bulk transfer status (0:stop,1:start)
```
and indeed executing 
```
$ python3 ./vendor_cmd.py 
b'105dc0010100'
```
returns 0x10 as ``VER_FW``, followed by the hexadecimal representation of 24000 the oscillator
frequency in kHz (0x5DC0) and status bytes.

Running vendor requests 0x41 (read register) and 0x42 (write registers) with wValue the 8-bit
register index, wIndex set to 0 and the last argument set to the written data in case of 0x42
leads to the oscilloscope screenshot (yellow is Chip Select, orange is Clock and green is MOSI):

<img src="Screenshot_2024-07-09_0_190915.png">


