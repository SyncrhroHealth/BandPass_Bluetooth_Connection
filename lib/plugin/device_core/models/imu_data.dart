// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bandpass_ble_connection/plugin/device_core/models/vec_3_batch.dart';

class ImuData {
  final int count;
  final Vec3Batch accel;
  final Vec3Batch gyro;
  final int adcRaw;
  final int timestampMs;

  ImuData({
    required this.count,
    required this.accel,
    required this.gyro,
    required this.adcRaw,
    required this.timestampMs,
  });

  static ImuData fromMap(dynamic map) {
    return ImuData(
      count: map['count'],
      accel: map['accel'],
      gyro: map['gyro'],
      adcRaw: map['adcRaw'],
      timestampMs: map['timestampMs'],
    );
  }

  @override
  String toString() {
    return 'ImuData(count: $count, accel: $accel, gyro: $gyro, adcRaw: $adcRaw, timestampMs: $timestampMs)';
  }
}
