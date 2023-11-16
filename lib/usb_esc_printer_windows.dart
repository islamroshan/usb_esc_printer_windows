import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'usb_esc_printer_windows_bindings_generated.dart';

const String _libName = 'usb_esc_printer_windows';

/// The dynamic library in which the symbols for [UsbEscPrinterWindowsBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final UsbEscPrinterWindowsBindings _bindings =
    UsbEscPrinterWindowsBindings(_dylib);

Pointer<Uint8> convertListIntToPointerUnsignedChar(List<int> list) {
  if (list.any((int value) => value < 0 || value > 255)) {
    throw ArgumentError('List contains values out of the Uint8 range');
  }

  // Allocate a buffer for the Uint8 values.
  final Pointer<Uint8> result = calloc<Uint8>(list.length);
  // Get a Dart typed list backed by the same buffer.
  final Uint8List nativeList = result.asTypedList(list.length);
  for (int i = 0; i < list.length; i++) {
    nativeList[i] = list[i];
  }
  return result; // Return the pointer.
}

Pointer<Char> stringToPointerChar(String str) {
  final units = utf8.encode(str);
  final Pointer<Char> result =
      calloc<Char>(units.length + 1); // +1 for null terminator
  final Uint8List nativeString =
      result.cast<Uint8>().asTypedList(units.length + 1);
  nativeString.setRange(0, units.length, units);
  nativeString[units.length] = 0; // Null-terminate the string
  return result;
}

void print_receipt(List<int> data) {
  final name = "EPSON".toNativeUtf16();

  // final myPointer = stringToPointerChar("EPSON");
  final Pointer<Uint8> dataPtr = convertListIntToPointerUnsignedChar(data);
  _bindings.print_data(dataPtr, data.length, name);

  calloc.free(dataPtr);
  calloc.free(name);
}
