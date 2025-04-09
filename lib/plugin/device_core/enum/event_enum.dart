/// Make sure the event value matches the DeviceCoreEvent on Android/iOS native side
enum EventEnum {
  // Connection
  onDeviceFound,
  onDeviceConnected,
  onDeviceDisconnected,

  // Data Response
  onDeviceNameRsp,
  onDeviceInfoRsp,
  onBasicInfoRsp,
  onHotBoxDataRsp,
  onTimeStampRsp,
  onScheduleRsp;

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
      case 'onDeviceNameRsp':
        return EventEnum.onDeviceNameRsp;
      case 'onDeviceInfoRsp':
        return EventEnum.onDeviceInfoRsp;
      case 'onBasicInfoRsp':
        return EventEnum.onBasicInfoRsp;
      case 'onHotBoxDataRsp':
        return EventEnum.onHotBoxDataRsp;
      case 'onTimeStampRsp':
        return EventEnum.onTimeStampRsp;
      case 'onScheduleRsp':
        return EventEnum.onScheduleRsp;
      default:
        return null;
    }
  }
}
