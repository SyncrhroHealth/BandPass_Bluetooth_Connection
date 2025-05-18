package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo

/** Data format
 *
 *  char    fw_ver[3]          ([0]: MAJOR; [1]: MINOR; [2]: PATCH; Example: 1.0.1)
 *  char    hw_ver[3]          ([0]: MAJOR; [1]: MINOR; [2]: PATCH; Example: 1.0.1)
 *  char    mac_addr[6]
 *  char    device_name[20]
 *
 * */

object ImuDataRspHandler {
    fun handle(data: ByteArray, handler: DeviceHandler) {
        Log.e(ImuDataRspHandler.javaClass.simpleName, "handle: len: ${data.size}, :${data.toList()}")
        try {

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}