#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: MAX2771_transpose
# GNU Radio version: 3.10.10.0

from gnuradio import blocks
import pmt
from gnuradio import filter
from gnuradio.filter import firdes
from gnuradio import gr
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import zeromq




class MAX2771_transpose(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "MAX2771_transpose", catch_exceptions=True)

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 8e6
        self.filtre = filtre = firdes.low_pass(1.0, samp_rate, 2e6,2.2e6, window.WIN_HAMMING, 6.76)

        ##################################################
        # Blocks
        ##################################################

        self.zeromq_pub_sink_0 = zeromq.pub_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:5555', 100, False, (-1), '', True, True)
        self.freq_xlating_fir_filter_xxx_0 = filter.freq_xlating_fir_filter_fcc(4, filtre, 2e6, samp_rate)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, '/tmp/fifo1in', False, 0, 0)
        self.blocks_file_source_0.set_begin_tag(pmt.PMT_NIL)
        self.blocks_char_to_float_0 = blocks.char_to_float(1, 127)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_char_to_float_0, 0), (self.freq_xlating_fir_filter_xxx_0, 0))
        self.connect((self.blocks_file_source_0, 0), (self.blocks_char_to_float_0, 0))
        self.connect((self.freq_xlating_fir_filter_xxx_0, 0), (self.zeromq_pub_sink_0, 0))


    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.set_filtre(firdes.low_pass(1.0, self.samp_rate, 2e6, 2.2e6, window.WIN_HAMMING, 6.76))

    def get_filtre(self):
        return self.filtre

    def set_filtre(self, filtre):
        self.filtre = filtre
        self.freq_xlating_fir_filter_xxx_0.set_taps(self.filtre)




def main(top_block_cls=MAX2771_transpose, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    try:
        input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
