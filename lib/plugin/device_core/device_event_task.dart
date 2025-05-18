import 'package:bandpass_ble_connection/plugin/device_core/models/disconnected_device.dart';
import 'package:bandpass_ble_connection/plugin/device_core/models/imu_data.dart';

import 'enum/event_enum.dart';
import 'models/connected_device.dart';
import 'models/found_device.dart';

class DeviceEventTask {
  final EventEnum? event;
  final dynamic data;

  DeviceEventTask({
    this.event,
    required this.data,
  });

  @override
  String toString() => 'DeviceEventTask(event: $event, data: $data)';

  FoundDevice toScannedDevice() {
    return FoundDevice.fromMap(data);
  }

  ConnectedDevice toConnectedDevice() {
    return ConnectedDevice.fromMap(data);
  }

  DisconnectedDevice toDisconnectedDevice() {
    return DisconnectedDevice.fromMap(data);
  }

  ImuData toImuData() {
    return ImuData.fromMap(data);
  }
}
