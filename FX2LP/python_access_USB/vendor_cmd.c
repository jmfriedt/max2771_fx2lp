#include <stdio.h>
#include <fx2regs.h>
#include <fx2macros.h>
#include <delay.h>
#include <autovector.h>
#include <setupdat.h>
#include <eputils.h>
#include <stdint.h>

#define SYNCDELAY SYNCDELAY4

volatile __bit got_sud;

void main(void) {
 REVCTL=0; // not using advanced endpoint controls
 got_sud=FALSE;

 RENUMERATE_UNCOND(); 
 SETCPUFREQ(CLK_48M);
 SETIF48MHZ();
 USE_USB_INTS(); 
 ENABLE_SUDAV();
 ENABLE_SOF();
 ENABLE_HISPEED();
 ENABLE_USBRESET();
 EA=1; // global interrupt enable 
 while(TRUE) {
    if ( got_sud ) { handle_setupdata(); got_sud=FALSE;}
 }
}

// copied routines from setupdat.h
// constants and macros -------------------------------------------------------
#define VER_FW       0x10       // Firmware version
#define F_TCXO       24000      // TCXO frequency (kHz)
#define CSN1         0          // EZ-USB FX2 PD0  -> MAX2771 CH1 CSN
#define CSN2         1          // EZ-USB FX2 PD1  -> MAX2771 CH2 CSN
#define SCLK         2          // EZ-USB FX2 PD2  -> MAX2771 SCLK
#define SDATA        3          // EZ-USB FX2 PD3 <-> MAX2771 SDATA
#define STAT1        4          // EZ-USB FX2 PD4 <-  MAX2771 CH1 LD
#define STAT2        5          // EZ-USB FX2 PD5 <-  MAX2771 CH2 LD
#define LED1         6          // EZ-USB FX2 PD6  -> LED1
#define LED2         7          // EZ-USB FX2 PD7  -> LED2
#define SCLK_CYC     5          // SPI SCLK delay

#define BIT(port)    ((uint8_t)1<<(port))
#define WORD_(bytes) (((uint16_t)(bytes)[1]<<8) + (bytes)[0])

// read port D bit -------------------------------------------------------------
static uint8_t digitalRead(uint8_t port) {
  OED &= ~BIT(port);
  return (IOD & BIT(port)) ? 1 : 0;
}

// write port D bit ------------------------------------------------------------
static void digitalWrite(uint8_t port, uint8_t dat) {
  OED |= BIT(port);
  if (dat) IOD |= BIT(port); else IOD &= ~BIT(port);
}

// write SPI SCLK --------------------------------------------------------------
static void write_sclk(void) {
  digitalWrite(SCLK, 1);
  delay(SCLK_CYC);
  digitalWrite(SCLK, 0);
  delay(SCLK_CYC);
}

BOOL handle_get_descriptor(void) {
  return FALSE;
}

// write SPI SDATA -------------------------------------------------------------
static void write_sdata(uint8_t dat) {
  digitalWrite(SDATA, dat);
  write_sclk();
}

// read SPI SDATA --------------------------------------------------------------
static uint8_t read_sdata(void) {
  uint8_t dat = digitalRead(SDATA);
  write_sclk();
  return dat;
}

// write MAX2771 SPI frame header ----------------------------------------------
static void write_head(uint16_t addr, uint8_t mode) {
  int8_t i;
  
  for (i = 11; i >= 0; i--) {
    write_sdata((uint8_t)(addr >> i) & 1);
  }
  write_sdata(mode); // 0:write,1:read
  
  for (i = 0; i < 3; i++) {
    write_sdata(0);
  }
  delay(SCLK_CYC);
}

// write MAX2771 register ------------------------------------------------------
static void write_reg(uint8_t cs, uint8_t addr, uint32_t val) {
  int8_t i;
  
  digitalWrite(cs, 0);
  write_head(addr, 0);
  
  for (i = 31; i >= 0; i--) {
    write_sdata((uint8_t)(val >> i) & 1);
  }
  digitalWrite(cs, 1);
}

// read MAX2771 register -------------------------------------------------------
static uint32_t read_reg(uint8_t cs, uint8_t addr) {
  uint32_t val = 0;
  int8_t i;
  
  digitalWrite(cs, 0);
  write_head(addr, 1);
  
  for (i = 31; i >= 0; i--) {
    val <<= 1;
    val |= read_sdata();
  }
  digitalWrite(cs, 1);
  return val;
}

// constants and macros -------------------------------------------------------
#define VER_FW       0x10       // Firmware version
#ifndef F_TCXO
#define F_TCXO       24000      // TCXO frequency (kHz)
#endif
#define CSN1         0          // EZ-USB FX2 PD0  -> MAX2771 CH1 CSN
#define CSN2         1          // EZ-USB FX2 PD1  -> MAX2771 CH2 CSN
#define SCLK         2          // EZ-USB FX2 PD2  -> MAX2771 SCLK
#define SDATA        3          // EZ-USB FX2 PD3 <-> MAX2771 SDATA
#define STAT1        4          // EZ-USB FX2 PD4 <-  MAX2771 CH1 LD
#define STAT2        5          // EZ-USB FX2 PD5 <-  MAX2771 CH2 LD
#define LED1         6          // EZ-USB FX2 PD6  -> LED1
#define LED2         7          // EZ-USB FX2 PD7  -> LED2
#define SCLK_CYC     5          // SPI SCLK delay

#define VR_STAT      0x40       // USB vendor request: Get device info and status
#define VR_REG_READ  0x41       // USB vendor request: Read MAX2771 register
#define VR_REG_WRITE 0x42       // USB vendor request: Write MAX2771 register
#define VR_START     0x44       // USB vendor request: Start bulk transfer
#define VR_STOP      0x45       // USB vendor request: Stop bulk transfer
#define VR_RESET     0x46       // USB vendor request: Reset device
#define VR_SAVE      0x47       // USB vendor request: Save settings to EEPROM
#define VR_EE_READ   0x48       // USB vendor request: Read EEPROM
#define VR_EE_WRITE  0x49       // USB vendor request: Write EEPROM

BOOL handle_vendorcommand(BYTE cmd) {
 uint16_t len = WORD_(SETUPDAT + 6);
 uint16_t val = WORD_(SETUPDAT + 2);
 switch ( cmd ) {
  case VR_STAT:
  {
    EP0BUF[0] = VER_FW;             // F/W version
    EP0BUF[1] = MSB(F_TCXO);        // TCXO Frequency (kHz)
    EP0BUF[2] = LSB(F_TCXO);
    EP0BUF[3] = digitalRead(STAT1); // MAX2771 CH1 PLL status (0:unlock,1:lock)
    EP0BUF[4] = digitalRead(STAT2); // MAX2771 CH2 PLL status (0:unlock,1:lock)
    EP0BUF[5] = digitalRead(LED2);  // Bulk transfer status (0:stop,1:start)
    EP0BCH = 0;
    EP0BCL = 6;
    return TRUE;
    break;
  }
  case VR_REG_READ:
  {*(uint32_t *)EP0BUF = read_reg(SETUPDAT[3], SETUPDAT[2]);
    EP0BCH = 0;
    EP0BCL = 4;
    return TRUE;
    break;
  }
  case VR_REG_WRITE:
  {
    if (len < 4) return TRUE;
    EP0BCH = EP0BCL = 0;
    while (EP0CS & bmEPBUSY) ;
    write_reg(SETUPDAT[3], SETUPDAT[2], *(uint32_t *)EP0BUF);
    return TRUE;
    break;
  }
  default:
 }
 return FALSE;
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
