#include <fx2regs.h>
#include <delay.h>
void main(void)
{OED = (1<<7); // PD7 as output
 while (1)
 {PD7 = 0;     // IOD = 0;
  delay(1000); // Wait a second
  PD7 = 1;     // IOD = (1<<7);
  delay(1000); // Wait a second
 }
}
