	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"mm_alloc.c"
	.globl	mm_init                         # -- Begin function mm_init
	.p2align	2
	.type	mm_init,@function
mm_init:                                # @mm_init
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
mm_alloc_Lpcrel_hi0:
	auipc	a0, %pcrel_hi(free_list_head)
	addi	a0, a0, %pcrel_lo(mm_alloc_Lpcrel_hi0)
	lw	a0, 0(a0)
	beqz	a0, mm_alloc_LBB0_2
	j	mm_alloc_LBB0_1
mm_alloc_LBB0_1:
	j	mm_alloc_LBB0_6
mm_alloc_LBB0_2:
mm_alloc_Lpcrel_hi1:
	auipc	a0, %pcrel_hi(kernel_limit)
	addi	a0, a0, %pcrel_lo(mm_alloc_Lpcrel_hi1)
	lw	a0, 0(a0)
	sw	a0, -12(s0)
	j	mm_alloc_LBB0_3
mm_alloc_LBB0_3:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -12(s0)
mm_alloc_Lpcrel_hi2:
	auipc	a1, %pcrel_hi(RAM_limit)
	addi	a1, a1, %pcrel_lo(mm_alloc_Lpcrel_hi2)
	lw	a1, 0(a1)
	bgeu	a0, a1, mm_alloc_LBB0_6
	j	mm_alloc_LBB0_4
mm_alloc_LBB0_4:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a0, -12(s0)
	sw	a0, -16(s0)
mm_alloc_Lpcrel_hi3:
	auipc	a0, %pcrel_hi(free_list_head)
	addi	a1, a0, %pcrel_lo(mm_alloc_Lpcrel_hi3)
	lw	a0, 0(a1)
	lw	a2, -16(s0)
	sw	a0, 0(a2)
	lw	a0, -16(s0)
	sw	a0, 0(a1)
	j	mm_alloc_LBB0_5
mm_alloc_LBB0_5:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a0, -12(s0)
	lui	a1, 8
	add	a0, a0, a1
	sw	a0, -12(s0)
	j	mm_alloc_LBB0_3
mm_alloc_LBB0_6:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
mm_alloc_Lfunc_end0:
	.size	mm_init, mm_alloc_Lfunc_end0-mm_init
                                        # -- End function
	.globl	mm_allocate                     # -- Begin function mm_allocate
	.p2align	2
	.type	mm_allocate,@function
mm_allocate:                            # @mm_allocate
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	call	mm_init
mm_alloc_Lpcrel_hi4:
	auipc	a0, %pcrel_hi(free_list_head)
	addi	a0, a0, %pcrel_lo(mm_alloc_Lpcrel_hi4)
	lw	a0, 0(a0)
	bnez	a0, mm_alloc_LBB1_2
	j	mm_alloc_LBB1_1
mm_alloc_LBB1_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	mm_alloc_LBB1_3
mm_alloc_LBB1_2:
mm_alloc_Lpcrel_hi5:
	auipc	a0, %pcrel_hi(free_list_head)
	addi	a1, a0, %pcrel_lo(mm_alloc_Lpcrel_hi5)
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
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
mm_alloc_Lfunc_end1:
	.size	mm_allocate, mm_alloc_Lfunc_end1-mm_allocate
                                        # -- End function
	.globl	mm_deallocate                   # -- Begin function mm_deallocate
	.p2align	2
	.type	mm_deallocate,@function
mm_deallocate:                          # @mm_deallocate
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
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
	auipc	a0, %pcrel_hi(free_list_head)
	addi	a1, a0, %pcrel_lo(mm_alloc_Lpcrel_hi6)
	lw	a0, 0(a1)
	lw	a2, -16(s0)
	sw	a0, 0(a2)
	lw	a0, -16(s0)
	sw	a0, 0(a1)
	j	mm_alloc_LBB2_3
mm_alloc_LBB2_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
mm_alloc_Lfunc_end2:
	.size	mm_deallocate, mm_alloc_Lfunc_end2-mm_deallocate
                                        # -- End function
	.type	free_list_head,@object          # @free_list_head
	.section	.sbss,"aw",@nobits
	.globl	free_list_head
	.p2align	2, 0x0
free_list_head:
	.word	0
	.size	free_list_head, 4

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym mm_init
	.addrsig_sym free_list_head
	.addrsig_sym kernel_limit
	.addrsig_sym RAM_limit
