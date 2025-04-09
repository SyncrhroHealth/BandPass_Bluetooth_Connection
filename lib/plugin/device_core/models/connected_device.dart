// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConnectedDevice {
  final String? name;
  final String address;
  final String? hwVersion;
  final String? fwVersion;
  final String? batteryLevel;
  final bool isCharging;

  ConnectedDevice({
    this.name,
    required this.address,
    this.hwVersion,
    this.fwVersion,
    this.batteryLevel,
    this.isCharging = false,
  });

  static ConnectedDevice fromMap(dynamic map) {
    return ConnectedDevice(
      name: map['name'],
      address: map['address'],
      hwVersion: map['hwVersion'],
      fwVersion: map['fwVersion'],
      batteryLevel: map['batteryLevel'],
      isCharging: map['isCharging'] ?? false,
    );
  }
}
