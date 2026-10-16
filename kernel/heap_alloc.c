/* =============================================================================================================================== */
/**
 * Manage a standard heap.
 *
 * \file heap_alloc.c
 */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include <stdint.h>

#include "heap_alloc.h"
#include "io.h"
#include "kernel_stub.h"
#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* MACROS */

#define ADDR_SIZE (sizeof(address_t))
#define ALIGN_UP(addr) (addr % ADDR_SIZE == 0 ? addr : (addr + ADDR_SIZE) & ~(ADDR_SIZE - 1))

#define HEADER_TO_BLOCK(p) ((void*)((address_t)p + sizeof(header_s)))
#define BLOCK_TO_HEADER(p) ((header_s*)((address_t)p - sizeof(header_s)))
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* TYPES & STRUCTS */

typedef struct header {

  word_t         size;
  struct header* next;
  struct header* prev;
  
} header_s;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* STATICS */

/* A pair of sentinels to the free list, making the coding easier. */
header_s free_head = { .next = NULL, .prev = NULL, .size = 0 };
header_s free_tail = { .next = NULL, .prev = NULL, .size = 0 };

/* The current limit of the heap. */
address_t heap_limit = (address_t)NULL;

/* The externally provided end of the statics, at which the heap will begin. */
extern address_t statics_limit;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/**
 * Initialize the heap.  If it is already initialized, do nothing.
 */
void heap_init () {

  /* Continue only if the heap is uninitialized. */
  if (heap_limit != (address_t)NULL) return;

  /* Start the heap where the statics end. */
  heap_limit = (address_t)&statics_limit;

  /* Initialize the sentinels that bookend the free block list. */
  free_head.next = &free_tail;
  free_tail.prev = &free_head;
  
} /* heap_init () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void* allocate (int size) {

  print("[debug: ] allocate(");
  print_dec(size);
  print(") -> 0x");
  
  /* Ensure that the heap is initialized. */
  heap_init();

  /* Find/create a block, and return the pointer to it. */
  void* ptr = NULL;
  
  /* TO BE COMPLETED */
  // 

  /* Assuming that `ptr` has been set to point to a newly allocated block, show its address and then return it. */
  print_hex((word_t)ptr);
  print("\n");
  return ptr;
  
} /* allocate () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void deallocate (void* ptr) {

  /* Do nothing if there is no block. */
  if (ptr == NULL) return;

  print("[debug: ] deallocate(0x");
  print_hex((word_t)ptr);
  print(") [size = ");

  header_s* header;
  
  /* TO BE COMPLETED */

  print_dec(header->size);
  print("]\n");
  
} /* deallocate () */
/* =============================================================================================================================== */
