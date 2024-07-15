### Bulk access from FX2LP microcontroller to Linux host

Compiling and flashing the firmware:
```
make
sudo cycfx2prog prg:build/fifo_ep6.ihx run
```

Compiling the host application and executing on GNU/Linux:
```
g++ -o fx2lp_ep6_in_fifo fx2lp_ep6_in_fifo.cpp -lusb-1.0
sudo rmmod usbtest
sudo ./fx2lp_ep6_in_fifo
```
