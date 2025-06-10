// ignore_for_file: public_member_api_docs, sort_constructors_first

class ImuData {
  final String address;
  final int count;
  final double accelX;
  final double accelY;
  final double accelZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final int adcRaw;
  final String date;
  final String timeMs;

  ImuData({
    required this.address,
    required this.count,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.adcRaw,
    required this.date,
    required this.timeMs,
  });

  factory ImuData.fromMap(dynamic raw) {
    final map = Map<String, dynamic>.from(raw as Map);
    return ImuData(
      address: map['address'] as String,
      count: map['count'] as int,
      accelX: (map['accelX'] as num).toDouble(),
      accelY: (map['accelY'] as num).toDouble(),
      accelZ: (map['accelZ'] as num).toDouble(),
      gyroX: (map['gyroX'] as num).toDouble(),
      gyroY: (map['gyroY'] as num).toDouble(),
      gyroZ: (map['gyroZ'] as num).toDouble(),
      adcRaw: map['adcRaw'] as int,
      date: map['date'] as String,
      timeMs: map['timeMs'] as String,
    );
  }

  @override
  String toString() {
    return 'ImuData(address: $address, count: $count, accelX: $accelX, accelY: $accelY, accelZ: $accelZ, gyroX: $gyroX, gyroY: $gyroY, gyroZ: $gyroZ, adcRaw: $adcRaw, date: $date, timeMs: $timeMs)';
  }
}
