# rm ch*bin*
# sudo ../PocketSDR/app/pocket_conf/pocket_conf ./pocket_L1L1_40MHz.conf 
# sudo ../PocketSDR/app/pocket_conf/pocket_conf ./pocket_L1L1_32MHz.conf 
sudo ../PocketSDR/app/pocket_conf/pocket_conf ./pocket_L1L1_12MHz.conf 

for freq in 1085.42 1061.42 925.42 917.42 893.42 ; do
    echo $freq
   ./windfreak/windfreak $freq
#   reset
   sudo ../PocketSDR/app/pocket_dump/pocket_dump -t 3 /tmp/${freq}_1.bin /tmp/${freq}_2.bin
done

#jmfriedt@rugged:~/sdr/max2771/250608_no_preamp$ ./go.sh 
#Pocket SDR device settings are changed.
#1085.42
#1085.420044 MHz programmed
#  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
#      3.0   IQ     71958528  IQ     71958528      11953.2
#1061.42
#1061.420044 MHz programmed
#  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
#      3.0   IQ     72089600  IQ     72089600      11975.0
#925.42
#925.419983 MHz programmed
#  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
#      3.0   IQ     71958528  IQ     71958528      11969.1
#917.42
#917.419983 MHz programmed
#  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
#      3.0   IQ     71958528  IQ     71958528      11973.1
#893.42
#893.419983 MHz programmed
#  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
#      3.0   IQ     71958528  IQ     71958528      11973.1
