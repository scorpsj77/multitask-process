	.Code
main:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	li	a0, 0 
	sw	a0, -12(s0) 
	sw	a0, -16(s0) 
	j	longloop_LBB0_1 
longloop_LBB0_1:
	lw	a0, -16(s0) 
	lui	a1, 524288 
	addi	a1, a1, -1 
	beq	a0, a1, longloop_LBB0_6 
	j	longloop_LBB0_2 
longloop_LBB0_2:
	lw	a0, -16(s0) 
	srai	a1, a0, 31 
	srli	a1, a1, 16 
	add	a1, a0, a1 
	lui	a2, 1048560 
	and	a1, a1, a2 
	sub	a0, a0, a1 
	bnez	a0, longloop_LBB0_4 
	j	longloop_LBB0_3 
longloop_LBB0_3:
longloop_Lpcrel_hi0:
	auipc	a0, %hi(%pcrel(longloop_L.str))
	addi	a0, a0, %lo(%larel(longloop_L.str,longloop_Lpcrel_hi0))
	call	print 
	lw	a0, -16(s0) 
	call	print_dec 
longloop_Lpcrel_hi1:
	auipc	a0, %hi(%pcrel(longloop_L.str.1))
	addi	a0, a0, %lo(%larel(longloop_L.str.1,longloop_Lpcrel_hi1))
	call	print 
	j	longloop_LBB0_4 
longloop_LBB0_4:
	j	longloop_LBB0_5 
longloop_LBB0_5:
	lw	a0, -16(s0) 
	addi	a0, a0, 1 
	sw	a0, -16(s0) 
	j	longloop_LBB0_1 
longloop_LBB0_6:
	li	a0, 0 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
longloop_Lfunc_end0:
	#	-- End function 
longloop_L.str:
	.Text
	.asciz	"[longloop:] i = "
longloop_L.str.1:
	.asciz	"\n"
