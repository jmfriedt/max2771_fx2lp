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
