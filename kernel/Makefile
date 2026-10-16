BUILD	=	f-build

all: kernel

clean: kernel-clean

kernel: kernel_stub.h kernel_stub.asm kernel.c heap_alloc.h heap_alloc.c io.h io.c mm_alloc.h mm_alloc.c stub_end.asm
	$(BUILD) kernel-rom.vmx kernel_stub.asm kernel.c heap_alloc.c io.c mm_alloc.c stub_end.asm

kernel-clean:
	rm -fv kernel-rom.*                \
               kernel.s kernel.asm         \
               heap_alloc.s heap_alloc.asm \
               io.s io.asm                 \
               mm_alloc.s mm_alloc.asm
