#include "syscall.h"
#include "utility.h"

int main () {

  /* Loop for a large number of iterations, printing occassionally. */
  for (int i = 0; i < 0x7fffffff; i += 1) {

    if (i % 0x10000 == 0) {
      print("[longloop:] i = ");
      print_dec(i);
      print("\n");
    }

  }

  return 0;
  
}
