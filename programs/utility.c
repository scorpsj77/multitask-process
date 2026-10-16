/* =============================================================================================================================== */
/* INCLUDES */

#include <stdbool.h>
#include "syscall.h"
#include "utility.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* CONSTANTS */

#define BYTES_PER_WORD  4
#define BITS_PER_BYTE   8
#define BITS_PER_NYBBLE 4
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



/* =============================================================================================================================== */
int string_length (char* str) {

  if (str == NULL) return 0;

  int length = 0;
  while (*str != '\0') {
    ++length;
    ++str;
  }

  return length;
  
} /* string_length () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
int string_compare (char* str_A, char* str_B) {

  if (str_A == NULL && str_B == NULL) return 0;
  if (str_A == NULL) return 1;
  if (str_B == NULL) return -1;

  while (true) {

    if (*str_A == *str_B) {
      if (*str_A == '\0') {
	return 0;
      }
      str_A++;
      str_B++;
    } else if (*str_A < *str_B) {
      return -1;
    } else {
      return 1;
    }
    
  }
  
} /* string_compare () */
/* =============================================================================================================================== */
