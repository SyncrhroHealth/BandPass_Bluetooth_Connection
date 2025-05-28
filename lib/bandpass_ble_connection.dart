import 'package:bandpass_ble_connection/plugin/device_core/models/battery_info.dart';
import 'package:bandpass_ble_connection/plugin/device_core/models/connected_device.dart';
import 'package:bandpass_ble_connection/plugin/device_core/models/disconnected_device.dart';
import 'package:bandpass_ble_connection/plugin/device_core/models/imu_data.dart';

import 'application/permission_utils.dart';
import 'bandpass_ble_connection_platform_interface.dart';
import 'plugin/device_core/device_core_plugin.dart';
import 'plugin/device_core/device_event_task.dart';
import 'plugin/device_core/enum/event_enum.dart';
import 'plugin/device_core/models/found_device.dart';

class BandpassBleConnection {
  Future<String?> getPlatformVersion() {
    return BandpassBleConnectionPlatform.instance.getPlatformVersion();
  }

  static Future<void> checkPermission() async {
    await PermissionUtils.requestBluetoothPermission();
    await PermissionUtils.requestLocationPermission();
  }

  static Future<bool> isBleEnabled() async {
    return DeviceCorePlugin.isBleEnabled();
  }

  static startScan() async {
    await DeviceCorePlugin.startScan();
  }

  static stopScan() async {
    await DeviceCorePlugin.stopScan();
  }

  static connect(String address) async {
    await DeviceCorePlugin.connect(address);
  }

  static disconnect(String address) async {
    await DeviceCorePlugin.disconnect(address);
  }

  static subscribePluginEvents() {
    DeviceCorePlugin.subscribeEvents();
  }

  static Stream<DeviceEventTask> getDeviceEventStream() {
    return DeviceCorePlugin.listenEvent();
  }

  static void listenFoundDevice(Function(FoundDevice) onDeviceFound) {
    DeviceCorePlugin.listenEvent().listen(
      (event) {
        switch (event.event) {
          case EventEnum.onDeviceFound:
            onDeviceFound(event.toScannedDevice());
            break;
          default:
            break;
        }
      },
    );
  }

  static void listenConnectedDevice(Function(ConnectedDevice) onDeviceConnected) {
    DeviceCorePlugin.listenEvent().listen(
      (event) {
        switch (event.event) {
          case EventEnum.onDeviceConnected:
            onDeviceConnected(event.toConnectedDevice());
            break;
          default:
            break;
        }
      },
    );
  }

  static void listenDisconnectedDevice(Function(DisconnectedDevice) onDeviceDisonnected) {
    DeviceCorePlugin.listenEvent().listen(
      (event) {
        switch (event.event) {
          case EventEnum.onDeviceDisconnected:
            onDeviceDisonnected(event.toDisconnectedDevice());
            break;
          default:
            break;
        }
      },
    );
  }

  static void listenImuData(Function(ImuData) onReceiveImuData) {
    DeviceCorePlugin.listenEvent().listen(
      (event) {
        switch (event.event) {
          case EventEnum.onImuDataRsp:
            onReceiveImuData(event.toImuData());
            break;
          default:
            break;
        }
      },
    );
  }

  static void listenBatteryInfo(Function(BatteryInfo) onReceiveBatteryInfo) {
    DeviceCorePlugin.listenEvent().listen(
      (event) {
        switch (event.event) {
          case EventEnum.onBatteryLevelRsp:
            onReceiveBatteryInfo(event.toBatteryInfo());
            break;
          default:
            break;
        }
      },
    );
  }
}
