/// Make sure the event value matches the DeviceCoreEvent on Android/iOS native side
enum EventEnum {
  // Connection
  onDeviceFound,
  onDeviceConnected,
  onDeviceDisconnected,

  // Data Response
  onDeviceInfoRsp,
  onReceiveImuData;

  static EventEnum? from(String value) {
    switch (value) {
      // Connection
      case 'onDeviceFound':
        return EventEnum.onDeviceFound;
      case 'onDeviceConnected':
        return EventEnum.onDeviceConnected;
      case 'onDeviceDisconnected':
        return EventEnum.onDeviceDisconnected;

      // Data Response
      case 'onDeviceInfoRsp':
        return EventEnum.onDeviceInfoRsp;
      case 'onReceiveImuData':
        return EventEnum.onReceiveImuData;
      default:
        return null;
    }
  }
}
