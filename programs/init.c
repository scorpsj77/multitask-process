#include <stdbool.h>

#include "syscall.h"
#include "utility.h"

#define FIRST_ROM_NUMBER 4

int main () {

  /* Run ROMs until there are no more. */
  int  rom_number = FIRST_ROM_NUMBER;
  bool done       = false;
  while (!done) {

    print("[init:  ] Running ROM #");
    print_dec(rom_number);
    print("\n");
    int result = run(rom_number);
    if (result > 0) {

      print("[init:  ] New pid = ");
      print_dec(result);
      print("\n");

    } else if (result > 100) /* Sanity check */ {

      done = true;
      print("[init:  ] Unexpectedly large pid = ");
      print_dec(result);
      print("\n");

    } else {

      switch (result) {

      case -1:
	done = true;
	print("[init:  ] No such ROM; done.\n");
	break;

      case -2:
      case -3:
	print("[init:  ] Memory allocation failure.\n");
	break;

      default:
	done = true;
	print("[init:  ] Unexpected result = ");
	print_dec(result);
	print("\n");
      
      }

    }

    rom_number += 1;

  }

  return 0;

}
