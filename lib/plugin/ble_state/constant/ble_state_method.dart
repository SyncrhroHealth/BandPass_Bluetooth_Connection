/// Make sure the method value matches the BleStateMethod on Android/iOS native side
enum BleStateMethod {
  isBleEnabled('isBleEnabled'),
  enableBle('enableBle');

  final String value;
  const BleStateMethod(this.value);
}
