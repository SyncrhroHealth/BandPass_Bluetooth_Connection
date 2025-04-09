import 'package:bandpass_ble_connection/bandpass_ble_connection.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  BandpassBleConnection.subscribePluginEvents();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _blePluginTestPlugin = BandpassBleConnection();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    initPlatformState();
    listenEvent();
    await Future.delayed(const Duration(seconds: 2));
    BandpassBleConnection.checkPermission();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _blePluginTestPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void listenEvent() {
    BandpassBleConnection.listenFoundDevice(
      (p0) {
        print(' Found devoce : ${p0}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
          floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () {
                BandpassBleConnection.stopScan();
              },
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.star),
              onPressed: () {
                BandpassBleConnection.startScan();
              },
              heroTag: null,
            )
          ])),
    );
  }
}
