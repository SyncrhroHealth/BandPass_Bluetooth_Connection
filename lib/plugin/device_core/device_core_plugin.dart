import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../application/util/logger.dart';
import '../channel_names.dart';
import 'device_event_task.dart';
import 'enum/event_enum.dart';
import 'enum/method_enum.dart';
import 'handler/device_event_handler.dart';

class DeviceCorePlugin {
  static const _methodChannel = MethodChannel(ChannelNames.deviceCoreMethodChannel);

  static const _eventChannel = EventChannel(ChannelNames.deviceCoreEventChannel);

  static Stream<DeviceEventTask> listenEvent() {
    return DeviceEventHandler.listeners.stream;
  }

  static StreamSubscription subscribeEvents() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      try {
        return DeviceEventTask(
          event: EventEnum.from(event['event'] ?? ''),
          data: event['body'],
        );
      } catch (error) {
        return null;
      }
    }).listen((event) {
      DeviceEventHandler.handle(data: event);
    });
  }

  // *** Device Core Methods ***
  // BLE connection

  static Future<bool> isBleEnabled() async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.isBleEnabled.value);
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      if (sdkVersion >= 12) {
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
      final result = await _methodChannel.invokeMethod(MethodEnum.hasBlePermission.value);
      return result as bool;
    }
  }

  static Future<bool> startScan() async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.startScan.value);
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> stopScan() async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.stopScan.value);
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> connect(String address) async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.connect.value, [address]);
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> disconnect(String address) async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.disconnect.value, [address]);
      return Future.value(result);
    } catch (error) {
      Log.e(error);
      return Future.value(false);
    }
  }

  static Future<bool> reConnect(String address) async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.reconnect.value, [address]);
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> reConnectDevices() async {
    try {
      final result = await _methodChannel.invokeMethod(MethodEnum.reconnectDevices.value);
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }


  static Future<bool> getDeviceInfo({
    required String address,
  }) async {
    try {
      final result = await _methodChannel.invokeMethod(
        MethodEnum.getDeviceInfo.value,
        [address],
      );
      return Future.value(result);
    } catch (error) {
      return Future.value(false);
    }
  }

}
