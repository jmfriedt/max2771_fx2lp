# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: monitor_pvt.proto
"""Generated protocol buffer code."""
from google.protobuf.internal import builder as _builder
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x11monitor_pvt.proto\x12\x08gnss_sdr\"\x96\x05\n\nMonitorPvt\x12 \n\x18tow_at_current_symbol_ms\x18\x01 \x01(\r\x12\x0c\n\x04week\x18\x02 \x01(\r\x12\x0f\n\x07rx_time\x18\x03 \x01(\x01\x12\x17\n\x0fuser_clk_offset\x18\x04 \x01(\x01\x12\r\n\x05pos_x\x18\x05 \x01(\x01\x12\r\n\x05pos_y\x18\x06 \x01(\x01\x12\r\n\x05pos_z\x18\x07 \x01(\x01\x12\r\n\x05vel_x\x18\x08 \x01(\x01\x12\r\n\x05vel_y\x18\t \x01(\x01\x12\r\n\x05vel_z\x18\n \x01(\x01\x12\x0e\n\x06\x63ov_xx\x18\x0b \x01(\x01\x12\x0e\n\x06\x63ov_yy\x18\x0c \x01(\x01\x12\x0e\n\x06\x63ov_zz\x18\r \x01(\x01\x12\x0e\n\x06\x63ov_xy\x18\x0e \x01(\x01\x12\x0e\n\x06\x63ov_yz\x18\x0f \x01(\x01\x12\x0e\n\x06\x63ov_zx\x18\x10 \x01(\x01\x12\x10\n\x08latitude\x18\x11 \x01(\x01\x12\x11\n\tlongitude\x18\x12 \x01(\x01\x12\x0e\n\x06height\x18\x13 \x01(\x01\x12\x12\n\nvalid_sats\x18\x14 \x01(\r\x12\x17\n\x0fsolution_status\x18\x15 \x01(\r\x12\x15\n\rsolution_type\x18\x16 \x01(\r\x12\x17\n\x0f\x61r_ratio_factor\x18\x17 \x01(\x02\x12\x1a\n\x12\x61r_ratio_threshold\x18\x18 \x01(\x02\x12\x0c\n\x04gdop\x18\x19 \x01(\x01\x12\x0c\n\x04pdop\x18\x1a \x01(\x01\x12\x0c\n\x04hdop\x18\x1b \x01(\x01\x12\x0c\n\x04vdop\x18\x1c \x01(\x01\x12\x1a\n\x12user_clk_drift_ppm\x18\x1d \x01(\x01\x12\x10\n\x08utc_time\x18\x1e \x01(\t\x12\r\n\x05vel_e\x18\x1f \x01(\x01\x12\r\n\x05vel_n\x18  \x01(\x01\x12\r\n\x05vel_u\x18! \x01(\x01\x12\x0b\n\x03\x63og\x18\" \x01(\x01\x12\x15\n\rgalhas_status\x18# \x01(\r\x12\x0f\n\x07geohash\x18$ \x01(\tb\x06proto3')

_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, globals())
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'monitor_pvt_pb2', globals())
if _descriptor._USE_C_DESCRIPTORS == False:

  DESCRIPTOR._options = None
  _MONITORPVT._serialized_start=32
  _MONITORPVT._serialized_end=694
# @@protoc_insertion_point(module_scope)
