	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"fib.c"
	.globl	fib                             # -- Begin function fib
	.p2align	2
	.type	fib,@function
fib:                                    # @fib
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	lw	a1, -16(s0)
	li	a0, 1
	blt	a0, a1, fib_LBB0_2
	j	fib_LBB0_1
fib_LBB0_1:
	lw	a0, -16(s0)
	sw	a0, -12(s0)
	j	fib_LBB0_3
fib_LBB0_2:
	lw	a0, -16(s0)
	addi	a0, a0, -1
	call	fib
	sw	a0, -20(s0)                     # 4-byte Folded Spill
	lw	a0, -16(s0)
	addi	a0, a0, -2
	call	fib
	mv	a1, a0
	lw	a0, -20(s0)                     # 4-byte Folded Reload
	add	a0, a0, a1
	sw	a0, -12(s0)
	j	fib_LBB0_3
fib_LBB0_3:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
fib_Lfunc_end0:
	.size	fib, fib_Lfunc_end0-fib
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	li	a0, 20
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	fib
	sw	a0, -16(s0)
fib_Lpcrel_hi0:
	auipc	a0, %pcrel_hi(fib_L.str)
	addi	a0, a0, %pcrel_lo(fib_Lpcrel_hi0)
	call	print
	lw	a0, -12(s0)
	call	print_dec
fib_Lpcrel_hi1:
	auipc	a0, %pcrel_hi(fib_L.str.1)
	addi	a0, a0, %pcrel_lo(fib_Lpcrel_hi1)
	call	print
	lw	a0, -16(s0)
	call	print_dec
fib_Lpcrel_hi2:
	auipc	a0, %pcrel_hi(fib_L.str.2)
	addi	a0, a0, %pcrel_lo(fib_Lpcrel_hi2)
	call	print
	li	a0, 0
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
fib_Lfunc_end1:
	.size	main, fib_Lfunc_end1-main
                                        # -- End function
	.type	fib_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
fib_L.str:
	.asciz	"fib("
	.size	fib_L.str, 5

	.type	fib_L.str.1,@object                # @.str.1
fib_L.str.1:
	.asciz	") = "
	.size	fib_L.str.1, 5

	.type	fib_L.str.2,@object                # @.str.2
fib_L.str.2:
	.asciz	"\n"
	.size	fib_L.str.2, 2

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym fib
	.addrsig_sym print
	.addrsig_sym print_dec
