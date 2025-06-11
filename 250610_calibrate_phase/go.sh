REP=../../

sudo $REP/PocketSDR/app/pocket_conf/pocket_conf ./pocket_L1L1_4MHz.conf 
sleep 1
sudo $REP/PocketSDR/app/pocket_conf/pocket_conf ./pocket_L1L1_4MHz.conf 
sleep 1
sudo $REP/PocketSDR/app/pocket_dump/pocket_dump -r /tmp/ch12 &
python3 ./zmq_out.py &
