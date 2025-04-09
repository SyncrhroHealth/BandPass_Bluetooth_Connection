/// Make sure the method value matches the DeviceCoreMethod on Android/iOS native side
enum MethodEnum {
  // Permission
  isBleEnabled('isBleEnabled'),
  hasBlePermission('hasBlePermission'),

  // Scanning
  startScan('startScan'),
  stopScan('stopScan'),

  // Connection
  connect('connect'),
  disconnect('disconnect'),
  reconnect('reconnect'),
  reconnectDevices('reconnectDevices'),

  // Device commands
  getDeviceName('getDeviceName'),
  setDeviceName('setDeviceName'),
  getDeviceInfo('getDeviceInfo'),
  setThermostatControlMode('setThermostatControlMode'),
  setManualControlMode('setManualControlMode'),
  getBasicInfo('getBasicInfo'),
  getHotBoxData('getHotBoxData'),
  setTimeStamp('setTimeStamp'),
  getTimeStamp('getTimeStamp'),
  getSchedule('getSchedule'),
  setSchedule('setSchedule'),
  resetFuelLevel('resetFuelLevel'),
  setFuelCapacity('setFuelCapacity'),
  setFuelPump('setFuelPump'),
  setSeaLevel('setSeaLevel'),
  setTempOffset('setTempOffset'),
  ;

  final String value;
  const MethodEnum(this.value);
}
