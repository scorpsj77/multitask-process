/* =============================================================================================================================== */
/* INCLUDES */

#include <stdbool.h>
#include <stdint.h>

#include "heap_alloc.h"
#include "io.h"
#include "kernel_stub.h"
#include "mm_alloc.h"
#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* CONSTANTS */

#define INIT_ROM_NUMBER 3

#define SYSCALL_NOOP    0xca110000
#define SYSCALL_EXIT	0xca110001
#define SYSCALL_PRINT   0xca110002

#define SYSCALL_INVALID_CODE -1

/**
 * The offset of where `a0` is stored on the preservation stack relative to `sp`.  `a0 = x10`, so it is the 10th register,
 * subtracting the 2 that are not preserved (`zero` and `sp` itself), plus 1 for starting one full word back from `sp`.
 */
#define PRESERVED_A0_OFFSET ( -(10 - 2 + 1) * BYTES_PER_WORD )
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* GLOBALS */

word_t next_ROM_number = INIT_ROM_NUMBER;

address_t user_base    = 0;
address_t user_limit   = 0;
word_t    user_size    = 0;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Schedule (jump into) the current process.
 */
void cpu_scheduler () {

  /* Jump to the current process, giving it a new quantum. */
  // userspace_jump is in assembly code because we need to write into csr
  userspace_jump(preserved_epc, preserved_sp, user_base, user_limit);
  
} // cpu_scheduler ()
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Run the next ROM.  _Returns only if there are no more ROMs to load._
 */
void run_next () {

  print("[kernel:] RUN ROM #");
  print_dec(next_ROM_number);   // convert ROM number into a string; next_ROM_number is in the statics
  print("\n");

  /* Lookup the ROM.  If it isn't a valid ROM number, halt the system. */
  // dt_ROM_ptr points towards a device table entry
  dt_entry_s* dt_ROM_ptr = find_device(ROM_device_code, next_ROM_number); // find_device returns the address of the ROM
  if (dt_ROM_ptr == NULL) {
    return;
  }

  /* Load the executable into the process's space. */  
  DMA_portal_ptr->src    = dt_ROM_ptr->base;
  DMA_portal_ptr->dst    = user_base;
  DMA_portal_ptr->length = dt_ROM_ptr->limit - dt_ROM_ptr->base; // Trigger

  /* Prepare the initial epc and sp. */
  preserved_epc = 0;
  preserved_sp  = user_size;

  /* Store the next ROM on deck, then jump to this newly loaded one. */
  next_ROM_number += 1;
  cpu_scheduler();
  
} /* run_next () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Perform the NOOP syscall.
 */
void do_noop () {

  DEBUG("NOOP requested");

  /* Advance the process PC so that it resumes after the ecall. */
  preserved_epc += 4;

} /* do_noop () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Perform the EXIT syscall.  Terminate this one and load the next.  _Returns only if there are no more ROMs to load._
 *
 * \param status The exiting status of the process.
 */
void do_exit (word_t status) {

  print("[kernel:] EXIT process with status ");
  print_dec(status);
  print("\n");

  /* Advance to the next ROM. */
  run_next();

} /* do_exit () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Perform the PRINT syscall.  Print a given null-terminated string to the console.
 *
 * \param msg A pointer to a null-terminated string in the process's address space.
 * \return <code>0</code> if the message was successfully printed; <code>-1</code> otherwise (e.g., the string pointer was invalid.)
 */
word_t do_print (address_t msg) {

  /* Translate the string's pointer from a virtual to a physical address, verifying that it is in range. */
  msg = msg + user_base;
  if (msg >= user_limit) {
    return -1;
  }
  
  /* Make the printing happen. */
  print((char*)msg);

  /* Advance the process PC so that it resumes after the ecall. */
  preserved_epc += 4;
  
  return 0;
  
} /* do_print () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Carry out a syscall.  <b>Does not return.</b>
 *
 * \param code The requested syscall type
 * \param arg0 An additional argument; whether it is relevant depends upon which syscall is requested.
 */
void do_syscall (word_t code, word_t arg0) {

  /* Dispatch on the requested system call by code. */
  bool   has_return_value = false;
  word_t result           = 0;
  if (code == SYSCALL_NOOP) {
    
    do_noop();
    
  } else if (code == SYSCALL_EXIT) {
    
    do_exit(arg0);
    /* Special case: If this call returned, there were no more ROMs. */
    print("[kernel:] All processes terminated\n");
    halt_kernel();

  } else if (code == SYSCALL_PRINT) {
    
    has_return_value = true;
    result = do_print((address_t)arg0);

  } else {
    
    result = SYSCALL_INVALID_CODE;
    
  }

  /* If there is a return value, copy it into the current process's preserved a0 register space on its stack. */
  if (has_return_value) {
    word_t* preserved_a0 = (word_t*)(user_base + preserved_sp + PRESERVED_A0_OFFSET);
    *preserved_a0        = result;
  }

  /* Schedule a process. */
  cpu_scheduler();
  
} /* do_syscall () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Manage a clock alarm interrupt.  _Does not return._
 */
void do_alarm () {

  /* Print a little info and then resume. */
  print("[kernel:] ALARM interrupt caught\n");
  cpu_scheduler();
  
} // do_alarm ()
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Initialize the running of user processes.
 */
void run_init () {

  /* Determine the user-space bounds. */
  user_base  = kernel_limit;
  user_limit = RAM_limit;
  user_size  = user_limit - user_base;
  
  /* Start the running of processes. */
  run_next();

  /* Special case:  That call returns only there were no user ROMs to load and execute. */
  print("[kernel:] Failed to run, no user ROMs\n");
  halt_kernel();

} /* run_init () */
/* =============================================================================================================================== */
