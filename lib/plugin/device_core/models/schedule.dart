// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bandpass_ble_connection/plugin/device_core/models/time_schedule.dart';

import 'model_enums.dart';

class Schedule {
  final bool enableSchedule;
  final TimeSchedule turnOn;
  final TimeSchedule turnOff;

  Schedule({
    required this.enableSchedule,
    required this.turnOn,
    required this.turnOff,
  });

  Schedule copyWith({
    bool? enableSchedule,
    TimeSchedule? turnOn,
    TimeSchedule? turnOff,
  }) {
    return Schedule(
      enableSchedule: enableSchedule ?? this.enableSchedule,
      turnOn: turnOn ?? this.turnOn,
      turnOff: turnOff ?? this.turnOff,
    );
  }

  static Schedule fromMap(dynamic map) {
    return Schedule(
      enableSchedule: map['enableSchedule'] == 1,
      turnOn: TimeSchedule(
        hour: map['turnOnHour'],
        minute: map['turnOnMinute'],
        timePeriod: TimePeriod.fromNativeValue(map['turnOnAmOrPm']),
      ),
      turnOff: TimeSchedule(
        hour: map['turnOffHour'],
        minute: map['turnOffMinute'],
        timePeriod: TimePeriod.fromNativeValue(map['turnOffAmOrPm']),
      ),
    );
  }

  @override
  String toString() =>
      'Schedule(enableSchedule: $enableSchedule, turnOn: $turnOn, turnOff: $turnOff)';
}
