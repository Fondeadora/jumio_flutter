import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:jumio_flutter/jumio_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jumio flutter example app'),
        ),
        body: Center(
          child: MaterialButton(
            child: Text("Scan"),
            onPressed: () async => await _scanDocument(),
          ),
        ),
      ),
    );
  }

  Future<void> _scanDocument() async {
    try {
      var result = await JumioFlutter.scanDocument(
        "b559ed03-499d-4571-92ed-8c493c5c2e0d",
        "mlcp5SzKrEu0eUQW8ABHY1AzM6YsgjeV",
        "scanReference",
        "userReference",
      );

      print("scan result: $result");

    } on PlatformException {
      print("Error");
    }
  }
}
