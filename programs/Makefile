BUILD	=	f-build

all: do-nothing syscall-test fib init longloop

clean: do-nothing-clean syscall-test-clean fib-clean init-clean longloop-clean

do-nothing: do-nothing.asm
	$(BUILD) do-nothing-rom.vmx do-nothing.asm

do-nothing-clean:
	rm -fv do-nothing-rom.*

syscall-test: syscall-test.asm
	$(BUILD) syscall-test-rom.vmx syscall-test.asm

syscall-test-clean:
	rm -fv syscall-test-rom.*

fib: stub.asm fib.c utility.c syscall.asm stub_end.asm
	$(BUILD) fib-rom.vmx stub.asm fib.c utility.c syscall.asm stub_end.asm

fib-clean:
	rm -fv fib-rom.* utility.asm utility.s fib.asm fib.s

init: stub.asm init.c utility.c syscall.asm stub_end.asm
	$(BUILD) init-rom.vmx stub.asm init.c utility.c syscall.asm stub_end.asm

init-clean:
	rm -fv init-rom.* utility.asm utility.s init.asm init.s

longloop: stub.asm longloop.c utility.c syscall.asm stub_end.asm
	$(BUILD) longloop-rom.vmx stub.asm longloop.c utility.c syscall.asm stub_end.asm

longloop-clean:
	rm -fv longloop-rom.* utility.asm utility.s longloop.asm longloop.s

