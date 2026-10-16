BUILD	=	f-build

all: bios

clean: bios-clean

bios: bios.asm
	$(BUILD) bios-rom.vmx bios.asm

bios-clean:
	rm -fv bios-rom.*
