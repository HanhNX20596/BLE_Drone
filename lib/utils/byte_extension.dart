import 'dart:convert';

import 'package:flutter/cupertino.dart';

extension ByteExt on List<int> {
  String decode() {
    try {
      const asciiDecoder = AsciiDecoder();
      return asciiDecoder.convert(this);
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return toString();
    }
  }
}
