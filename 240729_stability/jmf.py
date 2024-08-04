import socket
from monitor_pvt_pb2 import MonitorPvt 
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("127.0.0.1", 1234))
foo = MonitorPvt()
m=0
while True:
    data, addr=sock.recvfrom(1500)
    foo.ParseFromString(data)
    print(f"{m}: TOW={foo.tow_at_current_symbol_ms} dt={foo.user_clk_offset} x={foo.pos_x} y={foo.pos_y} z={foo.pos_z} df={foo.user_clk_drift_ppm}")
    m=m+1

