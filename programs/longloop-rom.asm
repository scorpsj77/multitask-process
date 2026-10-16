# stub.asm
#
# Assembly to initialize a stack and then call main() to begin regular processing.

	.Code
	
__start:

	## Assume that sp is set to where the base of the stack should be.  Set the frame pointer to match.
	mv	fp,	sp

	## Perform the call.
	call	main

	## Request an EXIT.
	mv	a1,	a0			# Copy the return value from main() to the EXIT arg.
	li	a0,	0xca110001		# Set the system call request to EXIT.
	ecall


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
	.Code
int_to_hex:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	li	a0, 28 
	sw	a0, -20(s0) 
	j	utility_LBB0_1 
utility_LBB0_1:
	lw	a0, -20(s0) 
	bltz	a0, utility_LBB0_4 
	j	utility_LBB0_2 
utility_LBB0_2:
	lw	a0, -12(s0) 
	lw	a1, -20(s0) 
	srl	a0, a0, a1 
	andi	a0, a0, 15 
	sw	a0, -24(s0) 
	lw	a1, -24(s0) 
utility_Lpcrel_hi0:
	auipc	a0, %hi(%pcrel(int_to_hex.hex_digits))
	addi	a0, a0, %lo(%larel(int_to_hex.hex_digits,utility_Lpcrel_hi0))
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	lw	a1, -16(s0) 
	addi	a2, a1, 1 
	sw	a2, -16(s0) 
	sb	a0, 0(a1) 
	j	utility_LBB0_3 
utility_LBB0_3:
	lw	a0, -20(s0) 
	addi	a0, a0, -4 
	sw	a0, -20(s0) 
	j	utility_LBB0_1 
utility_LBB0_4:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end0:
	#	-- End function 
int_to_dec:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
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
utility_LBB1_3:
	lw	a0, -12(s0) 
	beqz	a0, utility_LBB1_5 
	j	utility_LBB1_4 
utility_LBB1_4:
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
utility_LBB1_6:
	lw	a0, -32(s0) 
	bltz	a0, utility_LBB1_8 
	j	utility_LBB1_7 
utility_LBB1_7:
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
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
utility_Lfunc_end1:
	#	-- End function 
print_dec:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	addi	a1, s0, -28 
	sw	a1, -32(s0) # 4-byte Folded Spill 
	call	int_to_dec 
	lw	a0, -32(s0) # 4-byte Folded Reload 
	call	print 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end2:
	#	-- End function 
print_hex:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	addi	a1, s0, -28 
	sw	a1, -32(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -32(s0) # 4-byte Folded Reload 
	call	print 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end3:
	#	-- End function 
string_length:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
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
utility_LBB4_3:
	lw	a0, -16(s0) 
	lbu	a0, 0(a0) 
	beqz	a0, utility_LBB4_5 
	j	utility_LBB4_4 
utility_LBB4_4:
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
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end4:
	#	-- End function 
string_compare:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
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
utility_LBB5_8:
	lw	a0, -16(s0) 
	lbu	a0, 0(a0) 
	lw	a1, -20(s0) 
	lbu	a1, 0(a1) 
	bne	a0, a1, utility_LBB5_12 
	j	utility_LBB5_9 
utility_LBB5_9:
	lw	a0, -16(s0) 
	lbu	a0, 0(a0) 
	bnez	a0, utility_LBB5_11 
	j	utility_LBB5_10 
utility_LBB5_10:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	utility_LBB5_16 
utility_LBB5_11:
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
utility_LBB5_15:
	j	utility_LBB5_8 
utility_LBB5_16:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end5:
	#	-- End function 
	.Numeric
int_to_hex.hex_digits:
	.Text
	.ascii	"0123456789abcdef"
# ===================================================================================================================================
# syscall.asm
#
# Small assembly functions to set up and perform system calls.  These allow regular user-level code to perform system calls as
# though they were regular function calls.
# ===================================================================================================================================



# ===================================================================================================================================
	.Code

	## noop()
noop:
	lw	a0,	SYSCALL_NOOP_CODE	# Load the exit syscall code into a0 (arg[0])
	ecall
	ret

	## exit()
	##   Arguments:
	##     a0:  The exit status of the terminating process.
exit:
	mv	a1,	a0			# Move the exit status into a1 (arg[1])
	lw	a0,	SYSCALL_EXIT_CODE	# Load the exit syscall code into a0 (arg[0])
	ecall
	ebreak					# If we reach here, something is terribly wrong.

	## print()
	##   Arguments:
	##     a0:  The null-terminated string (char array) to print to the console.
print:
	mv	a1,	a0			# Move the string pointer into a1 (arg[1])
	lw	a0,	SYSCALL_PRINT_CODE	# Load the print syscall code into a0 (arg[0])
	ecall
	ret

	## run()
	##   Arguments:
	##     a0:  The ROM number to load into the new process
	##   Returns:
	##     a0:  0 = success, 1 = invalid ROM number, 2 = insufficient RAM, 3 = other error
run:
	mv	a1,	a0			# Move the ROM number into a1 (arg[1])
	lw	a0,	SYSCALL_RUN_CODE	# Load the run syscall code into a0 (arg[0])
	ecall
	ret					# The return value of the syscall is the return value of this wrapper function.

# ===================================================================================================================================
	


# ===================================================================================================================================
	.Numeric

## The system call codes.
SYSCALL_NOOP_CODE:	0xca110000
SYSCALL_EXIT_CODE:	0xca110001
SYSCALL_PRINT_CODE:	0xca110002
SYSCALL_RUN_CODE:	0xca110003
# ===================================================================================================================================
	.Text

statics_limit:
	.ascii	"This is the end."
	
