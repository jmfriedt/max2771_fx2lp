## Reading the PocketSDR output for real time display in GNU Radio Frequency Sink

```
sudo mkfifo /tmp/ch1  # needed for sudo access
sudo mkfifo /tmp/ch2
cd max2771_fx2lp/FX2LP/complete_fw/
sudo cycfx2prog prg:build/complete_fw.ihx run
cd PocketSDR/
sudo ./app/pocket_conf/pocket_conf pocket_L1L1_4MHz.conf 
sudo ./app/pocket_dump/pocket_dump /tmp/ch1 /tmp/ch2
```
