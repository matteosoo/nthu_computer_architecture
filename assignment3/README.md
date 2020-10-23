# assignment3
## Q1：Write a MIPS assembly program for the following C program. 
```C
#include "math.h"

#include "stdio.h"

int add(int x, int y);
int msub(int x, int y);
int main() {
  int a = 0;
  int b = 0;
  int c = 0;
  int d = 0;
  printf("input a:");
  scanf("%d", & a);
  printf("input b:");
  scanf("%d", & b);
  printf("input c:");
  scanf("%d", & c);
  d = msub(add(a, b), c);
  printf("result = %d", d);
  return 0;
}
int add(int x, int y) {
  return x + y;
}
int msub(int x, int y) {
  int large = (x >= y) ? x : y;
  int small = (x <= y) ? x : y;
  while (large >= small) {
    large = large - small;
  }
  return large;
}
```
* P.S. 
  * a, b, c, d are stored in $s0, $s1, $s2, $s3 respectively.
  * And you must use the procedure (function) call to implement add and msub.
  * Also, your program should terminal normally (the output should show “-- program is
  finished running --“).
  
* Output format example
```
input a: 4
input b: 2
input c: 1
result = 0
-- program is finished running --
```

## Q2：Write a MIPS assembly program for the following C program.
```C
#include "stdio.h"

int
function (int x, int y);
int recursive(int x);
int main() {
  int a = 0;
  int b = 0;
  int c = 0;
  int d = 0;
  printf("input a: ");
  scanf("%d", & a);
  printf("input b: ");
  scanf("%d", & b);
  c = recursive(a);
  printf("ans: %d", c);
  d = function (b, c);
  printf("ans: %d", d);
  return 0;
}
int
function (int x, int y) {
  if (x <= 0)
    return 1;
  else if (y <= 0)
    return 1;
  else
    return function (x - 1, y) + function (x, y - 1);
}
int recursive(int x) {
    return (x >= 0xFF) ? (recursive(x - 3) + recursive(x - 2)) :
      ((x >= 0xF) ? recursive(x - 1) + 1 : 1);
```
* P.S. 
  * a, b, c, d are stored in $s0, $s1, $s2, $s3 respectively.
  *And you must use the procedure (function) call to implement function and
  recursive.
  * Also, your program should terminal normally (the output should show “-- program is
  finished running --“).
  
  * Output format example
```
input a: 1
input b: 2
ans: lans: 3
-- program is finished running --
```
