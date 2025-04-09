import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../plugin/device_core/device_core_plugin.dart';
import 'enum/scan_state_enum.dart';

class PermissionUtils {
  static Future<ScanStateEnum> checkScanPermission() async {
    final isBluetoothPermissionGranted = await checkBluetoothPermission();
    if (isBluetoothPermissionGranted == PermissionStatus.granted) {
      final isLocationPermissionGranted = await checkLocationPermission();
      if (isLocationPermissionGranted == PermissionStatus.granted) {
        return ScanStateEnum.granted;
      } else {
        switch (isLocationPermissionGranted) {
          case PermissionStatus.permanentlyDenied:
            return ScanStateEnum.locationPermanentlyDenied;
          default:
            return ScanStateEnum.locationDenied;
        }
      }
    } else {
      switch (isBluetoothPermissionGranted) {
        case PermissionStatus.permanentlyDenied:
          return ScanStateEnum.bluetoothPermanentlyDenied;
        default:
          return ScanStateEnum.bluetoothDenied;
      }
    }
  }

  static Future<PermissionStatus> checkBluetoothPermission() async {
    if (await DeviceCorePlugin.hasPermission()) {
      return PermissionStatus.granted;
    } else {
      final requests = await Future.wait([
        Permission.bluetooth.status,
        Permission.bluetoothAdvertise.status,
        Permission.bluetoothConnect.status,
        Permission.bluetoothScan.status,
      ]);
      for (final status in requests) {
        if (status != PermissionStatus.granted) {
          return PermissionStatus.denied;
        }
      }
      return PermissionStatus.granted;
    }
  }

  static Future<PermissionStatus> checkLocationPermission() async {
    //IOS no need location permission for scanning BLE
    if (Platform.isIOS) {
      return PermissionStatus.granted;
    }
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    final sdkVersion = androidInfo.version.sdkInt;

    //Above android 11 ==> no need to request Location Permission for scanning BLE
    if (sdkVersion > 30) {
      return PermissionStatus.granted;
    }

    var status = await Permission.location.status;
    return status;
  }

  static Future<void> requestBluetoothPermission() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
  }

  static Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }
}
