import 'dart:async';

import 'package:flutter/services.dart';

class JumioFlutter {
  static const MethodChannel _channel =
      const MethodChannel('com.fondeadora.mobile/jumio_flutter');

  static Future<bool> init(
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
    return await _channel.invokeMethod('init', args);
  }

  static Future<Map> scanDocument() async {
    var result = await _channel.invokeMethod('scanDocument');
    print(result);
    return result;
  }
}
