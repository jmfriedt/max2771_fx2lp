#include <fx2regs.h>
#include <delay.h>
#define led12 3  // 1<<0 | 1<<1
void main(void)
{unsigned char val=1;
 OEA=(led12);    // PA0, PA1 output
 while (1)
 {val=led12-val; // 2 <-> 1
  IOA = val;
  delay(1000);   // wait 1 s
 }
}
