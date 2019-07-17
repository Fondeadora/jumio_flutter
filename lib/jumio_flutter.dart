import 'dart:async';

import 'package:flutter/services.dart';

class JumioFlutter {
  static const MethodChannel _channel =
      const MethodChannel('com.fondeadora.mobile/jumio_flutter');

  static Future<Map> scanDocument(
    String apiKey,
    String apiSecret,
    String scanReference,
    String userReference,
  ) async {
    var args = {
      "apiKey": apiKey,
      "apiSecret": apiSecret,
      "scanReference": scanReference,
      "userReference": userReference,
    };
    var result = await _channel.invokeMethod('scanDocument', args);
    print(result);
    return result;
  }
}
