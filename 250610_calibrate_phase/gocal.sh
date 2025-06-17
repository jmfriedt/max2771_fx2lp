sudo rm /tmp/*bin*
sudo rmmod usbtest
sudo uhubctl -l 2 -a 1  # power on on RPi4
for j in `seq 1 50`; do
#   sudo ../../PocketSDR/app/pocket_conf/pocket_conf pocket_L2L2_4MHz.conf 
#   sudo ../../PocketSDR/app/pocket_conf/pocket_conf pocket_L2L2_4MHz.conf 
   sudo ../../PocketSDR/app/pocket_conf/pocket_conf pocket_L1L1_4MHz.conf 
   sudo ../../PocketSDR/app/pocket_conf/pocket_conf pocket_L1L1_4MHz.conf 
   sudo ../../PocketSDR/app/pocket_conf/pocket_conf pocket_L1L1_4MHz_cal.conf 
   sudo ../../PocketSDR/app/pocket_conf/pocket_conf pocket_L1L1_4MHz_cal.conf 
   # change frequency band (upper/lower VCO) introduces random phase
   for i in `seq 1 3`; do
      sudo ../../PocketSDR/app/pocket_dump/pocket_dump -t 2 /tmp/${j}_${i}_1.bin /tmp/${j}_${i}_2.bin
      x=`stat /tmp/${j}_${i}_1.bin | grep Size | cut -d: -f2 | cut -c 1-10 | sed 's/ //g' | sed 's/0//g'`;
      while true; do
        if [ -z $x ] 
        then
           echo 'empty'
           sudo ../../PocketSDR/app/pocket_dump/pocket_dump -t 2 /tmp/${j}_${i}_1.bin /tmp/${j}_${i}_2.bin
           x=`stat /tmp/${j}_${i}_1.bin | grep Size | cut -d: -f2 | cut -c 1-10 | sed 's/ //g' | sed 's/0//g'`;
        else
           break
        fi
        sleep 0.1
      done
   done
#   sudo uhubctl -l 2 -a 0  # power off on RPi4
#   sleep 1.2
#   sudo uhubctl -l 2 -a 1  # power on on RPi4
#   sleep 3.2
done
