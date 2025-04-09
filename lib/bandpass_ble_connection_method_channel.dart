import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bandpass_ble_connection_platform_interface.dart';

/// An implementation of [BandpassBleConnectionPlatform] that uses method channels.
class MethodChannelBandpassBleConnection extends BandpassBleConnectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bandpass_ble_connection');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
