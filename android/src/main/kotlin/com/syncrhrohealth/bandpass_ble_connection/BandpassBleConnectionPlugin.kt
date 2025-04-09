package com.syncrhrohealth.bandpass_ble_connection

import com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.event.DeviceCoreEventPlugin
import com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.method.DeviceCoreMethodPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BandpassBleConnectionPlugin
 *
 *  Primary entry point for our Flutter plugin. This plugin
 *  internally registers two sub-plugins:
 *   - DeviceCoreMethodPlugin (MethodChannel)
 *   - DeviceCoreEventPlugin  (EventChannel)
 * */
class BandpassBleConnectionPlugin : FlutterPlugin {

    private var deviceCoreMethodPlugin: DeviceCoreMethodPlugin? = null
    private var deviceCoreEventPlugin: DeviceCoreEventPlugin? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Create + attach the sub-plugins
        deviceCoreMethodPlugin = DeviceCoreMethodPlugin().also {
            it.onAttachedToEngine(binding)
        }

        deviceCoreEventPlugin = DeviceCoreEventPlugin().also {
            it.onAttachedToEngine(binding)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Detach each sub-plugin
        deviceCoreMethodPlugin?.onDetachedFromEngine(binding)
        deviceCoreEventPlugin?.onDetachedFromEngine(binding)
    }
}
