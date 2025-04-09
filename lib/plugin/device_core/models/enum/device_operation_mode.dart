enum DeviceOperationMode {
  thermostat,
  manual;

  static DeviceOperationMode fromRawValue(int value) {
    switch (value) {
      case 0:
        return DeviceOperationMode.thermostat;
      case 1:
        return DeviceOperationMode.manual;
      default:
        throw Exception('Invalid DeviceOperationMode value: $value');
    }
  }

  int toRawValue() {
    switch (this) {
      case DeviceOperationMode.thermostat:
        return 0;
      case DeviceOperationMode.manual:
        return 1;
    }
  }
}
