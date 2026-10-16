#include "syscall.h"
#include "utility.h"

int fib (int n) {

  if (n < 2) {
    return n;
  } else {
    return fib(n-1) + fib(n-2);
  }
  
}

int main () {

  int n = 20;
  int v = fib(n);
  print("fib(");
  print_dec(n);
  print(") = ");
  print_dec(v);
  print("\n");

}
