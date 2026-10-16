	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"heap_alloc.c"
	.globl	heap_init                       # -- Begin function heap_init
	.p2align	2
	.type	heap_init,@function
heap_init:                              # @heap_init
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
heap_alloc_Lpcrel_hi0:
	auipc	a0, %pcrel_hi(heap_limit)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi0)
	lw	a0, 0(a0)
	beqz	a0, heap_alloc_LBB0_2
	j	heap_alloc_LBB0_1
heap_alloc_LBB0_1:
	j	heap_alloc_LBB0_3
heap_alloc_LBB0_2:
heap_alloc_Lpcrel_hi1:
	auipc	a0, %pcrel_hi(heap_limit)
	addi	a1, a0, %pcrel_lo(heap_alloc_Lpcrel_hi1)
heap_alloc_Lpcrel_hi2:
	auipc	a0, %pcrel_hi(statics_limit)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi2)
	sw	a0, 0(a1)
heap_alloc_Lpcrel_hi3:
	auipc	a0, %pcrel_hi(free_head)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi3)
heap_alloc_Lpcrel_hi4:
	auipc	a1, %pcrel_hi(free_tail)
	addi	a1, a1, %pcrel_lo(heap_alloc_Lpcrel_hi4)
	sw	a1, 4(a0)
	sw	a0, 8(a1)
	j	heap_alloc_LBB0_3
heap_alloc_LBB0_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
heap_alloc_Lfunc_end0:
	.size	heap_init, heap_alloc_Lfunc_end0-heap_init
                                        # -- End function
	.globl	allocate                        # -- Begin function allocate
	.p2align	2
	.type	allocate,@function
allocate:                               # @allocate
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
heap_alloc_Lpcrel_hi5:
	auipc	a0, %pcrel_hi(heap_alloc_L.str)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi5)
	call	print
	lw	a0, -12(s0)
	call	print_dec
heap_alloc_Lpcrel_hi6:
	auipc	a0, %pcrel_hi(heap_alloc_L.str.1)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi6)
	call	print
	call	heap_init
	li	a0, 0
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	call	print_hex
heap_alloc_Lpcrel_hi7:
	auipc	a0, %pcrel_hi(heap_alloc_L.str.2)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi7)
	call	print
	lw	a0, -16(s0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
heap_alloc_Lfunc_end1:
	.size	allocate, heap_alloc_Lfunc_end1-allocate
                                        # -- End function
	.globl	deallocate                      # -- Begin function deallocate
	.p2align	2
	.type	deallocate,@function
deallocate:                             # @deallocate
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	bnez	a0, heap_alloc_LBB2_2
	j	heap_alloc_LBB2_1
heap_alloc_LBB2_1:
	j	heap_alloc_LBB2_3
heap_alloc_LBB2_2:
heap_alloc_Lpcrel_hi8:
	auipc	a0, %pcrel_hi(heap_alloc_L.str.3)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi8)
	call	print
	lw	a0, -12(s0)
	call	print_hex
heap_alloc_Lpcrel_hi9:
	auipc	a0, %pcrel_hi(heap_alloc_L.str.4)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi9)
	call	print
	lw	a0, -16(s0)
	lw	a0, 0(a0)
	call	print_dec
heap_alloc_Lpcrel_hi10:
	auipc	a0, %pcrel_hi(heap_alloc_L.str.5)
	addi	a0, a0, %pcrel_lo(heap_alloc_Lpcrel_hi10)
	call	print
	j	heap_alloc_LBB2_3
heap_alloc_LBB2_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
heap_alloc_Lfunc_end2:
	.size	deallocate, heap_alloc_Lfunc_end2-deallocate
                                        # -- End function
	.type	free_head,@object               # @free_head
	.bss
	.globl	free_head
	.p2align	2, 0x0
free_head:
	.zero	12
	.size	free_head, 12

	.type	free_tail,@object               # @free_tail
	.globl	free_tail
	.p2align	2, 0x0
free_tail:
	.zero	12
	.size	free_tail, 12

	.type	heap_limit,@object              # @heap_limit
	.section	.sbss,"aw",@nobits
	.globl	heap_limit
	.p2align	2, 0x0
heap_limit:
	.word	0                               # 0x0
	.size	heap_limit, 4

	.type	heap_alloc_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
heap_alloc_L.str:
	.asciz	"[debug: ] allocate("
	.size	heap_alloc_L.str, 20

	.type	heap_alloc_L.str.1,@object                # @.str.1
heap_alloc_L.str.1:
	.asciz	") -> 0x"
	.size	heap_alloc_L.str.1, 8

	.type	heap_alloc_L.str.2,@object                # @.str.2
heap_alloc_L.str.2:
	.asciz	"\n"
	.size	heap_alloc_L.str.2, 2

	.type	heap_alloc_L.str.3,@object                # @.str.3
heap_alloc_L.str.3:
	.asciz	"[debug: ] deallocate(0x"
	.size	heap_alloc_L.str.3, 24

	.type	heap_alloc_L.str.4,@object                # @.str.4
heap_alloc_L.str.4:
	.asciz	") [size = "
	.size	heap_alloc_L.str.4, 11

	.type	heap_alloc_L.str.5,@object                # @.str.5
heap_alloc_L.str.5:
	.asciz	"]\n"
	.size	heap_alloc_L.str.5, 3

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym heap_init
	.addrsig_sym print
	.addrsig_sym print_dec
	.addrsig_sym print_hex
	.addrsig_sym free_head
	.addrsig_sym free_tail
	.addrsig_sym heap_limit
	.addrsig_sym statics_limit
