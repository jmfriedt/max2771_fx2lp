// https://gist.github.com/siddharthdeore/b1aac400ec94ca53730291a92279ea0e
/**
    @file fx2lp_ep6_in.cpp
    @author siddharth deore (siddharthdeore@gmail.com)
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

#include <iostream>
#include <bitset>              // cout bits
#include <csignal>             // capture Ctrl+C
#include <thread>              // sleep
#include <libusb-1.0/libusb.h> // USB

// signal handler function
volatile std::sig_atomic_t g_signalStatus;
void signalHandler(int signal)
{
    g_signalStatus = signal;
}

int main()
{
    // setup signal handling
    std::signal(SIGINT, signalHandler);
    g_signalStatus = 0;

    // initialize libusb
    libusb_context *ctx = nullptr;
    if (libusb_init(&ctx) != 0)
    {
        std::cerr << "Failed: libusb_init\n";
        return EXIT_FAILURE;
    }

    const int vid = 0x04b4;
//    const int pid = 0x1004;
    const int pid = 0x8613;

    // open USB device
    libusb_device_handle *hndl = libusb_open_device_with_vid_pid(ctx, vid, pid);
    if (hndl == nullptr)
    {
        std::cerr << "Failed: libusb_open_device_with_vid_pid\n";
        libusb_exit(ctx);
        return EXIT_FAILURE;
    }

    // claim interface
    if (libusb_claim_interface(hndl, 0) < 0)
    {
        std::cerr << "Failed: libusb_claim_interface\n";
        libusb_close(hndl);
        libusb_exit(ctx);
        return EXIT_FAILURE;
    }

    // set alternate setting
    if (libusb_set_interface_alt_setting(hndl, 0, 1) < 0)
    {
        std::cerr << "Failed: libusb_set_interface_alt_setting\n";
        libusb_release_interface(hndl, 0);
        libusb_close(hndl);
        libusb_exit(ctx);
        return EXIT_FAILURE;
    }

    // read from USB device
    const int timeout_ms = 1000;
    const int pkt_size = 512;

    int transferred;
    int res;
    unsigned char buf[pkt_size];
    while (g_signalStatus == 0)
    {
     res=libusb_bulk_transfer(hndl, LIBUSB_ENDPOINT_IN | 6, buf, pkt_size, &transferred, timeout_ms);
        if (res==0)
        {
            for (int i = 0; i < pkt_size; i += 2)
            {
                std::cout << std::bitset<16>((buf[i] << 8) | buf[i + 1]) << "\n";
            }
        }
        else
        {
            std::cerr << "Failed: libusb_bulk_transfer";
            printf(" %x: %d\n",LIBUSB_ENDPOINT_IN | 6, res);
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
    }

    // release interface and close device
    libusb_release_interface(hndl, 0);
    libusb_close(hndl);
    libusb_exit(ctx);

    // handle signal
    if (g_signalStatus == SIGINT)
    {
        std::cout << std::endl
                  << "Ctrl+C captured, Exiting" << std::endl;
        return EXIT_SUCCESS;
    }
    else
    {
        return EXIT_FAILURE;
    }
}
