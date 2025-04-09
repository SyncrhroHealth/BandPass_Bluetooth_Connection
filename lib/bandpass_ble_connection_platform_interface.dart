import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bandpass_ble_connection_method_channel.dart';

abstract class BandpassBleConnectionPlatform extends PlatformInterface {
  /// Constructs a BandpassBleConnectionPlatform.
  BandpassBleConnectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static BandpassBleConnectionPlatform _instance = MethodChannelBandpassBleConnection();

  /// The default instance of [BandpassBleConnectionPlatform] to use.
  ///
  /// Defaults to [MethodChannelBandpassBleConnection].
  static BandpassBleConnectionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BandpassBleConnectionPlatform] when
  /// they register themselves.
  static set instance(BandpassBleConnectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
