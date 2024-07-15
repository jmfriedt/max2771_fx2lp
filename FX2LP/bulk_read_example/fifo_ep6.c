#define ALLOCATE_EXTERN

#include <fx2regs.h>
#include <fx2macros.h>
#include <delay.h>    // needed for SYNCDELAY4
#include <fx2ints.h>
#include <autovector.h>

volatile __bit led_flag;
volatile char t0_counter;

void timer0_isr(void) __interrupt (TF0_ISR)
{ t0_counter++;
  if (t0_counter == 20)
    { led_flag = 1-led_flag;
      if (led_flag) { PD7 = 0; }
      else { PD7 = 1; }
      t0_counter = 0;
    }
}

static void initialize(void)
{ SETCPUFREQ(CLK_48M); // set the CPU clock to 48MHz
  SETIF48MHZ();        // set the slave FIFO interface to 48MHz IFCONFIG |= 0x40;*/
  // Set DYN_OUT and ENH_PKT bits, as recommended by the TRM.
  REVCTL = bmNOAUTOARM | bmSKIPCOMMIT; // REVCTL = 0x03;
  SYNCDELAY4;

  /* out endpoints do not come up armed */
  /* set NAKALL bit to NAK all transfers from host */
  EP6CFG = 0xe2; SYNCDELAY4; // 1110 0010 (bulk IN, 512 bytes, double-buffered)
  FIFORESET = 0x80; SYNCDELAY4; // NAK all requests from host.
  FIFORESET = 0x82; SYNCDELAY4; // Reset individual EP (2,4,6,8)
  FIFORESET = 0x84; SYNCDELAY4;
  FIFORESET = 0x86; SYNCDELAY4;
  FIFORESET = 0x88; SYNCDELAY4;
  FIFORESET = 0x00; SYNCDELAY4; // Resume normal operation.
}

void main(void)
{ initialize();
  led_flag=0;
  // init timer 0 vvv
  t0_counter=0;
  TMOD = 0x11; 
  EA=1; // enable interrupts
  ENABLE_TIMER0();
  TR0=1; // start t0

  OEB = 0x0; SYNCDELAY4; // set PORT-B to input
  OED = 0x0; SYNCDELAY4; // set PORT-D to input
  OED = (1 << 7);        // PD7 as output for blinking the LED !
  for (;;)
    { 
      if (!(EP2468STAT & bmEP6FULL)) // Wait for EP6 buffer to become non-full
        { for (int i = 0; i < 512; i += 2)
            { EP6FIFOBUF[i] = IOB;     // fill buffer with port b and d
              EP6FIFOBUF[i + 1] = IOD;
              // EP6FIFOBUF[i] = 0x55;     // for testing with fixed values
              // EP6FIFOBUF[i + 1] = 0xAA;
            }
            // Arm the endpoint. Set BCH *before* BCL because BCL access
            // actually arms the endpoint.
            EP6BCH = 0x02; // commit 512 bytes
            EP6BCL = 0x00;
        }
    }
}
