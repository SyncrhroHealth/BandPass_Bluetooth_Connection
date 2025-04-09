import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../channel_names.dart';
import 'constant/ble_state_method.dart';

/// BleStatePlugin is a plugin to check the Bluetooth state and request permission
class BleStatePlugin {
  static const _methodChannel = MethodChannel(ChannelNames.bleStateMethodChannel);
  static const _eventChannel = EventChannel(ChannelNames.bleStateEventChannel);

  static final _listeners = StreamController<BluetoothState?>.broadcast();

  static StreamSubscription subscribeBluetoothStateEvents() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      print('subscribeBluetoothStateEvents event: $event');
      return _toBluetoothState(event);
    }).listen((event) {
      _listeners.add(event);
    });
  }

  static Stream<BluetoothState?> listenEvent() {
    return _listeners.stream;
  }

  static Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final androidSdkInt = androidInfo.version.sdkInt;
      if (androidSdkInt >= 12) {
        final resultList = await Future.wait(
          [
            Permission.bluetooth.isGranted,
            Permission.bluetoothAdvertise.isGranted,
            Permission.bluetoothConnect.isGranted,
            Permission.bluetoothScan.isGranted,
            Permission.location.isGranted,
          ],
        );
        return !resultList.contains(false);
      }
      return await Permission.location.isGranted;
    } else {
      final result = await _methodChannel.invokeMethod('hasBlePermission');
      return result as bool;
    }
  }

  static Future<bool> requestBluetoothPermission() async {
    await [
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    return true;
  }

  static Future<bool> requestLocationPermission() async {
    await [Permission.location].request();
    return true;
  }

  static Future<bool> isBleEnable() async {
    try {
      final result = await _methodChannel.invokeMethod(BleStateMethod.isBleEnabled.value);
      return Future.value(result as bool);
    } catch (error) {
      return Future.value(false);
    }
  }

  /// Android support only
  static Future<bool> enableBluetooth() async {
    if (Platform.isIOS) {
      return false;
    }

    try {
      final result = await _methodChannel.invokeMethod(BleStateMethod.enableBle.value);
      return Future.value(result as bool);
    } catch (error) {
      return Future.value(false);
    }
  }

  static BluetoothState? _toBluetoothState(dynamic map) {
    if (map is Map) {
      var event = ScannerEvent.from(map['event']);
      if (event != ScannerEvent.bluetoothState) return null;
      var body = Map<String, dynamic>.from(map['body']);
      return BluetoothState.from(body['state']);
    }
    return null;
  }
}

enum ScannerEvent {
  scanResult,
  bluetoothState;

  static ScannerEvent? from(String value) {
    switch (value) {
      case 'scanResult':
        return ScannerEvent.scanResult;
      case 'bluetoothState':
        return ScannerEvent.bluetoothState;
      default:
        return null;
    }
  }
}

enum BluetoothState {
  on,
  off;

  static BluetoothState from(String value) {
    switch (value) {
      case 'on':
        return BluetoothState.on;
      default:
        return BluetoothState.off;
    }
  }
}
