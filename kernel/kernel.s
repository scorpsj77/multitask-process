	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"kernel.c"
	.globl	cpu_scheduler                   # -- Begin function cpu_scheduler
	.p2align	2
	.type	cpu_scheduler,@function
cpu_scheduler:                          # @cpu_scheduler
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
kernel_Lpcrel_hi0:
	auipc	a0, %pcrel_hi(preserved_epc)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi0)
	lw	a0, 0(a0)
kernel_Lpcrel_hi1:
	auipc	a1, %pcrel_hi(preserved_sp)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi1)
	lw	a1, 0(a1)
kernel_Lpcrel_hi2:
	auipc	a2, %pcrel_hi(user_base)
	addi	a2, a2, %pcrel_lo(kernel_Lpcrel_hi2)
	lw	a2, 0(a2)
kernel_Lpcrel_hi3:
	auipc	a3, %pcrel_hi(user_limit)
	addi	a3, a3, %pcrel_lo(kernel_Lpcrel_hi3)
	lw	a3, 0(a3)
	call	userspace_jump
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end0:
	.size	cpu_scheduler, kernel_Lfunc_end0-cpu_scheduler
                                        # -- End function
	.globl	run_next                        # -- Begin function run_next
	.p2align	2
	.type	run_next,@function
run_next:                               # @run_next
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
kernel_Lpcrel_hi4:
	auipc	a0, %pcrel_hi(kernel_L.str)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi4)
	call	print
kernel_Lpcrel_hi5:
	auipc	a0, %pcrel_hi(next_ROM_number)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi5)
	sw	a0, -16(s0)                     # 4-byte Folded Spill
	lw	a0, 0(a0)
	call	print_dec
kernel_Lpcrel_hi6:
	auipc	a0, %pcrel_hi(kernel_L.str.1)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi6)
	call	print
	lw	a1, -16(s0)                     # 4-byte Folded Reload
kernel_Lpcrel_hi7:
	auipc	a0, %pcrel_hi(ROM_device_code)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi7)
	lw	a0, 0(a0)
	lw	a1, 0(a1)
	call	find_device
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	bnez	a0, kernel_LBB1_2
	j	kernel_LBB1_1
kernel_LBB1_1:
	j	kernel_LBB1_3
kernel_LBB1_2:
	lw	a0, -12(s0)
	lw	a0, 4(a0)
kernel_Lpcrel_hi8:
	auipc	a1, %pcrel_hi(DMA_portal_ptr)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi8)
	lw	a2, 0(a1)
	sw	a0, 0(a2)
kernel_Lpcrel_hi9:
	auipc	a0, %pcrel_hi(user_base)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi9)
	lw	a0, 0(a0)
	lw	a2, 0(a1)
	sw	a0, 4(a2)
	lw	a2, -12(s0)
	lw	a0, 8(a2)
	lw	a2, 4(a2)
	sub	a0, a0, a2
	lw	a1, 0(a1)
	sw	a0, 8(a1)
kernel_Lpcrel_hi10:
	auipc	a0, %pcrel_hi(preserved_epc)
	addi	a1, a0, %pcrel_lo(kernel_Lpcrel_hi10)
	li	a0, 0
	sw	a0, 0(a1)
kernel_Lpcrel_hi11:
	auipc	a0, %pcrel_hi(user_size)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi11)
	lw	a0, 0(a0)
kernel_Lpcrel_hi12:
	auipc	a1, %pcrel_hi(preserved_sp)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi12)
	sw	a0, 0(a1)
kernel_Lpcrel_hi13:
	auipc	a0, %pcrel_hi(next_ROM_number)
	addi	a1, a0, %pcrel_lo(kernel_Lpcrel_hi13)
	lw	a0, 0(a1)
	addi	a0, a0, 1
	sw	a0, 0(a1)
	call	cpu_scheduler
	j	kernel_LBB1_3
kernel_LBB1_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end1:
	.size	run_next, kernel_Lfunc_end1-run_next
                                        # -- End function
	.globl	do_noop                         # -- Begin function do_noop
	.p2align	2
	.type	do_noop,@function
do_noop:                                # @do_noop
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
kernel_Lpcrel_hi14:
	auipc	a0, %pcrel_hi(kernel_L.str.2)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi14)
	call	print
kernel_Lpcrel_hi15:
	auipc	a0, %pcrel_hi(kernel_L.str.3)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi15)
	call	print
kernel_Lpcrel_hi16:
	auipc	a0, %pcrel_hi(kernel_L.str.1)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi16)
	call	print
kernel_Lpcrel_hi17:
	auipc	a0, %pcrel_hi(preserved_epc)
	addi	a1, a0, %pcrel_lo(kernel_Lpcrel_hi17)
	lw	a0, 0(a1)
	addi	a0, a0, 4
	sw	a0, 0(a1)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end2:
	.size	do_noop, kernel_Lfunc_end2-do_noop
                                        # -- End function
	.globl	do_exit                         # -- Begin function do_exit
	.p2align	2
	.type	do_exit,@function
do_exit:                                # @do_exit
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
kernel_Lpcrel_hi18:
	auipc	a0, %pcrel_hi(kernel_L.str.4)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi18)
	call	print
	lw	a0, -12(s0)
	call	print_dec
kernel_Lpcrel_hi19:
	auipc	a0, %pcrel_hi(kernel_L.str.1)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi19)
	call	print
	call	run_next
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end3:
	.size	do_exit, kernel_Lfunc_end3-do_exit
                                        # -- End function
	.globl	do_print                        # -- Begin function do_print
	.p2align	2
	.type	do_print,@function
do_print:                               # @do_print
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -16(s0)
	lw	a0, -16(s0)
kernel_Lpcrel_hi20:
	auipc	a1, %pcrel_hi(user_base)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi20)
	lw	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -16(s0)
	lw	a0, -16(s0)
kernel_Lpcrel_hi21:
	auipc	a1, %pcrel_hi(user_limit)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi21)
	lw	a1, 0(a1)
	bltu	a0, a1, kernel_LBB4_2
	j	kernel_LBB4_1
kernel_LBB4_1:
	li	a0, -1
	sw	a0, -12(s0)
	j	kernel_LBB4_3
kernel_LBB4_2:
	lw	a0, -16(s0)
	call	print
kernel_Lpcrel_hi22:
	auipc	a0, %pcrel_hi(preserved_epc)
	addi	a1, a0, %pcrel_lo(kernel_Lpcrel_hi22)
	lw	a0, 0(a1)
	addi	a0, a0, 4
	sw	a0, 0(a1)
	li	a0, 0
	sw	a0, -12(s0)
	j	kernel_LBB4_3
kernel_LBB4_3:
	lw	a0, -12(s0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end4:
	.size	do_print, kernel_Lfunc_end4-do_print
                                        # -- End function
	.globl	do_syscall                      # -- Begin function do_syscall
	.p2align	2
	.type	do_syscall,@function
do_syscall:                             # @do_syscall
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sb	a0, -17(s0)
	sw	a0, -24(s0)
	lw	a0, -12(s0)
	lui	a1, 827664
	bne	a0, a1, kernel_LBB5_2
	j	kernel_LBB5_1
kernel_LBB5_1:
	call	do_noop
	j	kernel_LBB5_9
kernel_LBB5_2:
	lw	a0, -12(s0)
	lui	a1, 827664
	addi	a1, a1, 1
	bne	a0, a1, kernel_LBB5_4
	j	kernel_LBB5_3
kernel_LBB5_3:
	lw	a0, -16(s0)
	call	do_exit
kernel_Lpcrel_hi23:
	auipc	a0, %pcrel_hi(kernel_L.str.5)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi23)
	call	print
	call	halt_kernel
	j	kernel_LBB5_8
kernel_LBB5_4:
	lw	a0, -12(s0)
	lui	a1, 827664
	addi	a1, a1, 2
	bne	a0, a1, kernel_LBB5_6
	j	kernel_LBB5_5
kernel_LBB5_5:
	li	a0, 1
	sb	a0, -17(s0)
	lw	a0, -16(s0)
	call	do_print
	sw	a0, -24(s0)
	j	kernel_LBB5_7
kernel_LBB5_6:
	li	a0, -1
	sw	a0, -24(s0)
	j	kernel_LBB5_7
kernel_LBB5_7:
	j	kernel_LBB5_8
kernel_LBB5_8:
	j	kernel_LBB5_9
kernel_LBB5_9:
	lbu	a0, -17(s0)
	andi	a0, a0, 1
	beqz	a0, kernel_LBB5_11
	j	kernel_LBB5_10
kernel_LBB5_10:
kernel_Lpcrel_hi24:
	auipc	a0, %pcrel_hi(user_base)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi24)
	lw	a0, 0(a0)
kernel_Lpcrel_hi25:
	auipc	a1, %pcrel_hi(preserved_sp)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi25)
	lw	a1, 0(a1)
	add	a0, a0, a1
	addi	a0, a0, -36
	sw	a0, -28(s0)
	lw	a0, -24(s0)
	lw	a1, -28(s0)
	sw	a0, 0(a1)
	j	kernel_LBB5_11
kernel_LBB5_11:
	call	cpu_scheduler
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
kernel_Lfunc_end5:
	.size	do_syscall, kernel_Lfunc_end5-do_syscall
                                        # -- End function
	.globl	do_alarm                        # -- Begin function do_alarm
	.p2align	2
	.type	do_alarm,@function
do_alarm:                               # @do_alarm
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
kernel_Lpcrel_hi26:
	auipc	a0, %pcrel_hi(kernel_L.str.6)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi26)
	call	print
	call	cpu_scheduler
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end6:
	.size	do_alarm, kernel_Lfunc_end6-do_alarm
                                        # -- End function
	.globl	run_init                        # -- Begin function run_init
	.p2align	2
	.type	run_init,@function
run_init:                               # @run_init
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
kernel_Lpcrel_hi27:
	auipc	a0, %pcrel_hi(kernel_limit)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi27)
	lw	a0, 0(a0)
kernel_Lpcrel_hi28:
	auipc	a1, %pcrel_hi(user_base)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi28)
	sw	a0, 0(a1)
kernel_Lpcrel_hi29:
	auipc	a0, %pcrel_hi(RAM_limit)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi29)
	lw	a2, 0(a0)
kernel_Lpcrel_hi30:
	auipc	a0, %pcrel_hi(user_limit)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi30)
	sw	a2, 0(a0)
	lw	a0, 0(a0)
	lw	a1, 0(a1)
	sub	a0, a0, a1
kernel_Lpcrel_hi31:
	auipc	a1, %pcrel_hi(user_size)
	addi	a1, a1, %pcrel_lo(kernel_Lpcrel_hi31)
	sw	a0, 0(a1)
	call	run_next
kernel_Lpcrel_hi32:
	auipc	a0, %pcrel_hi(kernel_L.str.7)
	addi	a0, a0, %pcrel_lo(kernel_Lpcrel_hi32)
	call	print
	call	halt_kernel
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end7:
	.size	run_init, kernel_Lfunc_end7-run_init
                                        # -- End function
	.type	next_ROM_number,@object         # @next_ROM_number
	.section	.sdata,"aw",@progbits
	.globl	next_ROM_number
	.p2align	2, 0x0
next_ROM_number:
	.word	3                               # 0x3
	.size	next_ROM_number, 4

	.type	user_base,@object               # @user_base
	.section	.sbss,"aw",@nobits
	.globl	user_base
	.p2align	2, 0x0
user_base:
	.word	0                               # 0x0
	.size	user_base, 4

	.type	user_limit,@object              # @user_limit
	.globl	user_limit
	.p2align	2, 0x0
user_limit:
	.word	0                               # 0x0
	.size	user_limit, 4

	.type	user_size,@object               # @user_size
	.globl	user_size
	.p2align	2, 0x0
user_size:
	.word	0                               # 0x0
	.size	user_size, 4

	.type	kernel_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str:
	.asciz	"[kernel:] RUN ROM #"
	.size	kernel_L.str, 20

	.type	kernel_L.str.1,@object                # @.str.1
kernel_L.str.1:
	.asciz	"\n"
	.size	kernel_L.str.1, 2

	.type	kernel_L.str.2,@object                # @.str.2
kernel_L.str.2:
	.asciz	"[debug: ] "
	.size	kernel_L.str.2, 11

	.type	kernel_L.str.3,@object                # @.str.3
kernel_L.str.3:
	.asciz	"NOOP requested"
	.size	kernel_L.str.3, 15

	.type	kernel_L.str.4,@object                # @.str.4
kernel_L.str.4:
	.asciz	"[kernel:] EXIT process with status "
	.size	kernel_L.str.4, 36

	.type	kernel_L.str.5,@object                # @.str.5
kernel_L.str.5:
	.asciz	"[kernel:] All processes terminated\n"
	.size	kernel_L.str.5, 36

	.type	kernel_L.str.6,@object                # @.str.6
kernel_L.str.6:
	.asciz	"[kernel:] ALARM interrupt caught\n"
	.size	kernel_L.str.6, 34

	.type	kernel_L.str.7,@object                # @.str.7
kernel_L.str.7:
	.asciz	"[kernel:] Failed to run, no user ROMs\n"
	.size	kernel_L.str.7, 39

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym cpu_scheduler
	.addrsig_sym userspace_jump
	.addrsig_sym run_next
	.addrsig_sym print
	.addrsig_sym print_dec
	.addrsig_sym find_device
	.addrsig_sym do_noop
	.addrsig_sym do_exit
	.addrsig_sym do_print
	.addrsig_sym halt_kernel
	.addrsig_sym next_ROM_number
	.addrsig_sym user_base
	.addrsig_sym user_limit
	.addrsig_sym user_size
	.addrsig_sym preserved_epc
	.addrsig_sym preserved_sp
	.addrsig_sym ROM_device_code
	.addrsig_sym DMA_portal_ptr
	.addrsig_sym kernel_limit
	.addrsig_sym RAM_limit
