/* =============================================================================================================================== */
/**
 * Manage main memory for user processes as a collection of fixed-size blocks.
 *
 * \file mm_alloc.c
 */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include <stdint.h>

#include "kernel_stub.h"
#include "mm_alloc.h"
#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* TYPES & STRUCTS */

/* For free blocks. */
typedef struct header {

  struct header* next;
  
} header_s;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* STATICS */

/* The head of the free list. */
header_s* free_list_head = NULL;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Initialize main memory as a single free block.  If it is already initialized, do nothing.
 */
void mm_init () {

  /* Continue only if userspace memory is uninitialized. */
  if (free_list_head != NULL) return;

  /* Create as many blocks as possible, from the end of the kernel's space to the end of RAM, and add them to the free list. */
  for (address_t current = kernel_limit; current < RAM_limit; current += MM_BLOCK_SIZE) {

    header_s* header = (header_s*)current;
    header->next   = free_list_head;
    free_list_head = header;

  }
    
} /* mm_init () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
address_t mm_allocate () {

  /* Ensure that user memory is initialized. */
  mm_init();

  /* Special case: No blocks are available. */
  if (free_list_head == NULL) {
    return 0;
  }

  /* Remove a block from the front of the list and return it. */
  header_s* header = free_list_head;
  free_list_head   = header->next;
  header->next     = NULL;
  
  return (address_t)header;
  
} /* mm_allocate () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void mm_deallocate (address_t block) {

  /* Do nothing if there is no block. */
  if (block == 0) return;

  /* Insert the block at the front of the free list. */
  header_s* header = (header_s*)block;
  header->next     = free_list_head;
  free_list_head   = header;
  
} /* mm_deallocate () */
/* =============================================================================================================================== */
