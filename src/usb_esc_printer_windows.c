#include "usb_esc_printer_windows.h"
 
FFI_PLUGIN_EXPORT int print_data(unsigned char *data, int length, LPTSTR ztPrinterName) {
    DOC_INFO_1 docInfo;
    DWORD bytesWritten;
    HANDLE hPrinter;
    // LPTSTR ztPrisnterName = TEXT("EPSON");
    #define BUFFER_SIZE 3125  // Adjust the buffer size as needed
    unsigned char buffer[BUFFER_SIZE];
    int bytes_to_write, bytes_remaining = length;

    // Open a handle to the default printer
    if (!OpenPrinter(ztPrinterName, &hPrinter, NULL)) {
        fprintf(stderr, "Failed to open the default printer\n");
        return -1;
    }     

    // Fill in the details of the print job
    docInfo.pDocName = L"POS MOSYS";
    docInfo.pOutputFile = NULL;
    docInfo.pDatatype = L"RAW"; // Send raw data to the printer

    // Start a new document
    if (StartDocPrinter(hPrinter, 1, (LPBYTE)&docInfo) == 0) {
        fprintf(stderr, "Failed to start document\n");
        ClosePrinter(hPrinter);
        return -1;
    }

    // Start a new page
    if (!StartPagePrinter(hPrinter)) {
        fprintf(stderr, "Failed to start page\n");
        EndDocPrinter(hPrinter);
        ClosePrinter(hPrinter);
        return -1;
    }

     // Send the data in chunks to the printer
    while (bytes_remaining > 0) {
        bytes_to_write = (bytes_remaining > BUFFER_SIZE) ? BUFFER_SIZE : bytes_remaining;
        memcpy(buffer, data + length - bytes_remaining, bytes_to_write);

        if (!WritePrinter(hPrinter, buffer, bytes_to_write, &bytesWritten)) {
            fprintf(stderr, "Failed to write to printer\n");
            EndPagePrinter(hPrinter);
            EndDocPrinter(hPrinter);
            ClosePrinter(hPrinter);
            return -1;
        }

        bytes_remaining -= bytesWritten;
    }

    // End the page and document
    EndPagePrinter(hPrinter);
    EndDocPrinter(hPrinter);

    // Close the printer handle
    ClosePrinter(hPrinter);

    return 0;
}
 
