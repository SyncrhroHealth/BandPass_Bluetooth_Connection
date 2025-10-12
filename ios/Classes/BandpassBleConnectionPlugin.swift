import Flutter
import UIKit

@objc(BandpassBleConnectionPlugin)
public class BandpassBleConnectionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()

    DeviceCoreMethodPlugin.register(with: messenger)  // MethodChannel  :contentReference[oaicite:2]{index=2}
    BleStatePlugin.register(with: messenger)          // Event+Method channels  :contentReference[oaicite:3]{index=3}
  }
}
