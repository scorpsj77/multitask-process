### ================================================================================================================================
### kernel_stub.asm
### Scott F. Kaplan -- sfkaplan@amherst.edu
###
### The assembly core that perform the basic initialization of the kernel, bootstrapping the installation of trap handlers and
### configuring the kernel's memory space.
###
### v.2025-02-11 : Load and execute a sequence of processes.
### v.2026-02-07 : Update for proper RISC-V calling conventions.
### v.2026-02-24 : Stripped down to move code into C functions.
### ================================================================================================================================


### ================================================================================================================================
	.Code
### ================================================================================================================================



### ================================================================================================================================
### Entry point.

__start:	
	## Find RAM.  Start the search at the beginning of the device table.
	lw		t0,		device_table_base			# [t0] dt_current = &device_table[0]
	lw		s0,		none_device_code			# [s0] none_device_code
	lw		s1,		RAM_device_code				# [s1] RAM_device_code
	
RAM_search_loop_top:

	## End the search with failure if we've reached the end of the table without finding RAM.
	lw		t1,		0(t0) 					# [t1] device_code = dt_current->type_code
	beq		t1,		s0,		RAM_search_failure 	# if (device_code == none_device_code)

	## If this entry is RAM, then end the loop successfully.
	beq		t1,		s1,		RAM_found 		# if (device_code == RAM_device_code)

	## This entry is not RAM, so advance to the next entry.
	addi		t0,		t0,		12 			# [t0] dt_current += dt_entry_size
	j		RAM_search_loop_top

RAM_search_failure:

	## Record a code to indicate the error, and then halt.
	lw		a0,		kernel_error_RAM_not_found
	halt

RAM_found:
	
	## RAM has been found.  If it is big enough, create a stack.
	lw		t1,		4(t0) 					# [t1] RAM_base  = dt_RAM->base
	lw		t2,		8(t0)					# [t2] RAM_limit = dt_RAM->limit
	sub		t0,		t2,		t1			# [t0] |RAM| = RAM_limit - RAM_base
	lw		t3,		min_RAM					# [t3] min_RAM
	blt		t0,		t3,		RAM_too_small		# if (|RAM| < min_RAM) ...
	lw		t3,		kernel_size				# [t3] ksize
	add		sp,		t1,		t3			# [sp] klimit = RAM_base + ksize : new stack
	mv		fp,		sp					# Initialize fp

	## Copy the RAM and kernel bases and limits to statically allocated spaces.
	sw		t1,		RAM_base,	t6
	sw		t2,		RAM_limit,	t6
	sw		t1,		kernel_base,	t6	
	sw		sp,		kernel_limit,	t6

	## Grab the DMA portal's address for later.
	lw		t0,		device_table_base			# [t0] device_table_base
	lw		t0,		8(t0)					# [t0] device_table_limit
	addi		t0,		t0,		-12			# [t0] DMA_portal_ptr
	sw		t0,		DMA_portal_ptr,	t6

	## With the stack initialized, call main() to begin booting proper.
	call		main

	## Wrap up and halt.  Termination code has already been returned by main() in a0.
	halt

RAM_too_small:
	## Set an error code and halt.
	lw		a0,		kernel_error_small_RAM
	halt
### ================================================================================================================================



### ================================================================================================================================
### Procedure: find_device
### Parameters:
###   [a0]: type     -- The device type to find.
###   [a1]: instance -- The instance of the given device type to find (e.g., the 3rd ROM).
### Return value:
###   [a0]: If found, a pointer to the correct device table entry, otherwise, null.

find_device:

	## Prologue: Initialize the locals.
	lw		t0,		device_table_base				# current_ptr = dt_base
	lw		t2,		none_device_code				# none_type
	
find_device_loop_top:

	## End the search with failure if we've reached the end of the table without finding the device.
	lw		t1,		0(t0)						# current_type = current_ptr->type
	beq		t1,		t2,		find_device_loop_failure	# while (current_type == none_type) {

	## If this entry matches the device type we seek, then decrement the instance count.  If the instance count hits zero, then
	## the search ends successfully.
	bne		t1,		a0,		find_device_continue_loop	#   if (current_type == type) {
	addi		a1,		a1,		-1				#     instance--
	beqz		a1,		find_device_loop_success			#     if (instance == 0) break }
	
find_device_continue_loop:	

	## Advance to the next entry.
	addi		t0,		t0,		12				#   current_ptr++
	j		find_device_loop_top						# }

find_device_loop_failure:

	## Set the return value to a null pointer.
	li		a0,		0						# rv = null
	j		find_device_return

find_device_loop_success:

	## Set the return pointer into the device table that currently points to the given iteration of the given type.
	mv		a0,		t0						# rv = current_ptr
	## Fall through...
	
find_device_return:

	## Epilogue: Return
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: print
### Parameters:
###   [a0]: str_ptr -- A pointer to the beginning of a null-terminated string.
### Return value:
###   <none>
### Locals:
###   [s1]: current_ptr        -- Pointer to the current position in the string.
###   [s2]: console_buffer_end -- The console buffer's limit.
###   [s3]: cursor_column      -- The current cursor column (always on the bottom row).
###   [s4]: newline_char       -- A copy of the newline character.
###   [s5]: cursor_char        -- A copy of the cursor character.
###   [s6]: console_width      -- The console's width.
	
print:

	## Callee prologue: Push preserved registers.
	addi		sp,		sp,		-32			# Push & preserve ra / fp / s[1-6]
	sw		ra,		28(sp)
	sw		fp,		24(sp)
	sw		s1,		20(sp)
	sw		s2,		16(sp)
	sw		s3,		12(sp)
	sw		s4,		8(sp)
	sw		s5,		4(sp)
	sw		s6,		0(sp)
	addi		fp,		sp,		32

	## Initialize locals.
	mv		s1,		a0					# current_ptr = str_ptr
	lw		s2,		console_limit				# console_limit
	addi		s2,		s2,		-4			# console_buffer_end = console_limit - |word|
										#   (offset portal)
	lw		s3,		cursor_column				# cursor_column
	lb		s4,		newline_char
	lb		s5,		cursor_char
	lw		s6,		console_width

	## Loop through the characters of the given string until the terminating null character is found.
_string_loop_top:
	lb		t0,		0(s1)					# [t0] current_char = *current_ptr

	## The loop should end if this is a null character
	beqz		t0,		_string_loop_end

	## Scroll without copying the character if this is a newline.
	beq		t0,		s4,		_print_scroll_call

	## Assume that the cursor is in a valid location.  Copy the current character into it.
	sub		t1,		s2,		s6			# [t0] = console[limit] - width
	add		t1,		t1,		s3			#      = console[limit] - width + cursor_column
	sb		t0,		0(t1)					# Display current char @t1.
	
	## Advance the cursor, scrolling if necessary.
	addi		s3,		s3,		1			# cursor_column++
	blt		s3,		s6,		_print_scroll_end       # Skip scrolling if cursor_column < width

_print_scroll_call:
	sw		s3,		cursor_column,	t6			# Store cursor_column
	call		scroll_console
	lw		s3,		cursor_column				# Restore cursor_column, which may have changed

_print_scroll_end:
	## Place the cursor character in its new position.
	sub		t1,		s2,		s6			# [t1] = console[limit] - width
	add		t1,		t1,		s3			#      = console[limit] - width + cursor_column
	sb		s5,		0(t1)					# Display cursor char @t1.
	
	## Iterate by advancing to the next character in the string.
	addi		s1,		s1,		1
	j		_string_loop_top

_string_loop_end:
	## Callee Epilogue...
	##   Store cursor_column back into statics.
	sw		s3,		cursor_column,	t6			# Store cursor_column (static)
	##   Pop and restore preserved registers, then return.
	lw		s6,		0(sp)					# Restore & pop fp + s[1-6]
	lw		s5,		4(sp)
	lw		s4,		8(sp)
	lw		s3,		12(sp)
	lw		s2,		16(sp)
	lw		s1,		20(sp)
	lw		fp,		24(sp)
	lw		ra,		28(sp)
	addi		sp,		sp,		32
	ret
### ================================================================================================================================

	

### ================================================================================================================================
### Procedure: scroll_console
### Description: Scroll the console and reset the cursor at the 0th column.
### Parameters:
###   <none>
### Return value:
###   <none>
### Locals:
###   [t0]: console_buffer_end / console_offset_ptr
###   [t1]: console_width
###   [t2]: console_buffer_begin
###   [t3]: cursor_column
###   [t4]: screen_size	
	
scroll_console:

	## Initialize locals.
	lw		t2,		console_base				# console_buffer_begin = console_base
	lw		t0,		console_limit				# console_limit
	addi		t0,		t0,		-4			# console_buffer_end = console_limit - |word|
	                                                                        #   (offset portal)
	lw		t1,		console_width				# console_width
	lw		t3,		cursor_column				# cursor_column
	lw		t4,		console_height				# t4 = console_height
	mul		t4,		t1,		t4			# screen_size = console_width * console_height
	
	## Blank the top line.
	lw		t5,		device_table_base       	        # t5 = dt_controller_ptr
	lw		t5,		8(t5)					#    = dt_controller_ptr->limit
	addi		t5,		t5,		-12			# DMA_portal_ptr = dt_controller_ptr->limit - 3*|word|
	la		t6,		blank_line				# t6 = &blank_line
	sw		t6,		0(t5)					# DMA_portal_ptr->src = &blank_line
	sw		t2,		4(t5)					# DMA_portal_ptr->dst = console_buffer_begin
	sw		t1,		8(t5)					# DMA_portal_ptr->len = console_width

	## Clear the cursor if it isn't off the end of the line.
	beq		t1,		t3,		_scroll_console_update_offset	# Skip if width == cursor_column
	sub		t5,		t0,		t1			# t5 = console_buffer_end - width
	add		t5,		t5,		t3			#    = console_buffer_end - width + cursor_column
	lb		t6,		space_char
	sb		t6,		0(t5)

	## Update the offset, wrapping around if needed.
_scroll_console_update_offset:
	lw		t6,		0(t0)					# [t6] offset
	add		t6,		t6,		t1			# offset += column_width
	rem		t6,		t6,		t4			# offset %= screen_size
	sw		t6,		0(t0)					# Set offset in console
	
	## Reset the cursor at the start of the new line.
	li		t3,		0					# cursor_column = 0
	sw		t3,		cursor_column,	t6			# Store cursor_column
	lb		t6,		cursor_char				# cursor_char
	sub		t5,		t0,		t1			# t5 = console_buffer_end - width (cursor_column == 0)	
	sb		t6,		0(t5)
	
	## Return.
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: halt_kernel
###   Does not return
	
halt_kernel:
	la		a0,		halting_msg					# Print halting.
	call		print
	halt	
### ================================================================================================================================
	


### ================================================================================================================================
### Procedure: userspace_jump
### Parameters:
###   [a0]: target -- The (virtual) address to which to jump.
###   [a1]: stack  -- The (virtual) stack pointer for restoration before the jump.
###   [a2]: base   -- The base physical address of the virtual space.
###   [a3]: limit  -- The limit physical address of the virtual space.
### Return value:
###   <does not return>

userspace_jump:

	# Load the context and target.
	csrw		epc,		a0
	mv		sp,		a1
	csrw		bs,		a2
	csrw		lm,		a3

	# Jump.
	eret
### ================================================================================================================================
	


### ================================================================================================================================
### Procedure: syscall_handler
### Return value:
###   <does not return>

syscall_handler:

	## Preserve the epc & sp, then reset the stack for the kernel.
	sw		sp,		preserved_sp,	t6
	csrr		sp,		epc
	sw		sp,		preserved_epc, 	t6
	lw		sp,		kernel_limit

	## Do the management.
	call		do_syscall
### ================================================================================================================================


	
### ================================================================================================================================
### Procedure: alarm_handler
### Return value:
###   <does not return>

alarm_handler:

	## Preserve the epc & sp, then reset the stack for the kernel.
	sw		sp,		preserved_sp,	t6
	csrr		sp,		epc
	sw		sp,		preserved_epc, 	t6
	lw		sp,		kernel_limit

	## Do the management.
	call		do_alarm
### ================================================================================================================================


	
### ================================================================================================================================
### Procedure: default_handler

default_handler:

	## Preserve the epc & sp, then reset the stack for the kernel.
	sw		sp,		preserved_sp,	t6
	csrr		sp,		epc
	sw		sp,		preserved_epc, 	t6
	lw		sp,		kernel_limit

	## This is a sign something went wrong, so stop and look around.
	ebreak

	## Print a message to show that we got here.
	la		a0,		default_handler_msg
	call		print
	
	## Then halt, because we don't know what to do next.
	lw		a0,		kernel_error_unmanaged_interrupt
	call		halt_kernel
### ================================================================================================================================


	
### ================================================================================================================================
### Procedure: init_trap_table
### Parameters:
###   [a0]: trap_base -- The address of the trap table to initialize and enable.
### Return value:
###   <none>

init_trap_table:

	## Set the 13 entries to point to some interrupt handler.
	la		t0,		default_handler				# t0 = default_handler()
	la		t1,		syscall_handler				# t1 = syscall_handler()
	la		t2,		alarm_handler				# t2 = alarm_handler()
	sw		t0,		0x00(a0)				# tt[INVALID_ADDRESS]      = default_handler()
	sw		t0,		0x04(a0)				# tt[INVALID_REGISTER]     = default_handler()
	sw		t0,		0x08(a0)				# tt[BUS_ERROR]            = default_handler()
	sw		t2,		0x0c(a0)				# tt[CLOCK_ALARM]          = alarm_handler()
	sw		t0,		0x10(a0)				# tt[DIVIDE_BY_ZERO]       = default_handler()
	sw		t0,		0x14(a0)				# tt[OVERFLOW]             = default_handler()
	sw		t0,		0x18(a0)				# tt[INVALID_INSTRUCTION]  = default_handler()
	sw		t0,		0x1c(a0)				# tt[PERMISSION_VIOLATION] = default_handler()
	sw		t0,		0x20(a0)				# tt[INVALID_SHIFT_AMOUNT] = default_handler()
	sw		t1,		0x24(a0)				# tt[SYSTEM_CALL]          = syscall_handler()
	sw		t0,		0x28(a0)				# tt[SYSTEM_BREAK]         = default_handler()
	sw		t0,		0x2c(a0)				# tt[INVALID_DEVICE_VALUE] = default_handler()
	sw		t0,		0x30(a0)				# tt[DEVICE_FAILURE]       = default_handler()

	## Set the TBR to point to the trap table.
	csrw		tb,		a0					# tb = trap_base
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: main
### Parameters:
###   <none>
### Return value:
###   <does not return>

main:

	## Callee prologue
	addi		sp,		sp,		-8				# Preserve ra / fp
	sw		ra,		4(sp)
	sw		fp,		0(sp)
	addi		fp,		sp,		8

	## Call find_device() to get console info.
	lw		a0,		console_device_code				# arg[0] = console_device_code
	li		a1,		1						# arg[1] = 1 (first instance)
	call		find_device							# [a0] rv = dt_console_ptr
	bnez		a0,		main_with_console				# if (dt_console_ptr == NULL) ...
	lw		a0,		kernel_error_console_not_found			# Return with failure code
	halt

main_with_console:
	## Copy the console base and limit into statics for later use.
	lw		t0,		4(a0)						# [t0] dt_console_ptr->base
	sw		t0,		console_base,		t6
	lw		t0,		8(a0)						# [t0] dt_console_ptr->limit
	sw		t0,		console_limit,		t6
	
	## Call print() on the banner and attribution.
	la		a0,		banner_msg					# arg[0] = banner_msg
	call		print
	la		a0,		attribution_msg					# arg[0] = attribution_msg
	call		print

	## Call init_trap_table().
	la		a0,		initializing_tt_msg				# arg[0] = initializing_tt_msg
	call		print
	la		a0,		trap_table
	call		init_trap_table
	la		a0,		done_msg					# arg[0] = done_msg
	call		print

	## Turn on virtual addressing.
	li		t0,		0x4
	csrs		md,		t0
	
	## Call run_programs() to invoke each program ROM in turn.
	call		run_init
### ================================================================================================================================
	

	
### ================================================================================================================================
	.Numeric

	## A special marker that indicates the beginning of the statics.  The value is just a magic cookie, in case any code wants
	## to check that this is the correct location (with high probability).
statics_start_marker:	0xdeadcafe

	## The trap table.  An array of 13 function pointers, to be initialized at runtime.
trap_table:             0
			0
			0
			0
			0
			0
			0
			0
			0
			0
			0
			0
			0

	## Device table location and codes.
device_table_base:	0x00001000
none_device_code:	0
controller_device_code:	1
ROM_device_code:	2
RAM_device_code:	3
console_device_code:	4
block_device_code:	5
clock_device_code:	6
random_device_code:	7

	## Error codes.
kernel_normal_exit:			0xffff0000
kernel_error_RAM_not_found:		0xffff0001
kernel_error_small_RAM:			0xffff0002	
kernel_error_console_not_found:		0xffff0003
kernel_error_unmanaged_interrupt:	0xffff0004

	## Constants for printing and console management.
console_width:		80
console_height:		24

	## Other constants.
min_RAM:		0x10000 # 64 KB = 0x40 KB * 0x400 B/KB
kernel_size:		0x8000	# 32 KB = 0x20 KB * 0x4 B/KB taken by the kernel.

	## Statically allocated variables.
cursor_column:		0	# The column position of the cursor (always on the last row).
RAM_base:		0
RAM_limit:		0
console_base:		0
console_limit:		0
kernel_base:		0
kernel_limit:		0
DMA_portal_ptr:		0
preserved_epc:		0	# Space to preserve the epc upon an interrupt.
preserved_sp:		0	# Space to preserve the sp  upon an interrupt.
### ================================================================================================================================



### ================================================================================================================================
	.Text

space_char:			" "
cursor_char:			"_"
newline_char:			"\n"
banner_msg:			"Fivish kernel v.2026-02-24\n"
attribution_msg:		"COSC-275 : Systems-II\n"
halting_msg:			"[kernel:] Halting..."
initializing_tt_msg:		"Initializing trap table..."
default_handler_msg:		"[kernel:] Default handler called.\n"
done_msg:			"done.\n"
failed_msg:			"failed!\n"
blank_line:			"                                                                                "
### ================================================================================================================================
	.Code
cpu_scheduler:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_Lpcrel_hi0:
	auipc	a0, %hi(%pcrel(preserved_epc))
	addi	a0, a0, %lo(%larel(preserved_epc,kernel_Lpcrel_hi0))
	lw	a0, 0(a0) 
kernel_Lpcrel_hi1:
	auipc	a1, %hi(%pcrel(preserved_sp))
	addi	a1, a1, %lo(%larel(preserved_sp,kernel_Lpcrel_hi1))
	lw	a1, 0(a1) 
kernel_Lpcrel_hi2:
	auipc	a2, %hi(%pcrel(user_base))
	addi	a2, a2, %lo(%larel(user_base,kernel_Lpcrel_hi2))
	lw	a2, 0(a2) 
kernel_Lpcrel_hi3:
	auipc	a3, %hi(%pcrel(user_limit))
	addi	a3, a3, %lo(%larel(user_limit,kernel_Lpcrel_hi3))
	lw	a3, 0(a3) 
	call	userspace_jump 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end0:
	#	-- End function 
run_next:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_Lpcrel_hi4:
	auipc	a0, %hi(%pcrel(kernel_L.str))
	addi	a0, a0, %lo(%larel(kernel_L.str,kernel_Lpcrel_hi4))
	call	print 
kernel_Lpcrel_hi5:
	auipc	a0, %hi(%pcrel(next_ROM_number))
	addi	a0, a0, %lo(%larel(next_ROM_number,kernel_Lpcrel_hi5))
	sw	a0, -16(s0) # 4-byte Folded Spill 
	lw	a0, 0(a0) 
	call	print_dec 
kernel_Lpcrel_hi6:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_Lpcrel_hi6))
	call	print 
	lw	a1, -16(s0) # 4-byte Folded Reload 
kernel_Lpcrel_hi7:
	auipc	a0, %hi(%pcrel(ROM_device_code))
	addi	a0, a0, %lo(%larel(ROM_device_code,kernel_Lpcrel_hi7))
	lw	a0, 0(a0) 
	lw	a1, 0(a1) 
	call	find_device 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, kernel_LBB1_2 
	j	kernel_LBB1_1 
kernel_LBB1_1:
	j	kernel_LBB1_3 
kernel_LBB1_2:
	lw	a0, -12(s0) 
	lw	a0, 4(a0) 
kernel_Lpcrel_hi8:
	auipc	a1, %hi(%pcrel(DMA_portal_ptr))
	addi	a1, a1, %lo(%larel(DMA_portal_ptr,kernel_Lpcrel_hi8))
	lw	a2, 0(a1) 
	sw	a0, 0(a2) 
kernel_Lpcrel_hi9:
	auipc	a0, %hi(%pcrel(user_base))
	addi	a0, a0, %lo(%larel(user_base,kernel_Lpcrel_hi9))
	lw	a0, 0(a0) 
	lw	a2, 0(a1) 
	sw	a0, 4(a2) 
	lw	a2, -12(s0) 
	lw	a0, 8(a2) 
	lw	a2, 4(a2) 
	sub	a0, a0, a2 
	lw	a1, 0(a1) 
	sw	a0, 8(a1) 
kernel_Lpcrel_hi10:
	auipc	a0, %hi(%pcrel(preserved_epc))
	addi	a1, a0, %lo(%larel(preserved_epc,kernel_Lpcrel_hi10))
	li	a0, 0 
	sw	a0, 0(a1) 
kernel_Lpcrel_hi11:
	auipc	a0, %hi(%pcrel(user_size))
	addi	a0, a0, %lo(%larel(user_size,kernel_Lpcrel_hi11))
	lw	a0, 0(a0) 
kernel_Lpcrel_hi12:
	auipc	a1, %hi(%pcrel(preserved_sp))
	addi	a1, a1, %lo(%larel(preserved_sp,kernel_Lpcrel_hi12))
	sw	a0, 0(a1) 
kernel_Lpcrel_hi13:
	auipc	a0, %hi(%pcrel(next_ROM_number))
	addi	a1, a0, %lo(%larel(next_ROM_number,kernel_Lpcrel_hi13))
	lw	a0, 0(a1) 
	addi	a0, a0, 1 
	sw	a0, 0(a1) 
	call	cpu_scheduler 
	j	kernel_LBB1_3 
kernel_LBB1_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end1:
	#	-- End function 
do_noop:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_Lpcrel_hi14:
	auipc	a0, %hi(%pcrel(kernel_L.str.2))
	addi	a0, a0, %lo(%larel(kernel_L.str.2,kernel_Lpcrel_hi14))
	call	print 
kernel_Lpcrel_hi15:
	auipc	a0, %hi(%pcrel(kernel_L.str.3))
	addi	a0, a0, %lo(%larel(kernel_L.str.3,kernel_Lpcrel_hi15))
	call	print 
kernel_Lpcrel_hi16:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_Lpcrel_hi16))
	call	print 
kernel_Lpcrel_hi17:
	auipc	a0, %hi(%pcrel(preserved_epc))
	addi	a1, a0, %lo(%larel(preserved_epc,kernel_Lpcrel_hi17))
	lw	a0, 0(a1) 
	addi	a0, a0, 4 
	sw	a0, 0(a1) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end2:
	#	-- End function 
do_exit:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
kernel_Lpcrel_hi18:
	auipc	a0, %hi(%pcrel(kernel_L.str.4))
	addi	a0, a0, %lo(%larel(kernel_L.str.4,kernel_Lpcrel_hi18))
	call	print 
	lw	a0, -12(s0) 
	call	print_dec 
kernel_Lpcrel_hi19:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_Lpcrel_hi19))
	call	print 
	call	run_next 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end3:
	#	-- End function 
do_print:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
kernel_Lpcrel_hi20:
	auipc	a1, %hi(%pcrel(user_base))
	addi	a1, a1, %lo(%larel(user_base,kernel_Lpcrel_hi20))
	lw	a1, 0(a1) 
	add	a0, a0, a1 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
kernel_Lpcrel_hi21:
	auipc	a1, %hi(%pcrel(user_limit))
	addi	a1, a1, %lo(%larel(user_limit,kernel_Lpcrel_hi21))
	lw	a1, 0(a1) 
	bltu	a0, a1, kernel_LBB4_2 
	j	kernel_LBB4_1 
kernel_LBB4_1:
	li	a0, -1 
	sw	a0, -12(s0) 
	j	kernel_LBB4_3 
kernel_LBB4_2:
	lw	a0, -16(s0) 
	call	print 
kernel_Lpcrel_hi22:
	auipc	a0, %hi(%pcrel(preserved_epc))
	addi	a1, a0, %lo(%larel(preserved_epc,kernel_Lpcrel_hi22))
	lw	a0, 0(a1) 
	addi	a0, a0, 4 
	sw	a0, 0(a1) 
	li	a0, 0 
	sw	a0, -12(s0) 
	j	kernel_LBB4_3 
kernel_LBB4_3:
	lw	a0, -12(s0) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end4:
	#	-- End function 
do_syscall:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, -17(s0) 
	sw	a0, -24(s0) 
	lw	a0, -12(s0) 
	lui	a1, 827664 
	bne	a0, a1, kernel_LBB5_2 
	j	kernel_LBB5_1 
kernel_LBB5_1:
	call	do_noop 
	j	kernel_LBB5_9 
kernel_LBB5_2:
	lw	a0, -12(s0) 
	lui	a1, 827664 
	addi	a1, a1, 1 
	bne	a0, a1, kernel_LBB5_4 
	j	kernel_LBB5_3 
kernel_LBB5_3:
	lw	a0, -16(s0) 
	call	do_exit 
kernel_Lpcrel_hi23:
	auipc	a0, %hi(%pcrel(kernel_L.str.5))
	addi	a0, a0, %lo(%larel(kernel_L.str.5,kernel_Lpcrel_hi23))
	call	print 
	call	halt_kernel 
	j	kernel_LBB5_8 
kernel_LBB5_4:
	lw	a0, -12(s0) 
	lui	a1, 827664 
	addi	a1, a1, 2 
	bne	a0, a1, kernel_LBB5_6 
	j	kernel_LBB5_5 
kernel_LBB5_5:
	li	a0, 1 
	sb	a0, -17(s0) 
	lw	a0, -16(s0) 
	call	do_print 
	sw	a0, -24(s0) 
	j	kernel_LBB5_7 
kernel_LBB5_6:
	li	a0, -1 
	sw	a0, -24(s0) 
	j	kernel_LBB5_7 
kernel_LBB5_7:
	j	kernel_LBB5_8 
kernel_LBB5_8:
	j	kernel_LBB5_9 
kernel_LBB5_9:
	lbu	a0, -17(s0) 
	andi	a0, a0, 1 
	beqz	a0, kernel_LBB5_11 
	j	kernel_LBB5_10 
kernel_LBB5_10:
kernel_Lpcrel_hi24:
	auipc	a0, %hi(%pcrel(user_base))
	addi	a0, a0, %lo(%larel(user_base,kernel_Lpcrel_hi24))
	lw	a0, 0(a0) 
kernel_Lpcrel_hi25:
	auipc	a1, %hi(%pcrel(preserved_sp))
	addi	a1, a1, %lo(%larel(preserved_sp,kernel_Lpcrel_hi25))
	lw	a1, 0(a1) 
	add	a0, a0, a1 
	addi	a0, a0, -36 
	sw	a0, -28(s0) 
	lw	a0, -24(s0) 
	lw	a1, -28(s0) 
	sw	a0, 0(a1) 
	j	kernel_LBB5_11 
kernel_LBB5_11:
	call	cpu_scheduler 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end5:
	#	-- End function 
do_alarm:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_Lpcrel_hi26:
	auipc	a0, %hi(%pcrel(kernel_L.str.6))
	addi	a0, a0, %lo(%larel(kernel_L.str.6,kernel_Lpcrel_hi26))
	call	print 
	call	cpu_scheduler 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end6:
	#	-- End function 
run_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_Lpcrel_hi27:
	auipc	a0, %hi(%pcrel(kernel_limit))
	addi	a0, a0, %lo(%larel(kernel_limit,kernel_Lpcrel_hi27))
	lw	a0, 0(a0) 
kernel_Lpcrel_hi28:
	auipc	a1, %hi(%pcrel(user_base))
	addi	a1, a1, %lo(%larel(user_base,kernel_Lpcrel_hi28))
	sw	a0, 0(a1) 
kernel_Lpcrel_hi29:
	auipc	a0, %hi(%pcrel(RAM_limit))
	addi	a0, a0, %lo(%larel(RAM_limit,kernel_Lpcrel_hi29))
	lw	a2, 0(a0) 
kernel_Lpcrel_hi30:
	auipc	a0, %hi(%pcrel(user_limit))
	addi	a0, a0, %lo(%larel(user_limit,kernel_Lpcrel_hi30))
	sw	a2, 0(a0) 
	lw	a0, 0(a0) 
	lw	a1, 0(a1) 
	sub	a0, a0, a1 
kernel_Lpcrel_hi31:
	auipc	a1, %hi(%pcrel(user_size))
	addi	a1, a1, %lo(%larel(user_size,kernel_Lpcrel_hi31))
	sw	a0, 0(a1) 
	call	run_next 
kernel_Lpcrel_hi32:
	auipc	a0, %hi(%pcrel(kernel_L.str.7))
	addi	a0, a0, %lo(%larel(kernel_L.str.7,kernel_Lpcrel_hi32))
	call	print 
	call	halt_kernel 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end7:
	#	-- End function 
next_ROM_number:
	.Numeric
	.word	3                               # 0x3
user_base:
	.word	0                               # 0x0
user_limit:
	.word	0                               # 0x0
user_size:
	.word	0                               # 0x0
kernel_L.str:
	.Text
	.asciz	"[kernel:] RUN ROM #"
kernel_L.str.1:
	.asciz	"\n"
kernel_L.str.2:
	.asciz	"[debug: ] "
kernel_L.str.3:
	.asciz	"NOOP requested"
kernel_L.str.4:
	.asciz	"[kernel:] EXIT process with status "
kernel_L.str.5:
	.asciz	"[kernel:] All processes terminated\n"
kernel_L.str.6:
	.asciz	"[kernel:] ALARM interrupt caught\n"
kernel_L.str.7:
	.asciz	"[kernel:] Failed to run, no user ROMs\n"
	.Code
heap_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
heap_alloc_Lpcrel_hi0:
	auipc	a0, %hi(%pcrel(heap_limit))
	addi	a0, a0, %lo(%larel(heap_limit,heap_alloc_Lpcrel_hi0))
	lw	a0, 0(a0) 
	beqz	a0, heap_alloc_LBB0_2 
	j	heap_alloc_LBB0_1 
heap_alloc_LBB0_1:
	j	heap_alloc_LBB0_3 
heap_alloc_LBB0_2:
heap_alloc_Lpcrel_hi1:
	auipc	a0, %hi(%pcrel(heap_limit))
	addi	a1, a0, %lo(%larel(heap_limit,heap_alloc_Lpcrel_hi1))
heap_alloc_Lpcrel_hi2:
	auipc	a0, %hi(%pcrel(statics_limit))
	addi	a0, a0, %lo(%larel(statics_limit,heap_alloc_Lpcrel_hi2))
	sw	a0, 0(a1) 
heap_alloc_Lpcrel_hi3:
	auipc	a0, %hi(%pcrel(free_head))
	addi	a0, a0, %lo(%larel(free_head,heap_alloc_Lpcrel_hi3))
heap_alloc_Lpcrel_hi4:
	auipc	a1, %hi(%pcrel(free_tail))
	addi	a1, a1, %lo(%larel(free_tail,heap_alloc_Lpcrel_hi4))
	sw	a1, 4(a0) 
	sw	a0, 8(a1) 
	j	heap_alloc_LBB0_3 
heap_alloc_LBB0_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
heap_alloc_Lfunc_end0:
	#	-- End function 
allocate:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
heap_alloc_Lpcrel_hi5:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str,heap_alloc_Lpcrel_hi5))
	call	print 
	lw	a0, -12(s0) 
	call	print_dec 
heap_alloc_Lpcrel_hi6:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.1))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.1,heap_alloc_Lpcrel_hi6))
	call	print 
	call	heap_init 
	li	a0, 0 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	call	print_hex 
heap_alloc_Lpcrel_hi7:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.2))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.2,heap_alloc_Lpcrel_hi7))
	call	print 
	lw	a0, -16(s0) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
heap_alloc_Lfunc_end1:
	#	-- End function 
deallocate:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, heap_alloc_LBB2_2 
	j	heap_alloc_LBB2_1 
heap_alloc_LBB2_1:
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_2:
heap_alloc_Lpcrel_hi8:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.3))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.3,heap_alloc_Lpcrel_hi8))
	call	print 
	lw	a0, -12(s0) 
	call	print_hex 
heap_alloc_Lpcrel_hi9:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.4))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.4,heap_alloc_Lpcrel_hi9))
	call	print 
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	call	print_dec 
heap_alloc_Lpcrel_hi10:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.5))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.5,heap_alloc_Lpcrel_hi10))
	call	print 
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
heap_alloc_Lfunc_end2:
	#	-- End function 
free_head:
	.Numeric
	.byte 0 0 0 0 0 0 0 0 0 0 0 0 
free_tail:
	.byte 0 0 0 0 0 0 0 0 0 0 0 0 
heap_limit:
	.word	0                               # 0x0
heap_alloc_L.str:
	.Text
	.asciz	"[debug: ] allocate("
heap_alloc_L.str.1:
	.asciz	") -> 0x"
heap_alloc_L.str.2:
	.asciz	"\n"
heap_alloc_L.str.3:
	.asciz	"[debug: ] deallocate(0x"
heap_alloc_L.str.4:
	.asciz	") [size = "
heap_alloc_L.str.5:
	.asciz	"]\n"
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
	j	io_LBB0_1 
io_LBB0_1:
	lw	a0, -20(s0) 
	bltz	a0, io_LBB0_4 
	j	io_LBB0_2 
io_LBB0_2:
	lw	a0, -12(s0) 
	lw	a1, -20(s0) 
	srl	a0, a0, a1 
	andi	a0, a0, 15 
	sw	a0, -24(s0) 
	lw	a1, -24(s0) 
io_Lpcrel_hi0:
	auipc	a0, %hi(%pcrel(int_to_hex.hex_digits))
	addi	a0, a0, %lo(%larel(int_to_hex.hex_digits,io_Lpcrel_hi0))
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	lw	a1, -16(s0) 
	addi	a2, a1, 1 
	sw	a2, -16(s0) 
	sb	a0, 0(a1) 
	j	io_LBB0_3 
io_LBB0_3:
	lw	a0, -20(s0) 
	addi	a0, a0, -4 
	sw	a0, -20(s0) 
	j	io_LBB0_1 
io_LBB0_4:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
io_Lfunc_end0:
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
	bnez	a0, io_LBB1_2 
	j	io_LBB1_1 
io_LBB1_1:
	lw	a1, -16(s0) 
	li	a0, 48 
	sb	a0, 0(a1) 
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 1(a1) 
	j	io_LBB1_9 
io_LBB1_2:
	li	a0, 0 
	sw	a0, -32(s0) 
	j	io_LBB1_3 
io_LBB1_3:
	lw	a0, -12(s0) 
	beqz	a0, io_LBB1_5 
	j	io_LBB1_4 
io_LBB1_4:
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
	j	io_LBB1_3 
io_LBB1_5:
	lw	a0, -32(s0) 
	addi	a0, a0, -1 
	sw	a0, -32(s0) 
	j	io_LBB1_6 
io_LBB1_6:
	lw	a0, -32(s0) 
	bltz	a0, io_LBB1_8 
	j	io_LBB1_7 
io_LBB1_7:
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
	j	io_LBB1_6 
io_LBB1_8:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	j	io_LBB1_9 
io_LBB1_9:
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
io_Lfunc_end1:
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
io_Lfunc_end2:
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
io_Lfunc_end3:
	#	-- End function 
	.Numeric
int_to_hex.hex_digits:
	.Text
	.ascii	"0123456789abcdef"
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
	.Text

statics_limit:
	.ascii	"This is the end."
