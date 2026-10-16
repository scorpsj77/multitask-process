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


