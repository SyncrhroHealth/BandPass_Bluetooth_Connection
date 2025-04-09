// ignore_for_file: public_member_api_docs, sort_constructors_first
class DeviceInfo {
  final String? deviceName;
  final String? deviceAddress;
  final String? hwVersion;
  final String? fwVersion;

  DeviceInfo({
    this.deviceName,
    this.deviceAddress,
    this.hwVersion,
    this.fwVersion,
  });

  static DeviceInfo fromMap(dynamic map) {
    return DeviceInfo(
      deviceName: map['deviceName'],
      deviceAddress: map['macAddress'],
      hwVersion: map['hwVersion'],
      fwVersion: map['fwVersion'],
    );
  }

  @override
  String toString() {
    return 'DeviceInfo(deviceName: $deviceName, deviceAddress: $deviceAddress, hwVersion: $hwVersion, fwVersion: $fwVersion)';
  }
}
