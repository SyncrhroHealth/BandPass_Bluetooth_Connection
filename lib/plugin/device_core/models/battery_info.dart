class BatteryInfo {
  final bool isCharging;
  final int level;
  final double voltage;

  BatteryInfo({
    required this.isCharging,
    required this.level,
    required this.voltage,
  });

  static BatteryInfo fromMap(dynamic map) {
    return BatteryInfo(
      isCharging: map['isCharging'],
      level: map['level'],
      voltage: map['voltage'],
    );
  }
}
