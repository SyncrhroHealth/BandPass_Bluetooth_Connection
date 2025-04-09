

enum TempeControlModeState {
  idle,
  running;

  String get name {
    switch (this) {
      case TempeControlModeState.idle:
        return 'Idel';
      case TempeControlModeState.running:
        return 'Running';
    }
  }

  static TempeControlModeState fromRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return TempeControlModeState.idle;
      case 1:
        return TempeControlModeState.running;
      default:
        throw Exception('Invalid TempeControlModeState value: $rawValue');
    }
  }

  int toRawValue() {
    switch (this) {
      case TempeControlModeState.idle:
        return 0;
      case TempeControlModeState.running:
        return 1;
    }
  }
}
