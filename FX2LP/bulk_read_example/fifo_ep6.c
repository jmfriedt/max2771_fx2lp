#define ALLOCATE_EXTERN

#include <fx2regs.h>
#include <fx2macros.h>
#include <delay.h>    // needed for SYNCDELAY4
#include <fx2ints.h>
#include <autovector.h>

#include <stdio.h>
#include <setupdat.h>
#include <eputils.h>

#define SYNCDELAY SYNCDELAY4

volatile __bit got_sud;
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
{RENUMERATE_UNCOND(); // http://www.triplespark.net/elec/periph/USB-FX2/eeprom/
 SETCPUFREQ(CLK_48M); // set the CPU clock to 48MHz
 SETIF48MHZ();        // set the slave FIFO interface to 48MHz IFCONFIG |= 0x40;*/

 USE_USB_INTS();
 ENABLE_SUDAV();
 ENABLE_SOF();
 ENABLE_HISPEED();
 ENABLE_USBRESET();
 EA=1;

 // Set DYN_OUT and ENH_PKT bits, as recommended by the TRM.
 REVCTL = bmNOAUTOARM | bmSKIPCOMMIT; // REVCTL = 0x03;
 SYNCDELAY4;
 EP6CFG = 0xe2; SYNCDELAY4; // 1110 0010 (bulk IN, 512 bytes, double-buffered)
 FIFORESET = 0x80; SYNCDELAY4; // NAK all requests from host.
 FIFORESET = 0x82; SYNCDELAY4; // Reset individual EP (2,4,6,8)
 FIFORESET = 0x84; SYNCDELAY4;
 FIFORESET = 0x86; SYNCDELAY4;
 FIFORESET = 0x88; SYNCDELAY4;
 FIFORESET = 0x00; SYNCDELAY4; // Resume normal operation.
}

void main(void)
{got_sud=FALSE;
  initialize();
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
  while (1)
    {if ( got_sud ) { handle_setupdata(); got_sud=FALSE;} // needed to enumerate
     if (!(EP2468STAT & bmEP6FULL))   // Wait for EP6 buffer to become non-full
       { for (int i = 0; i < 512; i += 2)
          { EP6FIFOBUF[i] = IOB;     // fill buffer with port b and d
            EP6FIFOBUF[i + 1] = IOD;
            // EP6FIFOBUF[i] = 0x55; // for testing with fixed values
            // EP6FIFOBUF[i + 1] = 0xAA;
          }
          // Arm the endpoint. Set BCH *before* BCL because BCL access
          // actually arms the endpoint.
          EP6BCH = 0x02; // commit 512 bytes
          EP6BCL = 0x00;
        }
    }
}

// this firmware only supports 0,0
BOOL handle_get_interface(BYTE ifc, BYTE* alt_ifc) {
 if (ifc==0) {*alt_ifc=0; return TRUE;} else { return FALSE;}
}

BOOL handle_set_interface(BYTE ifc, BYTE alt_ifc) {
 if (ifc==0&&alt_ifc==0) {
    // SEE TRM 2.3.7
    // reset toggles
    RESETTOGGLE(0x02);
    RESETTOGGLE(0x86);
    // restore endpoints to default condition
    RESETFIFO(0x02);
    EP2BCL=0x80;
    SYNCDELAY;
    EP2BCL=0X80;
    SYNCDELAY;
    RESETFIFO(0x86);
    return TRUE;
 } else
    return FALSE;
}

// get/set configuration
BYTE handle_get_configuration(void) {
 return 1;
}

BOOL handle_set_configuration(BYTE cfg) {
 return cfg==1 ? TRUE : FALSE; // we only handle cfg 1
}

// copied usb jt routines from usbjt.h
void sudav_isr(void) __interrupt (SUDAV_ISR) {
  got_sud=TRUE;
  CLEAR_SUDAV();
}

void sof_isr (void) __interrupt (SOF_ISR) __using (1) {
  CLEAR_SOF();
}

void usbreset_isr(void) __interrupt (USBRESET_ISR) {
  handle_hispeed(FALSE);
  CLEAR_USBRESET();
}

void hispeed_isr(void) __interrupt (HISPEED_ISR) {
  handle_hispeed(TRUE);
  CLEAR_HISPEED();
}

BOOL handle_vendorcommand(BYTE cmd) { }

BOOL handle_get_descriptor(void) {
  return FALSE;
}
