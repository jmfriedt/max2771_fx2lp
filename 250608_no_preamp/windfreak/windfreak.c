#include "rs232.h"
#include <ncurses.h>

void send_freq(float freq,int fd)
{unsigned char chaine[256];
 sprintf(chaine,"f%f\n",freq);
  write(fd,chaine,strlen(chaine));
 sprintf(chaine,"a3\n",freq);
  write(fd,chaine,strlen(chaine));
 sprintf(chaine,"h1\n",freq);
  write(fd,chaine,strlen(chaine));
 sprintf(chaine,"o1\n",freq);
  write(fd,chaine,strlen(chaine));
}

int main(int argc,char **argv)
{int fd,k;
 char c;
 float freq=1075.42;
 unsigned char chaine[256];
// WINDOW *w;
// w = initscr();
 fd=init_rs232(); 
 if (fd<0) {printf("oups\n");return -1;}
 if (argc>1) freq=atof(argv[1]);
 send_freq(freq,fd);
 printf("%f MHz programmed\r\n",freq);
 return(0);
}

