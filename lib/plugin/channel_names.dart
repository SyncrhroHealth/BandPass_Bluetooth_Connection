/// Make sure this class matches the ChannelNames on the Android/iOS native plugin side
class ChannelNames {
  // PREFIX
  static const channelPrefix = 'com.flutter.plugin';

  static const method = 'method';
  static const event = 'event';

  static const deviceCoreMethodChannel = '$channelPrefix/$method/device';
  static const deviceCoreEventChannel = '$channelPrefix/$event/device';

  static const bleStateMethodChannel = '$channelPrefix/$method/bluetooth_state';
  static const bleStateEventChannel = '$channelPrefix/$event/bluetooth_state';

}
