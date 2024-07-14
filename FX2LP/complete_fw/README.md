## Complete firmware including Vendor Requests trigger SPI transactions and bulk transfer endpoints

```
sudo cycfx2prog prg:build/complete_fw.ihx run
```

```
Bus 001 Device 097: ID 04b4:1004 Cypress Semiconductor Corp. There
```

```
$ sudo ./readwrite_FDIV.py 
b'105dc0000001'
b'70000008'
b'08f25970'
```

Problem:
$ sudo /home/jmfriedt/sdr/max2771/PocketSDR/app/pocket_conf/pocket_conf | head
#
#  Pocket SDR device settings (MAX2771)
#
#  [CH1] F_LO = 1573.420 MHz, F_ADC =  8.000 MHz (I ), F_FILT =  2.0 MHz, BW_FILT =  2.5 MHz
#  [CH2] F_LO = 1573.420 MHz, F_ADC =  0.000 MHz (I ), F_FILT =  2.0 MHz, BW_FILT =  2.5 MHz

but

$ sudo /home/jmfriedt/sdr/max2771/PocketSDR/app/pocket_dump/pocket_dump -t 3
  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
      3.0    I     72220672   I     72220672      24001.6

+ long delay at startup
