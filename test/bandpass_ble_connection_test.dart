import 'package:flutter_test/flutter_test.dart';
import 'package:bandpass_ble_connection/bandpass_ble_connection.dart';
import 'package:bandpass_ble_connection/bandpass_ble_connection_platform_interface.dart';
import 'package:bandpass_ble_connection/bandpass_ble_connection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBandpassBleConnectionPlatform
    with MockPlatformInterfaceMixin
    implements BandpassBleConnectionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BandpassBleConnectionPlatform initialPlatform = BandpassBleConnectionPlatform.instance;

  test('$MethodChannelBandpassBleConnection is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBandpassBleConnection>());
  });

  test('getPlatformVersion', () async {
    BandpassBleConnection bandpassBleConnectionPlugin = BandpassBleConnection();
    MockBandpassBleConnectionPlatform fakePlatform = MockBandpassBleConnectionPlatform();
    BandpassBleConnectionPlatform.instance = fakePlatform;

    expect(await bandpassBleConnectionPlugin.getPlatformVersion(), '42');
  });
}
