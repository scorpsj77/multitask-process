/* =============================================================================================================================== */
/**
 * A collection of useful functions.
 *
 * \file io.h
 */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* AVOID MULTIPLE INCLUSION */

#if !defined (_IO_H)
#define _IO_H
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* MACROS */

#if defined (_DEBUG_ACTIVE)
#define DEBUG(msg)				\
  {						\
    print("[debug: ] ");			\
    print(msg);					\
    print("\n");				\
  }
#else /* !_DEBUG_ACTIVE */
#define DEBUG(msg)
#endif /* [!] _DEBUG_ACTIVE */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* FUNCTION PROTOTYPES */

/**
 * Convert an integer value into a null-terminated text string in base 16.  The string is always a full eight digits, including
 * leading zeros, so the buffer space provided must be at least 9 characters in length.
 *
 * \param value  The integer to convert.
 * \param buffer The space in which to construct the string.
 */
void int_to_hex (word_t value, char* buffer);

/**
 * Convert an integer value into a null-terminated text string in base 10.  The integer is always interpreted as unsigned.  Leading
 * zeros are not generated.  The buffer space should be at least 11 characters in length.
 *
 * \param value  The integer to convert.
 * \param buffer The space in which to construct the string.
 */
void int_to_dec (word_t value, char* buffer);

/**
 * Print an integer value in base 10.  The integer is always interpreted as unsigned.  Leading zeros are not generated.
 *
 * \param value The value to print.
 */
void print_hex (word_t value);

/**
 * Print an integer value in base 16.  The integer is always interpreted as unsigned.  Leading zeros are generated.
 *
 * \param value The value to print.
 */
void print_dec (word_t value);
/* =============================================================================================================================== */



/* =============================================================================================================================== */
#endif /* _IO_H */
/* =============================================================================================================================== */
