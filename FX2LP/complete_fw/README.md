## Complete firmware including Vendor Requests trigger SPI transactions and bulk transfer endpoints

```
sudo cycfx2prog prg:build/complete_fw.ihx run
```
for executing from RAM, or
```
sudo ../../fxload/src/fxload load_eeprom --device 04b4:8613 --ihex-path ./build/complete_fw.ihx -t FX2LP --control-byte 0xC2 -s ../bulk_read_example/Vend_Ax.hex
```
for flashing to non-volatile memory (remember to invalidate EEPROM if already written,
see <a href="../bulk_read_example/">../bulk_read_example/</a>).

Once the program is executing, ``lsusb`` must indicate
```
Bus 001 Device 097: ID 04b4:1004 Cypress Semiconductor Corp. There
```

Warning: ``fx2lib`` provides a ``delay()`` function with an argument in ms, conflicting
with the PocketSDR use of ``delay()`` whose argument is in number of loops.

EEPROM access is included but untested.

Using PocketSDR ``pocket_conf/pocket_conf ../../conf/pocket_L1L1_8MHz.conf`` and then
``pocket_dump/pocket_dump -t 2 1.bin 2.bin`` demonstrates data transfer rates of 8 Msamples/s.
Then, executing ``python3 ./readwrite_PLL.py`` updates the ADC configuration register according to

<img src="ADC_clock.png">

by doubling the ADC clock (REFDIV from 0x3 for x1 to 0x0 for x2) and running again ``pocket_dump`` this 
time indicates a datarate of 16 Msamples/s, demonstrating that the manipulation of the registers
of the MAX2771 from Python and the SDCC firmware is correctly understood.

# Testing the communication

Even without MAX2771, FX2LP bulk communication can be checked by connecting a square
wave generator to the IFCLK and checking the matching datarate with the PocketSDR
``pocket_dump``

<img src="IMG_20241023_135337_756small.jpg" width=400>

```sh
$ sudo ./pocket_dump -t 1 
  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
      1.0    I      6029312   I      6029312       5981.5
```

# Changing VID/PID

If two circuits are to be used on the same computer (e.g. dual-frequency CRPA analysis requiring
two dual-MAX2771 boards), the VID/PID on one board must be changed. Since I am unable to figure
out why the ``PID=0x1005`` in the ``Makefile`` has no effect, editing the ``.ihx`` file to change
VID/PID is necessary.

To achieve this result, edit ``build/complete_fw.ihx`` with a text editor and replace

:203E000012010002FFFFFF40B404**04**100100010200010A060002FFFFFF4001000902200004

with .e.g (15th byte changed from 04 to 05 since the word order is little endian so that 0410 
represents PID 1004 and 0410 is replaced with 0510)

:203E000012010002FFFFFF40B404**05**100100010200010A060002FFFFFF4001000902200004

for the circuit to be identified as (notice the PID as 1005 instead of 1004)
```
Bus 003 Device 044: ID 04b4:1005 Cypress Semiconductor Corp. There
```

Changing VID/PID for using multiple boards on the same computer is however not needed since ``pocket_conf``
and ``pocket_dump`` use the ``-p`` flag to define which chip is addressed:
```
$ lsusb
Bus 001 Device 125: ID 04b4:1004 Cypress Semiconductor Corp. There
Bus 001 Device 126: ID 04b4:1004 Cypress Semiconductor Corp. There
$ sudo app/pocket_scan/pocket_scan
...
( 4) BUS= 1 PORT= 6 SPEED=HIGH  ID=04B4:1004  Hi There iFace
( 5) BUS= 1 PORT= 5 SPEED=HIGH  ID=04B4:1004  Hi There iFace
...
$ sudo ./app/pocket_conf/pocket_conf -p 1,5 conf/pocket_L1L5_20MHz.conf 
Pocket SDR device settings are changed.
$ sudo ./app/pocket_conf/pocket_conf -p 1,6 conf/pocket_L1L5_20MHz.conf 
Pocket SDR device settings are changed.
$ rm -f *bin
$ sleep 2 && sudo ./app/pocket_dump/pocket_dump -p 1,5 -t 300  11.bin 12.bin 
  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
      4.8   IQ    193069056  IQ    193069056      20034.0
$ sudo ./app/pocket_dump/pocket_dump -p 1,6 -t 300  21.bin 22.bin 
TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
     17.2   IQ    689176576  IQ    689176576      19985.2
```

See slide 26 of https://gpspp.sakura.ne.jp/paper2005/pocketsdr_seminar_202411_revA.pdf for a detailed
description of ``pocket_scan``.
