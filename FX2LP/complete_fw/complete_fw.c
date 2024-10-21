#include <stdio.h>
#include <fx2regs.h>
#include <fx2macros.h>
#include <delay.h>
#include <autovector.h>
#include <setupdat.h>
#include <eputils.h>
#include <i2c.h>

#define ENA_VR_EE // enable EEPROM read and write vendor requests

// type defintions -------------------------------------------------------------
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;
typedef signed char int8_t;
typedef short int16_t;
typedef long int32_t;

static void load_default(void);
static void load_settings(void);
static void save_settings(void);
static void write_AD9851(uint32_t, uint8_t);

#define SYNCDELAY SYNCDELAY4

// https://www.keil.com/dd/docs/c51/silabs/shared/si8051base/endian.h
#define bswap16(x) (((x) >> 8) | ((x) << 8))
#define bswap32(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) \
                  | (((x) & 0x0000FF00) << 8) | ((x) << 24))

void jmfdelay(int i)
{int k;
 for (k=i;k>0;k--) {};}

// copied routines from setupdat.h
// constants and macros -------------------------------------------------------
#define VER_FW       0x10       // Firmware version
#define F_TCXO       24000      // TCXO frequency (kHz)
#define CSN1         0          // EZ-USB FX2 PD0  -> MAX2771 CH1 CSN
#define CSN2         1          // EZ-USB FX2 PD1  -> MAX2771 CH2 CSN
#define CSNAD9851    7          // EZ-USB FX2 PA7  -> AD9851 FQ_UD
#define SCLK         2          // EZ-USB FX2 PD2  -> MAX2771 SCLK
#define SDATA        3          // EZ-USB FX2 PD3 <-> MAX2771 SDATA
#define STAT1        4          // EZ-USB FX2 PD4 <-  MAX2771 CH1 LD
#define STAT2        5          // EZ-USB FX2 PD5 <-  MAX2771 CH2 LD
#define LED1         6          // EZ-USB FX2 PD6  -> LED1
#define LED2         7          // EZ-USB FX2 PD7  -> LED2
#define SCLK_CYC     3          // SPI SCLK delay // JMF 5 -> 3

#define VR_STAT      0x40       // USB vendor request: Get device info and status
#define VR_REG_READ  0x41       // USB vendor request: Read MAX2771 register
#define VR_REG_WRITE 0x42       // USB vendor request: Write MAX2771 register
#define VR_START     0x44       // USB vendor request: Start bulk transfer
#define VR_STOP      0x45       // USB vendor request: Stop bulk transfer
#define VR_RESET     0x46       // USB vendor request: Reset device
#define VR_SAVE      0x47       // USB vendor request: Save settings to EEPROM
#define VR_EE_READ   0x48       // USB vendor request: Read EEPROM
#define VR_EE_WRITE  0x49       // USB vendor request: Write EEPROM
#define VR_AD9851    0x50       // USB vendor request: Write AD9851

#define MAX_CH       2          // number of MAX2771 channels
#define MAX_ADDR     11         // number of MAX2771 registers

#define I2C_ADDR     0x51       // EEPROM I2C address (16 KB EEPROM)
#define EE_ADDR_0    0x2000     // EEPROM Writable address start
#define EE_ADDR_1    0x3FFF     // EEPROM Writable address end
#define EE_ADDR_H    0x3F00     // EEPROM MAX2771 settings header address
#define EE_ADDR_S    0x3F04     // EEPROM MAX2771 settings address
#define HEAD_REG     0xABC00CBA // MAX2771 settings header

#define BIT(port)    ((uint8_t)1<<(port))
#define WORD_(bytes) (((uint16_t)(bytes)[1]<<8) + (bytes)[0])

// default MAX2771 register settings -------------------------------------------
static uint32_t __xdata reg_default[][MAX_ADDR] = {
  {0xA2241797, 0x20550288, 0x0E9F21DC, 0x69888000, 0x00082008, 0x0647AE70,
   0x08000000, 0x00000000, 0x01E0F281, 0x00000002, 0x00000004},
  {0xA224A019, 0x28550288, 0x0E9F31DC, 0x78888000, 0x00062008, 0x004CCD70,
   0x08000000, 0x10000000, 0x01E0F281, 0x00000002, 0x00000004}
};
volatile __bit got_sud;

static void digitalWriteD(uint8_t , uint8_t );
static void digitalWriteA(uint8_t , uint8_t );

// start bulk trasfer ----------------------------------------------------------
static void start_bulk(void) {
  FIFORESET  = 0x80; SYNCDELAY; // NAK-ALL
  EP6FIFOCFG = 0x00; SYNCDELAY; // manual mode
  FIFORESET  = 0x06; SYNCDELAY; // reset EP6 FIFO
  EP6FIFOCFG = 0x0C; SYNCDELAY; // EP6FIFO: AUTOIN=ON, ZEROLENIN=1, WORDWIDE=BYTE
  FIFORESET  = 0x00; SYNCDELAY; // release NAK-ALL
}

// stop bulk trasfer -----------------------------------------------------------
static void stop_bulk(void) {
  EP6FIFOCFG = 0x04; SYNCDELAY; // EP6FIFO: AUTOIN=OFF, ZEROLENIN=1, WORDWIDE=BYTE
}

// SETUP routine ---------------------------------------------------------------
void setup(void) {
  uint32_t freq = 0x28F5C28F;      // AD9851 24 MHz frequency output
  CPUCS         = 0x12; SYNCDELAY; // CPU: CLKSPD=48MHz, CLKOE=FLOAT
  EP2FIFOCFG    = 0x00; SYNCDELAY; // EPxFIFO: WORDWIDE=BYTE (PD enabled)
  EP4FIFOCFG    = 0x00; SYNCDELAY;
  EP6FIFOCFG    = 0x00; SYNCDELAY;
  EP8FIFOCFG    = 0x00; SYNCDELAY;
  IFCONFIG      = 0x53; SYNCDELAY; // IFCLK=EXT, OUT_DIS, POL=INV, SLAVE_FIFO
  REVCTL        = 0x03; SYNCDELAY; // SLAVE-FIFO enabled
  EP2CFG        = 0x20; SYNCDELAY; // EP2: OFF, DIR=OUT, TYPE=BULK
  EP4CFG        = 0x20; SYNCDELAY; // EP4: OFF, DIR=OUT, TYPE=BULK
  EP6CFG        = 0xE0; SYNCDELAY; // EP6: ON, DIR=IN, TYPE=BULK, SIZE=512, BUF=4X
  EP8CFG        = 0x60; SYNCDELAY; // EP8: OFF, DIR=IN, TYPE=BULK
  FIFOPINPOLAR  = 0x00; SYNCDELAY; // SLAVE_FIFO_IF: PKTEND=ACT_H, SLWR=ACT_H
  EP6AUTOINLENH = 0x02; SYNCDELAY; // EP6AUTOIN: PACKETLEN=512
  EP6AUTOINLENL = 0x00; SYNCDELAY;
  FIFORESET     = 0x86; SYNCDELAY; // EP6FIFO: RESET
  FIFORESET     = 0x00; SYNCDELAY;
  
  digitalWriteD(CSN1, 1);
  digitalWriteD(CSN2, 1);
  digitalWriteA(CSNAD9851, 0); // low rest state, rise to transfer
  digitalWriteD(SCLK, 0);
//  freq=bswap32(freq);
  write_AD9851(freq, 0x01);

//  EZUSB_InitI2C();  // JMF
  load_default();
  load_settings();  // JMF

  jmfdelay(255);
  write_AD9851(freq, 0x01);
  start_bulk();
}

void main(void) {
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

// from PocketSDR
 setup();
// end PocketSDR

 while(TRUE) {
    if ( got_sud ) { handle_setupdata(); got_sud=FALSE;}
 }
}

// read port D bit -------------------------------------------------------------
static uint8_t digitalRead(uint8_t port) {
  OED &= ~BIT(port);
  return (IOD & BIT(port)) ? 1 : 0;
}

// write port D bit ------------------------------------------------------------
static void digitalWriteD(uint8_t port, uint8_t dat) {
  OED |= BIT(port);
  if (dat) IOD |= BIT(port); else IOD &= ~BIT(port);
}

// write port A bit ------------------------------------------------------------
static void digitalWriteA(uint8_t port, uint8_t dat) {
  OEA |= BIT(port);
  if (dat) IOA |= BIT(port); else IOA &= ~BIT(port);
}

// write SPI SCLK --------------------------------------------------------------
static void write_sclk(void) {
  digitalWriteD(SCLK, 1);
  jmfdelay(SCLK_CYC);
  digitalWriteD(SCLK, 0);
  jmfdelay(SCLK_CYC);
}

BOOL handle_get_descriptor(void) {
  return FALSE;
}

// write SPI SDATA -------------------------------------------------------------
static void write_sdata(uint8_t dat) {
  digitalWriteD(SDATA, dat);
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
  jmfdelay(SCLK_CYC);
}

// AD9851 is rising edge, LSB first, 5 bytes with 4 byte frequency (LSB to MSB) and 1 byte
// with {6xREFCLK=1, 0, 0, phase=00000}, ends with pulse on FQ_UD
static void write_AD9851(uint32_t freq, uint8_t ctrl) {
  int8_t i;
  jmfdelay(SCLK_CYC);
  digitalWriteA(CSNAD9851, 1);    // FQ_UD pulse to reset SPI bus
  jmfdelay(SCLK_CYC);
  digitalWriteA(CSNAD9851, 0);
  jmfdelay(SCLK_CYC);
  for (i = 0; i < 32; i++)        // AD9851 is LSB first
     write_sdata((uint8_t)(freq >> i) & 1);
  for (i = 0; i < 8; i++) 
     write_sdata((uint8_t)(ctrl >> i) & 1);
  jmfdelay(SCLK_CYC);
  digitalWriteA(CSNAD9851, 1);    // FQ_UD pulse
  jmfdelay(SCLK_CYC);
  digitalWriteA(CSNAD9851, 0);
}

// write MAX2771 register ------------------------------------------------------
static void write_reg(uint8_t cs, uint8_t addr, uint32_t val) {
  int8_t i;
  
  digitalWriteD(cs, 0);
  write_head(addr, 0);
  
  for (i = 31; i >= 0; i--) {     // MAX2771 is MSB first
    write_sdata((uint8_t)(val >> i) & 1);
  }
  digitalWriteD(cs, 1);
}

// read MAX2771 register -------------------------------------------------------
static uint32_t read_reg(uint8_t cs, uint8_t addr) {
  uint32_t val = 0;
  int8_t i;
  
  digitalWriteD(cs, 0);
  write_head(addr, 1);
  
  for (i = 31; i >= 0; i--) {
    val <<= 1;
    val |= read_sdata();
  }
  digitalWriteD(cs, 1);
  return val;
}

BOOL handle_vendorcommand(BYTE cmd) {
 uint16_t len = WORD_(SETUPDAT + 6);
 uint16_t val = WORD_(SETUPDAT + 2);
 uint32_t val32;
 uint8_t ctrl;
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
  { val32=read_reg(SETUPDAT[3], SETUPDAT[2]);
    *(uint32_t *)EP0BUF = bswap32(val32);                        // JMF endianness change
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
    val32=*(uint32_t *)EP0BUF;
    val32=bswap32(val32);
    // write_reg(SETUPDAT[3], SETUPDAT[2], *(uint32_t *)EP0BUF); // JMF endianness change
    write_reg(SETUPDAT[3], SETUPDAT[2], val32);
    return TRUE;
    break;
  }
 case VR_START:
  { EP0BCH = EP0BCL = 0;
    start_bulk();
    return TRUE;
    break;
  }
  case VR_STOP:
  { EP0BCH = EP0BCL = 0;
    stop_bulk();
    return TRUE;
    break;
  }
  case VR_RESET:
  { EP0BCH = EP0BCL = 0;
    stop_bulk();
    setup();
    return TRUE;
    break;
  }
  case VR_SAVE: 
  { EP0BCH = EP0BCL = 0;
    save_settings();
    return TRUE;
    break;
  }
#ifdef ENA_VR_EE // disabled to save code size
  case VR_EE_READ: 
  { if (len > 64) return TRUE;
    eeprom_read(I2C_ADDR, val, (uint8_t)len, EP0BUF);
    EP0BCH = 0;
    EP0BCL = (uint8_t)len;
    return TRUE;
    break;
  }
  case VR_EE_WRITE: 
  {// if (len > 64 || val < EE_ADDR_0 || val + len > EE_ADDR_1) {
   //     return TRUE;
   // }
    if (len <= 64)
      {
       EP0BCH = EP0BCL = 0;
       while (EP0CS & bmEPBUSY) ;
       eeprom_write(I2C_ADDR, val, (uint8_t)len, EP0BUF);
      }
    return TRUE;
    break;
  }
#endif
  case VR_AD9851: 
  {
    if (len < 5) return TRUE;
    EP0BCH = EP0BCL = 0;
    while (EP0CS & bmEPBUSY) ;
    val32=*(uint32_t *)EP0BUF;  // freq
    val32=bswap32(val32);
    ctrl=EP0BUF[4];
    write_AD9851(val32, ctrl);
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

// load default MAX2771 register settings --------------------------------------
static void load_default(void) {
  uint8_t cs, addr;
  
  for (cs = 0; cs < MAX_CH; cs++) {
    for (addr = 0; addr < MAX_ADDR; addr++) {
      write_reg(cs, addr, reg_default[cs][addr]);
    }
  }
}

// load MAX2771 register settings from EEPROM ----------------------------------
static void load_settings(void) {
  uint16_t ee_addr = EE_ADDR_S;
  uint32_t __xdata reg;
  uint8_t cs, addr;
  
  eeprom_read(I2C_ADDR, EE_ADDR_H, 4, (uint8_t __xdata *)&reg);
  if (reg != HEAD_REG) return;
  
  for (cs = 0; cs < MAX_CH; cs++) {
    for (addr = 0; addr < MAX_ADDR; addr++) {
      eeprom_read(I2C_ADDR, ee_addr, 4, (uint8_t __xdata *)&reg);
      write_reg(cs, addr, reg);
      ee_addr += 4;
    }
  }
}

// save MAX2771 register settings to EEPROM ------------------------------------
static void save_settings(void) {
  uint16_t ee_addr = EE_ADDR_S;
  uint32_t __xdata reg = HEAD_REG;
  uint8_t cs, addr;
  
  eeprom_write(I2C_ADDR, EE_ADDR_H, 4, (uint8_t __xdata *)&reg);
  
  for (cs = 0; cs < MAX_CH; cs++) {
    for (addr = 0; addr < MAX_ADDR; addr++) {
      reg = read_reg(cs, addr);
      eeprom_write(I2C_ADDR, ee_addr, 4, (uint8_t __xdata *)&reg);
      ee_addr += 4;
    }
  }
}
