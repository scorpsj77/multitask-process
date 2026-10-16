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
  if (size <= 0) return NULL;

  // rounds up size upward to a multiple of the required alignment
  word_t block_size = ALIGN_UP((word_t) size);

  // initialize the block that we are traversing from
  header_s* current_head = free_head.next;

  while (current_head != &free_tail) {
    // found a free block that is big enough for the requested size
    if (current_head->size >= block_size) {
      // remove this block from free list
      current_head->prev->next = current_head->next;
      current_head->next->prev = current_head->prev;

      // point to the usable memory after its header
      ptr = HEADER_TO_BLOCK(current_head);

      current_head->next = NULL;
      current_head->prev = NULL;
      break;
    }
    current_head = current_head->next;
  }

  // no blocks in free list or none of the blocks fit
  if (ptr == NULL) {
    header_s* header = (header_s*) heap_limit;
    header->size = block_size;
    // they point to null since the block is immediately occupied and hence not part of free list
    header->next = NULL;
    header->prev = NULL;
    ptr = HEADER_TO_BLOCK(header);
    heap_limit += sizeof(header_s) + block_size;
  }

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
  // find the header immediately before the ptr
  header = BLOCK_TO_HEADER(ptr);

  // connect this header to the head of the free list
  header->prev = &free_head;
  header->next = free_head.next;

  // update the original first block to point back to it
  free_head.next->prev = header;
  free_head.next = header;

  print_dec(header->size);
  print("]\n");
  
} /* deallocate () */
/* =============================================================================================================================== */
