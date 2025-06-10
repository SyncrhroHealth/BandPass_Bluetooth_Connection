// ignore_for_file: public_member_api_docs, sort_constructors_first
class BatteryInfo {
  final String address;
  final int level;

  BatteryInfo({
    required this.address,
    required this.level,
  });

  static BatteryInfo fromMap(dynamic map) {
    return BatteryInfo(
      address: map['address'],
      level: map['level'],
    );
  }
}
