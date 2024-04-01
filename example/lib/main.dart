import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart' as usb_esc_printer_windows;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _printerName = "EPSON";
  late Future<CapabilityProfile> _profile;

  @override
  initState() {
    _profile = CapabilityProfile.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fluter ESC/POS Printer Pakage For Windows Platform Only'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: printReq,
                  child: const Text("Demo Print"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  printReq() async {
    List<int> bytes = [];
    final profile = await _profile;
    final generator = Generator(PaperSize.mm80, profile);

    // LOGO
    final Uint8List data = await loadImageFromAssets('assets/images/logo.png');

    img.Image originalImage = img.decodeImage(data)!;

    bytes += generator.imageRaster(originalImage, align: PosAlign.center);
    bytes += generator.feed(1);

    //GENERATE BARCODE
    String invoiceNo = "322123000000";
    List<int> barData = invoiceNo.split('').map((String digit) => int.parse(digit)).toList();

    bytes += generator.barcode(
      Barcode.itf(barData),
      height: 100,
      textPos: BarcodeText.none,
    );

    bytes += generator.feed(1);

    bytes += generator.text(
      'INV #322123000000',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.text('Reprinted at : 06-11-2023 07:32:52 AM');

    bytes += generator.feed(1);

    bytes += generator.text(
      'PAID(IN)',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(1);

    bytes += generator.text('Walk in');

    bytes += generator.text('Tel : 0000000000');

    bytes += generator.text('Date\\Time : Sun, 10 Sep 2023 06:24 PM');

    bytes += generator.text('Associate : 5552');

    bytes += generator.text('Promised On : Sun, 10 Sep 2023 06:24 PM');

    bytes += generator.feed(1);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: 'QTY',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      ),
      PosColumn(
        text: 'S/T/DESCRIPTION',
        width: 8,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      ),
      PosColumn(
        text: 'TOTAL',
        width: 3,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      ),
    ]);

    bytes += [27, 97, 1];
    bytes += generator.text('-----------------------------------------');

    bytes += [27, 97, 0];
    bytes += generator.text(
      ' 1x  Pants (IN)                  \$ 133.40',
      styles: const PosStyles(
        align: PosAlign.left,
        reverse: true,
        bold: true,
      ),
    );

    bytes += generator.feed(1);

    bytes += [27, 97, 1];

    //GENERATE BARCODE
    bytes += generator.barcode(
      Barcode.itf(
        "32212300000000".split('').map((String digit) => int.parse(digit)).toList(),
      ),
      height: 50,
      textPos: BarcodeText.none,
    );

    bytes += generator.text("32212300000000");

    bytes += generator.feed(1);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '1x',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '(\$13.40 Growth Hem)',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '(Tag : (1x) Lengthen : Lengthen \$ 0.00',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '| (1x) Lengthen : Polo Hem \$ 0.00) |',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: 'Dept Hem',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      ),
    ]);

    bytes += generator.feed(1);

    bytes += [27, 97, 0];
    bytes += generator.text(
      ' 1x  Pants (IN)                  \$ 133.40',
      styles: const PosStyles(
        align: PosAlign.left,
        reverse: true,
        bold: true,
      ),
    );

    bytes += generator.feed(1);

    bytes += [27, 97, 1];

    //GENERATE BARCODE
    bytes += generator.barcode(
      Barcode.itf(
        "32212300000000".split('').map((String digit) => int.parse(digit)).toList(),
      ),
      height: 50,
      textPos: BarcodeText.none,
    );

    bytes += generator.text("32212300000000");

    bytes += generator.feed(1);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '1x',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '(\$13.40 Growth Hem)',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '(Tag : (1x) Lengthen : Lengthen \$ 0.00',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '| (1x) Lengthen : Polo Hem \$ 0.00) |',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += [27, 97, 0];
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: 'Dept Hem',
        width: 11,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      ),
    ]);

    bytes += generator.feed(1);

    bytes += [27, 97, 1];
    bytes += generator.text('-----------------------------------------');

    bytes += [27, 97, 0];
    bytes += generator.text(
      'HST # : R877439000',
      styles: const PosStyles(
        height: PosTextSize.size1,
      ),
    );

    bytes += [27, 97, 2];
    bytes += generator.text('Sub Total  \$ 13.40');

    bytes += [27, 97, 0];
    bytes += generator.text('Total Disc \$ 0.00');

    bytes += [27, 97, 2];
    bytes += generator.text('HST (13%)  \$ 1.74');

    bytes += generator.feed(1);

    bytes += [27, 97, 2];
    bytes += generator.text(
      'Total  \$ 15.14',
      styles: const PosStyles(
        height: PosTextSize.size2,
        bold: true,
      ),
    );

    bytes += generator.text(
      'Balance Owing  \$ 0.00',
      styles: const PosStyles(
        height: PosTextSize.size2,
        bold: true,
      ),
    );

    bytes += generator.feed(1);

    bytes += [27, 97, 1];
    bytes += generator.text('Transaction details');
    bytes += generator.text('*****************************************');

    bytes += [27, 97, 0];
    bytes += generator.text('Tender Type :  Cash(INV)');
    bytes += generator.text('Amount :  \$ 0.00');

    bytes += [27, 97, 2];
    bytes += generator.text('Total Tendered  \$ 13.40');
    bytes += generator.text('Total Charge  \$ 0.00');
    bytes += generator.text('Total Round Off  \$ 0.01');

    bytes += [27, 97, 0];
    bytes += generator.text('Items :  1');

    bytes += [27, 97, 1];
    bytes += generator.text(
      'Production : Sun, 10 Sep 2023 09:00 AM',
      styles: const PosStyles(
        height: PosTextSize.size2,
        bold: true,
      ),
    );

    bytes += generator.feed(1);

    bytes += [27, 97, 2];
    bytes += generator.text('Points Earned Before This Visit : \$ 739.85');
    bytes += generator.text('Total Points Earned :  \$ 0.57');

    // 0 = left, center = 1 right = 2
    bytes += [27, 97, 1];
    bytes += generator.text('*** Store Copy ***');

    bytes += generator.feed(1);
    bytes += generator.cut();

    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, _printerName);
    String msg = "";

    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }

    print(msg);
  }
}
