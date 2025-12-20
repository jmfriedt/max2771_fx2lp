# Connect a frequency synthesizer set to 1575.5 MHz, power -85 dBm, through a 
# SHP-250+ high pass filter and ZAPD-2DC-S+ or ZAPD-2-21-2W-S splitter.
echo -e "\033[1;31mTTi: 1575.5 MHz, -85 dBm, ZAPD-2-21-3W splitter + 250 MHz HPF\033[00m"
sudo rm /tmp/[12].bin*
sudo ../../PocketSDR/app/pocket_conf/pocket_conf ../conf/pocket_L1L1_4MHzstarlink.conf
sudo ../../PocketSDR/app/pocket_conf/pocket_conf ../conf/pocket_L1L1_4MHzstarlink.conf
sudo ../../PocketSDR/app/pocket_conf/pocket_conf ../conf/pocket_L1L1_4MHzstarlink.conf
sudo ../../PocketSDR/app/pocket_conf/pocket_conf | head -5
sudo ./vendor_cmd.py 0
sudo ../../PocketSDR/app/pocket_dump/pocket_dump -t 3 /tmp/1.bin  /tmp/2.bin &
sleep 1
sudo ../../PocketSDR/app/pocket_conf/pocket_conf ../250610_calibrate_phase/pocket_L1L1_4MHz_cal.conf
sudo ../../PocketSDR/app/pocket_conf/pocket_conf ../250610_calibrate_phase/pocket_L1L1_4MHz_cal.conf
sudo ../../PocketSDR/app/pocket_conf/pocket_conf ../250610_calibrate_phase/pocket_L1L1_4MHz_cal.conf
sudo ./vendor_cmd.py 1
sudo ../../PocketSDR/app/pocket_conf/pocket_conf | head -5
wait
octave verification.m
