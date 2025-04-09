package com.syncrhrohealth.bandpass_ble_connection.ble

import android.annotation.SuppressLint
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.os.ParcelUuid
import android.util.Log

@SuppressLint("MissingPermission")
/**
 * Responsible for scanning device
 */
class BleScanner(
    private val scanner: BluetoothLeScanner,
    private val onDevicesFound: (FoundDevice) -> Unit
) {
    companion object {
        val TAG: String = BleScanner::class.java.simpleName
    }

    private val mScanCallback = object : ScanCallback() {
        override fun onScanResult(callBackType: Int, result: ScanResult) {
            super.onScanResult(callBackType, result)
            if (result.device.name == null) return

            if (result.device.name.startsWith(BleConstant.DEVICE_PREFIX)) {
                onDevicesFound(
                    FoundDevice(
                        btDevice = result.device,
                        rssi = result.rssi,
                    )
                )
            }

        }

        override fun onScanFailed(errorCode: Int) {
        }

        override fun onBatchScanResults(results: List<ScanResult>) {
        }
    }

    fun startScan() {
        stopScan()

        val settings = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .build()

        val serviceUuidFilter = ScanFilter.Builder().setServiceUuid(
            ParcelUuid.fromString(BleConstant.SERVICE_UUID.uppercase())
        ).build()

        val filters: List<ScanFilter> = arrayListOf()

        Log.d(TAG, "startScan...")
        scanner.startScan(filters, settings, mScanCallback)
    }

    fun stopScan() {
        scanner.stopScan(mScanCallback)
    }
}