# A test of system calls.

	.Code

	li	a0,	0xca110000	# NOOP
	ecall

	li	a0,	0xca110002	# PRINT
	la	a1,	msg
	ecall
	
	li	a0,	0xca110001	# EXIT
	li	a1,	0xd04e
	ecall
	
	.Text

msg:	"User program printing a message!\n"
	
