	.Code
mm_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
mm_alloc_Lpcrel_hi0:
	auipc	a0, %hi(%pcrel(free_list_head))
	addi	a0, a0, %lo(%larel(free_list_head,mm_alloc_Lpcrel_hi0))
	lw	a0, 0(a0) 
	beqz	a0, mm_alloc_LBB0_2 
	j	mm_alloc_LBB0_1 
mm_alloc_LBB0_1:
	j	mm_alloc_LBB0_6 
mm_alloc_LBB0_2:
mm_alloc_Lpcrel_hi1:
	auipc	a0, %hi(%pcrel(kernel_limit))
	addi	a0, a0, %lo(%larel(kernel_limit,mm_alloc_Lpcrel_hi1))
	lw	a0, 0(a0) 
	sw	a0, -12(s0) 
	j	mm_alloc_LBB0_3 
mm_alloc_LBB0_3:
	lw	a0, -12(s0) 
mm_alloc_Lpcrel_hi2:
	auipc	a1, %hi(%pcrel(RAM_limit))
	addi	a1, a1, %lo(%larel(RAM_limit,mm_alloc_Lpcrel_hi2))
	lw	a1, 0(a1) 
	bgeu	a0, a1, mm_alloc_LBB0_6 
	j	mm_alloc_LBB0_4 
mm_alloc_LBB0_4:
	lw	a0, -12(s0) 
	sw	a0, -16(s0) 
mm_alloc_Lpcrel_hi3:
	auipc	a0, %hi(%pcrel(free_list_head))
	addi	a1, a0, %lo(%larel(free_list_head,mm_alloc_Lpcrel_hi3))
	lw	a0, 0(a1) 
	lw	a2, -16(s0) 
	sw	a0, 0(a2) 
	lw	a0, -16(s0) 
	sw	a0, 0(a1) 
	j	mm_alloc_LBB0_5 
mm_alloc_LBB0_5:
	lw	a0, -12(s0) 
	lui	a1, 8 
	add	a0, a0, a1 
	sw	a0, -12(s0) 
	j	mm_alloc_LBB0_3 
mm_alloc_LBB0_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
mm_alloc_Lfunc_end0:
	#	-- End function 
mm_allocate:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	call	mm_init 
mm_alloc_Lpcrel_hi4:
	auipc	a0, %hi(%pcrel(free_list_head))
	addi	a0, a0, %lo(%larel(free_list_head,mm_alloc_Lpcrel_hi4))
	lw	a0, 0(a0) 
	bnez	a0, mm_alloc_LBB1_2 
	j	mm_alloc_LBB1_1 
mm_alloc_LBB1_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	mm_alloc_LBB1_3 
mm_alloc_LBB1_2:
mm_alloc_Lpcrel_hi5:
	auipc	a0, %hi(%pcrel(free_list_head))
	addi	a1, a0, %lo(%larel(free_list_head,mm_alloc_Lpcrel_hi5))
	lw	a0, 0(a1) 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	sw	a0, 0(a1) 
	lw	a1, -16(s0) 
	li	a0, 0 
	sw	a0, 0(a1) 
	lw	a0, -16(s0) 
	sw	a0, -12(s0) 
	j	mm_alloc_LBB1_3 
mm_alloc_LBB1_3:
	lw	a0, -12(s0) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
mm_alloc_Lfunc_end1:
	#	-- End function 
mm_deallocate:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, mm_alloc_LBB2_2 
	j	mm_alloc_LBB2_1 
mm_alloc_LBB2_1:
	j	mm_alloc_LBB2_3 
mm_alloc_LBB2_2:
	lw	a0, -12(s0) 
	sw	a0, -16(s0) 
mm_alloc_Lpcrel_hi6:
	auipc	a0, %hi(%pcrel(free_list_head))
	addi	a1, a0, %lo(%larel(free_list_head,mm_alloc_Lpcrel_hi6))
	lw	a0, 0(a1) 
	lw	a2, -16(s0) 
	sw	a0, 0(a2) 
	lw	a0, -16(s0) 
	sw	a0, 0(a1) 
	j	mm_alloc_LBB2_3 
mm_alloc_LBB2_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
mm_alloc_Lfunc_end2:
	#	-- End function 
free_list_head:
	.Numeric
	.word	0
