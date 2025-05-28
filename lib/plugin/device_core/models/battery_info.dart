class BatteryInfo {
  final int level;

  BatteryInfo({
    required this.level,
  });

  static BatteryInfo fromMap(dynamic map) {
    return BatteryInfo(
      level: map['level'],
    );
  }
}
