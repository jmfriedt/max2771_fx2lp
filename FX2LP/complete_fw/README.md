## Complete firmware including Vendor Requests trigger SPI transactions and bulk transfer endpoints

```
sudo cycfx2prog prg:build/complete_fw.ihx run
```

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
