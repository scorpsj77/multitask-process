	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"init.c"
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	li	a0, 0
	sw	a0, -12(s0)
	li	a1, 4
	sw	a1, -16(s0)
	sb	a0, -17(s0)
	j	init_LBB0_1
init_LBB0_1:                                # =>This Inner Loop Header: Depth=1
	lbu	a0, -17(s0)
	andi	a0, a0, 1
	bnez	a0, init_LBB0_14
	j	init_LBB0_2
init_LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
init_Lpcrel_hi0:
	auipc	a0, %pcrel_hi(init_L.str)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi0)
	call	print
	lw	a0, -16(s0)
	call	print_dec
init_Lpcrel_hi1:
	auipc	a0, %pcrel_hi(init_L.str.1)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi1)
	call	print
	lw	a0, -16(s0)
	call	run
	sw	a0, -24(s0)
	lw	a1, -24(s0)
	li	a0, 0
	bge	a0, a1, init_LBB0_4
	j	init_LBB0_3
init_LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
init_Lpcrel_hi2:
	auipc	a0, %pcrel_hi(init_L.str.2)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi2)
	call	print
	lw	a0, -24(s0)
	call	print_dec
init_Lpcrel_hi3:
	auipc	a0, %pcrel_hi(init_L.str.1)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi3)
	call	print
	j	init_LBB0_13
init_LBB0_4:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -24(s0)
	li	a1, 101
	blt	a0, a1, init_LBB0_6
	j	init_LBB0_5
init_LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 1
	sb	a0, -17(s0)
init_Lpcrel_hi4:
	auipc	a0, %pcrel_hi(init_L.str.3)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi4)
	call	print
	lw	a0, -24(s0)
	call	print_dec
init_Lpcrel_hi5:
	auipc	a0, %pcrel_hi(init_L.str.1)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi5)
	call	print
	j	init_LBB0_12
init_LBB0_6:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -24(s0)
	sw	a0, -28(s0)                     # 4-byte Folded Spill
	addi	a0, a0, 3
	li	a1, 2
	bltu	a0, a1, init_LBB0_9
	j	init_LBB0_7
init_LBB0_7:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -28(s0)                     # 4-byte Folded Reload
	li	a1, -1
	bne	a0, a1, init_LBB0_10
	j	init_LBB0_8
init_LBB0_8:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 1
	sb	a0, -17(s0)
init_Lpcrel_hi6:
	auipc	a0, %pcrel_hi(init_L.str.4)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi6)
	call	print
	j	init_LBB0_11
init_LBB0_9:                                #   in Loop: Header=BB0_1 Depth=1
init_Lpcrel_hi7:
	auipc	a0, %pcrel_hi(init_L.str.5)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi7)
	call	print
	j	init_LBB0_11
init_LBB0_10:                               #   in Loop: Header=BB0_1 Depth=1
	li	a0, 1
	sb	a0, -17(s0)
init_Lpcrel_hi8:
	auipc	a0, %pcrel_hi(init_L.str.6)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi8)
	call	print
	lw	a0, -24(s0)
	call	print_dec
init_Lpcrel_hi9:
	auipc	a0, %pcrel_hi(init_L.str.1)
	addi	a0, a0, %pcrel_lo(init_Lpcrel_hi9)
	call	print
	j	init_LBB0_11
init_LBB0_11:                               #   in Loop: Header=BB0_1 Depth=1
	j	init_LBB0_12
init_LBB0_12:                               #   in Loop: Header=BB0_1 Depth=1
	j	init_LBB0_13
init_LBB0_13:                               #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	init_LBB0_1
init_LBB0_14:
	li	a0, 0
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
init_Lfunc_end0:
	.size	main, init_Lfunc_end0-main
                                        # -- End function
	.type	init_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
init_L.str:
	.asciz	"[init:  ] Running ROM #"
	.size	init_L.str, 24

	.type	init_L.str.1,@object                # @.str.1
init_L.str.1:
	.asciz	"\n"
	.size	init_L.str.1, 2

	.type	init_L.str.2,@object                # @.str.2
init_L.str.2:
	.asciz	"[init:  ] New pid = "
	.size	init_L.str.2, 21

	.type	init_L.str.3,@object                # @.str.3
init_L.str.3:
	.asciz	"[init:  ] Unexpectedly large pid = "
	.size	init_L.str.3, 36

	.type	init_L.str.4,@object                # @.str.4
init_L.str.4:
	.asciz	"[init:  ] No such ROM; done.\n"
	.size	init_L.str.4, 30

	.type	init_L.str.5,@object                # @.str.5
init_L.str.5:
	.asciz	"[init:  ] Memory allocation failure.\n"
	.size	init_L.str.5, 38

	.type	init_L.str.6,@object                # @.str.6
init_L.str.6:
	.asciz	"[init:  ] Unexpected result = "
	.size	init_L.str.6, 31

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym print
	.addrsig_sym print_dec
	.addrsig_sym run
