// ignore_for_file: public_member_api_docs, sort_constructors_first

class HotBoxData {
  final int fuelLevel;
  final int fanSpeed;
  final int pumpRate;
  final int glowPlugPower;
  final int seaLevel;

  final double batteryVoltage;
  final double heaterTemp;
  final double fuelCapacity;
  final double fuelPump;
  final double tempOffset;

  HotBoxData({
    required this.fuelLevel,
    required this.fanSpeed,
    required this.pumpRate,
    required this.glowPlugPower,
    required this.seaLevel,
    required this.batteryVoltage,
    required this.heaterTemp,
    required this.fuelCapacity,
    required this.fuelPump,
    required this.tempOffset,
  });

  static HotBoxData fromMap(dynamic map) {
    return HotBoxData(
      fuelLevel: map['fuelLevel'],
      fanSpeed: map['fanSpeed'],
      pumpRate: map['pumpRate'],
      glowPlugPower: map['glowPlugPower'],
      seaLevel: map['seaLevel'],
      batteryVoltage: (map['batteryVoltage'] as double),
      heaterTemp: (map['heaterTemp'] as double),
      fuelCapacity: map['fuelCapacity'],
      fuelPump: map['fuelPump'],
      tempOffset: map['tempOffset'],
    );
  }

  @override
  String toString() {
    return 'HotBoxData(fuelLevel: $fuelLevel, fanSpeed: $fanSpeed, pumpRate: $pumpRate, glowPlugPower: $glowPlugPower, seaLevel: $seaLevel, batteryVoltage: $batteryVoltage, heaterTemp: $heaterTemp, fuelCapacity: $fuelCapacity, fuelPump: $fuelPump, tempOffset: $tempOffset)';
  }
}
