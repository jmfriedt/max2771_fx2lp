// from https://gist.github.com/siddharthdeore/b1aac400ec94ca53730291a92279ea0e
// @author siddharth deore (siddharthdeore@gmail.com)
//  @brief A host program to read bulk data from End Point 6 of FX2LP

#include <stdio.h> 
#include <stdlib.h> 
#include <libusb-1.0/libusb.h>

#define N 512
#define tout_ms 1000
#define vid 0x04b4
//#define pid 0x8613 // 0x1004;
#define pid 0x1004

int main()
{int i,j;
 int transferred;
 int res;
 unsigned char buf[N];
 libusb_context *ctx = NULL;   // initialize libusb
 if (libusb_init(&ctx) != 0)
    {printf("Failed: libusb_init\n");
     return EXIT_FAILURE;
    }

 libusb_device_handle *hndl = libusb_open_device_with_vid_pid(ctx, vid, pid);
 if (hndl == NULL)
    { printf("Failed: libusb_open_device_with_vid_pid\n");
      libusb_exit(ctx);
      return EXIT_FAILURE;
    }

 if (libusb_claim_interface(hndl, 0) < 0)
    { printf("Failed: libusb_claim_interface\n");
      libusb_close(hndl);
      libusb_exit(ctx);
      return EXIT_FAILURE;
    }

/*
if (libusb_set_interface_alt_setting(hndl, 0, 1) < 0)
    { printf("Failed: libusb_set_interface_alt_setting\n");
     libusb_release_interface(hndl, 0);
      libusb_close(hndl);
      libusb_exit(ctx);
      return EXIT_FAILURE;
    }
*/

 while (1) {
   res=libusb_bulk_transfer(hndl, LIBUSB_ENDPOINT_IN | 6, buf, N, &transferred, tout_ms);
   if (res==0)    // -7 is timeout
     {for (i=0; i<N; i+= 2)
        {for (j=0;j<8;j++)
           printf("%d",((buf[i]>>(7-j))&1));
           printf(" ");
           for (j=0;j<8;j++)
             printf("%d",((buf[i+1]>>(7-j))&1));
           printf("\n");
        }
     }
   else
     {printf("Failed: libusb_bulk_transfer");
      printf(" %x: %d\n",LIBUSB_ENDPOINT_IN | 6, res);
     }
 }
 libusb_release_interface(hndl, 0);
 libusb_close(hndl);
 libusb_exit(ctx);
}
