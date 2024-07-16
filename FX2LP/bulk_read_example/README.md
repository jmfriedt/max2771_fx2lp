### Bulk access from FX2LP microcontroller to Linux host
    
A host program to read bulk data from End Point 6 of FX2LP:
reads 512 bytes from the device, originally by Siddharth Deore 
(siddharthdeore@gmail.com.

Compiling and flashing the firmware:
```
make
sudo cycfx2prog prg:build/fifo_ep6.ihx run
```

Compiling the host application and executing on GNU/Linux:
```
gcc -o fx2lp_ep6_in_fifo fx2lp_ep6_in_fifo.c -lusb-1.0
lsusb | grep ypress  # check for ID 04b4:8613 Cypress Semiconductor Corp. CY7C68013 EZ-USB FX2 USB 2.0 Development Kit
sudo rmmod usbtest
sudo ./fx2lp_ep6_in_fifo
```

