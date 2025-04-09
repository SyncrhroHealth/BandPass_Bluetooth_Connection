// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'enum/device_operation_mode.dart';
import 'enum/temp_control_mode_state.dart';

class BasicInfo {
  final bool isTempSensorAttached;
  final DeviceOperationMode deviceOperationMode;
  final TempeControlModeState modeThermostatState;
  final TempeControlModeState modeManualState;
  final int fuelLevel;
  final int currentLevel;
  final int expectedLevel;
  final double currentTemp;
  final double expectedTemp;

  BasicInfo({
    required this.isTempSensorAttached,
    required this.deviceOperationMode,
    required this.modeThermostatState,
    required this.modeManualState,
    required this.fuelLevel,
    required this.currentLevel,
    required this.expectedLevel,
    required this.currentTemp,
    required this.expectedTemp,
  });

  static BasicInfo fromMap(dynamic map) {
    return BasicInfo(
      isTempSensorAttached: (map['isTempSensorAttached'] as int) == 1,
      deviceOperationMode: DeviceOperationMode.fromRawValue((map['deviceOperationMode'] as int)),
      modeThermostatState: TempeControlModeState.fromRawValue((map['modeThermostatState'] as int)),
      modeManualState: TempeControlModeState.fromRawValue((map['modeManualState'] as int)),
      fuelLevel: map['fuelLevel'],
      currentLevel: map['currentLevel'],
      expectedLevel: map['expectedLevel'],
      currentTemp: map['currentTemp'],
      expectedTemp: map['expectedTemp'],
    );
  }

  @override
  String toString() {
    return 'BasicInfo(isTempSensorAttached: $isTempSensorAttached, deviceOperationMode: $deviceOperationMode, modeThermostatState: $modeThermostatState, modeManualState: $modeManualState, fuelLevel: $fuelLevel, currentLevel: $currentLevel, expectedLevel: $expectedLevel, currentTemp: $currentTemp, expectedTemp: $expectedTemp)';
  }
}
