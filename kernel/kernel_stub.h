/* =============================================================================================================================== */
#if !defined (_KERNEL_STUB_H)
#define _KERNEL_STUB_H
/* =============================================================================================================================== */



/* =============================================================================================================================== */
#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
extern uint32_t none_device_code;
extern uint32_t controller_device_code;
extern uint32_t ROM_device_code;
extern uint32_t RAM_device_code;
extern uint32_t console_device_code;
extern uint32_t block_device_code;
extern uint32_t clock_device_code;
extern uint32_t random_device_code;

extern address_t     kernel_limit;
extern address_t     RAM_limit;
extern DMA_portal_s* DMA_portal_ptr;

extern address_t statics_limit;

extern word_t preserved_epc;
extern word_t preserved_sp;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Cross into userspace by setting the virtual addressing and jumping to a given userspace location.
 *
 * \param target The program counter in the user-space program to which to jump, given as a virtual address in that process's space.
 * \param stack  The stack pointer in the user-space program from which to restore the other registers.
 * \param base   The base physical address of the virtual address space.
 * \param limit  The limit physical address of the virtual address space.
 * \return <b>Does not return</b>.
 */
void userspace_jump (address_t target, address_t stack, address_t base, address_t limit);

/**
 * Search the device table for the n-th instance of a particular device type.
 *
 * \param type The code for the device type for which to search.
 * \return The address of the device table entry of the n-th instance of the given device type; <code>NULL</code> if no such
 *         instance was found.
 */
dt_entry_s* find_device (word_t type, int instance);

/**
 * Print a message to the console.
 *
 * \param msg The null-terminated string to print.
 */
void print (char* msg);

/**
 * Halt the kernel.
 *
 * \return <b>Does not return</b>.
 */
void halt_kernel ();
/* =============================================================================================================================== */




/* =============================================================================================================================== */
#endif /* _KERNEL_STUB_H */
/* =============================================================================================================================== */
