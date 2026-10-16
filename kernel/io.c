/* =============================================================================================================================== */
/* INCLUDES */

#include "io.h"
#include "kernel_stub.h"
#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void int_to_hex (word_t value, char* buffer) {

  static char hex_digits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

  /* Traverse the value from most to least significant bits. */
  for (int shift = BYTES_PER_WORD * BITS_PER_BYTE - BITS_PER_NYBBLE; shift >= 0; shift -= BITS_PER_NYBBLE) {

    /* Grab the next nybble and add its corresponding digit to the string, advancing the string's pointer. */
    word_t nybble = (value >> shift) & 0xf;
    *buffer++ = hex_digits[nybble];
    
  }

  /* Finish the string with a null termination. */
  *buffer = '\0';
  
} /* int_to_hex () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void int_to_dec (word_t value, char* buffer) {

  /* A space to place the digits as they are produced in reverse order. */
  char temp[12];

  /* Special case: 0. */
  if (value == 0) {
    buffer[0] = '0';
    buffer[1] = '\0';
    return;
  }
  
  /* Append digits until no more remain. */
  int i = 0;
  while (value != 0) {

    int digit = value % 10;
    value /= 10;
    temp[i++] = '0' + digit;
    
  }

  /* Reverse the digits as they are placed into the given buffer. */
  i -= 1;
  while (i >= 0) {
    *buffer++ = temp[i--];
  }
  
  /* Finish the string with null termination. */
  *buffer = '\0';

} /* int_to_dec () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void print_dec (word_t value) {

  char buffer[16];
  int_to_dec(value, buffer);
  print(buffer);

} /* print_dec () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void print_hex (word_t value) {

  char buffer[16];
  int_to_hex(value, buffer);
  print(buffer);

} /* print_hex () */
/* =============================================================================================================================== */
