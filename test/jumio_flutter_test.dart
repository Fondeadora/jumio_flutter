import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jumio_flutter/jumio_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('jumio_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await JumioFlutter.platformVersion, '42');
  });
}
