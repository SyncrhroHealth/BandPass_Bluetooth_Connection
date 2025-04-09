
import 'enum/event_enum.dart';
import 'models/basic_info.dart';
import 'models/battery_info.dart';
import 'models/connected_device.dart';
import 'models/device_info.dart';
import 'models/found_device.dart';
import 'models/hot_box_data.dart';
import 'models/schedule.dart';

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

  DeviceInfo toDeviceInfo() {
    return DeviceInfo.fromMap(data);
  }

  BatteryInfo toBatteryInfo() {
    return BatteryInfo.fromMap(data);
  }

  BasicInfo toBasicInfo() {
    return BasicInfo.fromMap(data);
  }

  HotBoxData toHotBoxData() {
    return HotBoxData.fromMap(data);
  }

  Schedule toSchedule() {
    return Schedule.fromMap(data);
  }
}
