/* All examples have been derived from miniterm.c                          */
#include "rs232.h"

struct termios oldtio,newtio;

int init_rs232()
{int fd;
 fd=open(RS232DEVICE, O_RDWR | O_NOCTTY ); 
 if (fd <0) {perror(RS232DEVICE); exit(-1); }
 tcgetattr(fd,&oldtio); /* save current serial port settings */
 bzero(&newtio, sizeof(newtio)); /* clear struct for new port settings */
 newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;  /* _no_ CRTSCTS */
 newtio.c_iflag = IGNPAR; // | ICRNL |IXON; 
 newtio.c_oflag = IGNPAR; //ONOCR|ONLRET|OLCUC;
 newtio.c_cc[VTIME]    = 0;     /* inter-character timer unused */
 newtio.c_cc[VMIN]     = 1;     /* blocking read until 1 character arrives */
 tcflush(fd, TCIFLUSH);tcsetattr(fd,TCSANOW,&newtio);
 return(fd);
}

void free_rs232(int fd)
{tcsetattr(fd,TCSANOW,&oldtio);
 close(fd);} /* restore the old port settings */
