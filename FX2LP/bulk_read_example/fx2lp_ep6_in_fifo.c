// from https://gist.github.com/siddharthdeore/b1aac400ec94ca53730291a92279ea0e
/* @author siddharth deore (siddharthdeore@gmail.com)
    @brief A host program to read bulk data from End Point 6 of FX2LP
        Reads 512 bytes from the device.
        Before running this program, the fw_ep6_fifo.ihx firmware file needs to be loaded
        onto the FX2LP device using the cycfx2prog tool.
        To load the firmware onto the device, run the following command:
            cycfx2prog prg:fw_ep6_fifo.ihx run
        To build the program, use the following command:
            g++ fx2lp_ep6_in_fifo.cpp  -o fx2lp_ep6_in_fifo -lusb-1.0
        To run the program, use the following command:
            ./ep6_in_fx2lp
*/

#include <stdio.h> 
#include <stdlib.h> 
#include <libusb-1.0/libusb.h>

int main()
{int i,j;
    libusb_context *ctx = NULL;   // initialize libusb
    if (libusb_init(&ctx) != 0)
    {printf("Failed: libusb_init\n");
     return EXIT_FAILURE;
    }

    const int vid = 0x04b4;
    const int pid = 0x8613; // 0x1004;

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

    if (libusb_set_interface_alt_setting(hndl, 0, 1) < 0)
    { printf("Failed: libusb_set_interface_alt_setting\n");
     libusb_release_interface(hndl, 0);
      libusb_close(hndl);
      libusb_exit(ctx);
      return EXIT_FAILURE;
    }

    const int timeout_ms = 1000;
    const int pkt_size = 512;

    int transferred;
    int res;
    unsigned char buf[pkt_size];
    while (1) {
     res=libusb_bulk_transfer(hndl, LIBUSB_ENDPOINT_IN | 6, buf, pkt_size, &transferred, timeout_ms);
        if (res==0)
        {
            for (i=0; i<pkt_size; i+= 2)
            {
               for (j=0;j<8;j++)
                  printf("%d",((buf[i]>>(7-j))&1));
               printf(" ");
               for (j=0;j<8;j++)
                  printf("%d",((buf[i+1]>>(7-j))&1));
               printf("\n");
//                std::cout << std::bitset<16>((buf[i] << 8) | buf[i + 1]) << "\n";
            }
        }
        else
        {
            printf("Failed: libusb_bulk_transfer");
            printf(" %x: %d\n",LIBUSB_ENDPOINT_IN | 6, res);
            // std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
    }
    libusb_release_interface(hndl, 0);
    libusb_close(hndl);
    libusb_exit(ctx);
}
