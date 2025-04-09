/// Make sure the event value matches the BleStateEvent on Android/iOS native side
enum BleStateEvent {
  bluetoothState('bluetoothState');

  final String value;
  const BleStateEvent(this.value);
}
