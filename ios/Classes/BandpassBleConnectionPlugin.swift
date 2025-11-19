import Flutter
import UIKit

@objc(BandpassBleConnectionPlugin)
public class BandpassBleConnectionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()

    // Register all plugin channels
    DeviceCoreMethodPlugin.register(with: messenger)  // MethodChannel for device commands
    DeviceCoreEventPlugin.register(with: messenger)   // EventChannel for device events
    BleStatePlugin.register(with: messenger)          // Event+Method channels for BLE state
  }
}
