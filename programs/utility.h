/* =============================================================================================================================== */
/**
 * A collection of useful functions.
 *
 * \file utility.h
 */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* AVOID MULTIPLE INCLUSION */

#if !defined (_UTILITY_H)
#define _UTILITY_H
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include "types.h"
#include "utility.h"
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

/**
 * Calculate the length of a null-terminated string.
 *
 * \param str A pointer to the string.
 * \return the length of the given string.
 */
int string_length (char* str);

/**
 * Determine whether two null-terminated strings are identical.  If they are unequal, return which comes first lexicographically.
 *
 * \param str_A A pointer to the first string.
 * \param str_B A pinter to the second string.
 * \return 0 if the strings are equal, -1 if str_A is lexicographically first, and 1 if str_B is first.
 */
int string_compare (char* str_A, char* str_B);
/* =============================================================================================================================== */



/* =============================================================================================================================== */
#endif /* _UTILITY_H */
/* =============================================================================================================================== */
