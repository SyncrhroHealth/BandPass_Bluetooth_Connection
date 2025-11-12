import Flutter
import UIKit

@objc(BandpassBleConnectionPlugin)
public class BandpassBleConnectionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()

    DeviceCoreMethodPlugin.register(with: messenger)  // MethodChannel
    DeviceCoreEventPlugin.register(with: messenger)   // EventChannel
    BleStatePlugin.register(with: messenger)          // Event+Method channels
  }
}
