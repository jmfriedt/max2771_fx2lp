REP=../../
for i in `seq 1 10`; do
   sudo $REP/PocketSDR/app/pocket_conf/pocket_conf ./pocket_L2L2_4MHz.conf 
   echo "config 2"
   for j in `seq 1 5`; do
      python3 ./zmq_process.py 
   done
   echo "config 1"
   sudo $REP/PocketSDR/app/pocket_conf/pocket_conf ./pocket_L1L1_4MHz.conf 
   for j in `seq 1 5`; do
      python3 ./zmq_process.py 
   done
done
