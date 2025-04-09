
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
}
