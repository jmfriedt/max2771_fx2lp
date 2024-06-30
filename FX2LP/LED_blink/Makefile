AS = sdas8051
CC = sdcc
LD = sdcc

SDCCLIB = SDCClib
OBJCOPY = objcopy

MAIN = main
FX2LIB = ../fx2lib

SRCS := $(wildcard *.c)
SRCS += $(wildcard $(FX2LIB)/lib/*.c)
SRCS := $(filter-out $(FX2LIB)/lib/setupdat.c,$(SRCS))
SRCS += $(wildcard $(FX2LIB)/lib/interrupts/*.c)
OBJS = $(SRCS:.c=.rel)

CFLAGS += -mmcs51
CFLAGS += -I$(FX2LIB)/include

LDFLAGS += -mmcs51
LDFLAGS += --code-size 0x1c00
LDFLAGS += --xram-size 0x0200
LDFLAGS += --xram-loc 0x1c00

all: $(MAIN).hex

%.rel: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

%.hex: %.elf
	$(OBJCOPY) $< -Oihex $@

flash: $(MAIN).hex
	sudo cycfx2prog prg:$(MAIN).hex run

clean:
	rm -f $(MAIN).asm $(MAIN).lst $(MAIN).rst $(MAIN).sym $(MAIN).lk $(MAIN).elf $(MAIN).hex $(MAIN).map $(MAIN).mem $(MAIN).lk $(OBJS)
