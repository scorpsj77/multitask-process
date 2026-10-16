	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"utility.c"
	.globl	int_to_hex                      # -- Begin function int_to_hex
	.p2align	2
	.type	int_to_hex,@function
int_to_hex:                             # @int_to_hex
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 28
	sw	a0, -20(s0)
	j	utility_LBB0_1
utility_LBB0_1:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	bltz	a0, utility_LBB0_4
	j	utility_LBB0_2
utility_LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	srl	a0, a0, a1
	andi	a0, a0, 15
	sw	a0, -24(s0)
	lw	a1, -24(s0)
utility_Lpcrel_hi0:
	auipc	a0, %pcrel_hi(int_to_hex.hex_digits)
	addi	a0, a0, %pcrel_lo(utility_Lpcrel_hi0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	lw	a1, -16(s0)
	addi	a2, a1, 1
	sw	a2, -16(s0)
	sb	a0, 0(a1)
	j	utility_LBB0_3
utility_LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, -4
	sw	a0, -20(s0)
	j	utility_LBB0_1
utility_LBB0_4:
	lw	a1, -16(s0)
	li	a0, 0
	sb	a0, 0(a1)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
utility_Lfunc_end0:
	.size	int_to_hex, utility_Lfunc_end0-int_to_hex
                                        # -- End function
	.globl	int_to_dec                      # -- Begin function int_to_dec
	.p2align	2
	.type	int_to_dec,@function
int_to_dec:                             # @int_to_dec
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	bnez	a0, utility_LBB1_2
	j	utility_LBB1_1
utility_LBB1_1:
	lw	a1, -16(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	li	a0, 0
	sb	a0, 1(a1)
	j	utility_LBB1_9
utility_LBB1_2:
	li	a0, 0
	sw	a0, -32(s0)
	j	utility_LBB1_3
utility_LBB1_3:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -12(s0)
	beqz	a0, utility_LBB1_5
	j	utility_LBB1_4
utility_LBB1_4:                                #   in Loop: Header=BB1_3 Depth=1
	lw	a0, -12(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a2, a0, a1
	srli	a2, a2, 3
	li	a3, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	sw	a0, -36(s0)
	lw	a0, -12(s0)
	mulhu	a0, a0, a1
	srli	a0, a0, 3
	sw	a0, -12(s0)
	lw	a0, -36(s0)
	addi	a0, a0, 48
	lw	a2, -32(s0)
	addi	a1, a2, 1
	sw	a1, -32(s0)
	addi	a1, s0, -28
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	utility_LBB1_3
utility_LBB1_5:
	lw	a0, -32(s0)
	addi	a0, a0, -1
	sw	a0, -32(s0)
	j	utility_LBB1_6
utility_LBB1_6:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -32(s0)
	bltz	a0, utility_LBB1_8
	j	utility_LBB1_7
utility_LBB1_7:                                #   in Loop: Header=BB1_6 Depth=1
	lw	a1, -32(s0)
	addi	a0, a1, -1
	sw	a0, -32(s0)
	addi	a0, s0, -28
	add	a0, a0, a1
	lbu	a0, 0(a0)
	lw	a1, -16(s0)
	addi	a2, a1, 1
	sw	a2, -16(s0)
	sb	a0, 0(a1)
	j	utility_LBB1_6
utility_LBB1_8:
	lw	a1, -16(s0)
	li	a0, 0
	sb	a0, 0(a1)
	j	utility_LBB1_9
utility_LBB1_9:
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
utility_Lfunc_end1:
	.size	int_to_dec, utility_Lfunc_end1-int_to_dec
                                        # -- End function
	.globl	print_dec                       # -- Begin function print_dec
	.p2align	2
	.type	print_dec,@function
print_dec:                              # @print_dec
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	addi	a1, s0, -28
	sw	a1, -32(s0)                     # 4-byte Folded Spill
	call	int_to_dec
	lw	a0, -32(s0)                     # 4-byte Folded Reload
	call	print
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
utility_Lfunc_end2:
	.size	print_dec, utility_Lfunc_end2-print_dec
                                        # -- End function
	.globl	print_hex                       # -- Begin function print_hex
	.p2align	2
	.type	print_hex,@function
print_hex:                              # @print_hex
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	addi	a1, s0, -28
	sw	a1, -32(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -32(s0)                     # 4-byte Folded Reload
	call	print
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
utility_Lfunc_end3:
	.size	print_hex, utility_Lfunc_end3-print_hex
                                        # -- End function
	.globl	string_length                   # -- Begin function string_length
	.p2align	2
	.type	string_length,@function
string_length:                          # @string_length
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	bnez	a0, utility_LBB4_2
	j	utility_LBB4_1
utility_LBB4_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	utility_LBB4_6
utility_LBB4_2:
	li	a0, 0
	sw	a0, -20(s0)
	j	utility_LBB4_3
utility_LBB4_3:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	beqz	a0, utility_LBB4_5
	j	utility_LBB4_4
utility_LBB4_4:                                #   in Loop: Header=BB4_3 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	utility_LBB4_3
utility_LBB4_5:
	lw	a0, -20(s0)
	sw	a0, -12(s0)
	j	utility_LBB4_6
utility_LBB4_6:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
utility_Lfunc_end4:
	.size	string_length, utility_Lfunc_end4-string_length
                                        # -- End function
	.globl	string_compare                  # -- Begin function string_compare
	.p2align	2
	.type	string_compare,@function
string_compare:                         # @string_compare
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	sw	a1, -20(s0)
	lw	a0, -16(s0)
	bnez	a0, utility_LBB5_3
	j	utility_LBB5_1
utility_LBB5_1:
	lw	a0, -20(s0)
	bnez	a0, utility_LBB5_3
	j	utility_LBB5_2
utility_LBB5_2:
	li	a0, 0
	sw	a0, -12(s0)
	j	utility_LBB5_16
utility_LBB5_3:
	lw	a0, -16(s0)
	bnez	a0, utility_LBB5_5
	j	utility_LBB5_4
utility_LBB5_4:
	li	a0, 1
	sw	a0, -12(s0)
	j	utility_LBB5_16
utility_LBB5_5:
	lw	a0, -20(s0)
	bnez	a0, utility_LBB5_7
	j	utility_LBB5_6
utility_LBB5_6:
	li	a0, -1
	sw	a0, -12(s0)
	j	utility_LBB5_16
utility_LBB5_7:
	j	utility_LBB5_8
utility_LBB5_8:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	lw	a1, -20(s0)
	lbu	a1, 0(a1)
	bne	a0, a1, utility_LBB5_12
	j	utility_LBB5_9
utility_LBB5_9:                                #   in Loop: Header=BB5_8 Depth=1
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	bnez	a0, utility_LBB5_11
	j	utility_LBB5_10
utility_LBB5_10:
	li	a0, 0
	sw	a0, -12(s0)
	j	utility_LBB5_16
utility_LBB5_11:                               #   in Loop: Header=BB5_8 Depth=1
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	utility_LBB5_15
utility_LBB5_12:
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	lw	a1, -20(s0)
	lbu	a1, 0(a1)
	bge	a0, a1, utility_LBB5_14
	j	utility_LBB5_13
utility_LBB5_13:
	li	a0, -1
	sw	a0, -12(s0)
	j	utility_LBB5_16
utility_LBB5_14:
	li	a0, 1
	sw	a0, -12(s0)
	j	utility_LBB5_16
utility_LBB5_15:                               #   in Loop: Header=BB5_8 Depth=1
	j	utility_LBB5_8
utility_LBB5_16:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
utility_Lfunc_end5:
	.size	string_compare, utility_Lfunc_end5-string_compare
                                        # -- End function
	.type	int_to_hex.hex_digits,@object   # @int_to_hex.hex_digits
	.data
int_to_hex.hex_digits:
	.ascii	"0123456789abcdef"
	.size	int_to_hex.hex_digits, 16

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym int_to_hex
	.addrsig_sym int_to_dec
	.addrsig_sym print
	.addrsig_sym int_to_hex.hex_digits
