#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>                  /* declaration of bzero() */
#include <fcntl.h>
#include <termios.h>
int init_rs232();
void free_rs232();
void sendcmd(int,char*);

#define BAUDRATE B230400
#define RS232DEVICE "/dev/ttyACM0"

