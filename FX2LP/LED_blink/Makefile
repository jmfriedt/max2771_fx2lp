MAIN = mainPA
# MAIN = mainPD

CC = sdcc
FX2LIB = ../fx2lib

CFLAGS += -mmcs51
CFLAGS += -I$(FX2LIB)/include

LDFLAGS += -mmcs51
LDFLAGS += --code-size 0x1c00
LDFLAGS += --xram-size 0x0200
LDFLAGS += --xram-loc 0x1c00
LDFLAGS += -L$(FX2LIB)/lib

all: $(MAIN).ihx

$(MAIN).ihx: $(MAIN).c
	$(CC) $(CFLAGS) $(LDFLAGS) $^ fx2.lib

flash: $(MAIN).ihx
	sudo cycfx2prog prg:$(MAIN).ihx run

clean:
	rm -f $(MAIN).rel $(MAIN).asm $(MAIN).lst $(MAIN).rst $(MAIN).sym $(MAIN).lk $(MAIN).ihx $(MAIN).map $(MAIN).mem $(MAIN).lk
