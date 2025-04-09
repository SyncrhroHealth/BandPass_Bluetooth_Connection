package com.syncrhrohealth.bandpass_ble_connection.core

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.ble.BleScanner
import com.syncrhrohealth.bandpass_ble_connection.ble.BleStateController
import com.syncrhrohealth.bandpass_ble_connection.ble.FoundDevice
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandlerCallBack
import com.syncrhrohealth.bandpass_ble_connection.core.model.BasicInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.HotBoxData
import com.syncrhrohealth.bandpass_ble_connection.core.model.Schedule
import com.syncrhrohealth.bandpass_ble_connection.core.model.TimeStamp
import com.syncrhrohealth.bandpass_ble_connection.util.SingletonHolder
import java.util.Timer
import kotlin.concurrent.timerTask

class CoreHandler private constructor(private val context: Context) : DeviceHandlerCallBack,
    BleStateController.BluetoothStateListener {
    private val tag = CoreHandler::class.java.simpleName

    companion object : SingletonHolder<CoreHandler, Context>(::CoreHandler)

    // Device properties
    private var scannedDeviceList: MutableList<FoundDevice> = mutableListOf()
    private var connectedDevices: MutableList<DeviceHandler> = mutableListOf()
    private var coreHandlerCallBack: CoreHandlerCallBack? = null

    // Bluetooth properties
    private var isBleAvailable = true
    private var bleStateController = BleStateController.getInstance(context)
    private val bluetoothAdapter: BluetoothAdapter by lazy {
        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        return@lazy bluetoothManager.adapter
    }
    private var bleScanner: BleScanner? = null

    init {
        bleStateController.setListener(this)
    }

    fun setListener(callBack: CoreHandlerCallBack) {
        this.coreHandlerCallBack = callBack
    }

    /**********************************************************************************************
     *  DEVICE CONNECTION
     *********************************************************************************************/

    fun startScan() {
        scannedDeviceList.clear()
        bleScanner = createBleScanner()
        bleScanner?.startScan()
    }

    private fun createBleScanner(): BleScanner {
        return BleScanner(bluetoothAdapter.bluetoothLeScanner) {
            if (isDeviceExistedInScanList(it)) return@BleScanner
            scannedDeviceList.add(it)
            coreHandlerCallBack?.onFoundDevice(it)
        }
    }

    fun stopScan() {
        bleScanner?.stopScan()
        bleScanner = null
    }

    fun requestToConnect(address: String) {
        Log.d(tag, "Connect to: $address")

        if (!isBleAvailable) {
            Log.e(tag, "Ignore when bluetooth is off!!!")
            return
        }

        // Find BluetoothDevice in scanned list
        val scannedDevice = scannedDeviceList.firstOrNull { it.btDevice.address == address }
        if (scannedDevice == null) return

        // find DeviceHandler in list connected
        var deviceHandler = connectedDevices.firstOrNull { it.getDevice().getAddress() == address }
        Log.e(tag, "Existed deviceHandler : $deviceHandler")

        // device exist -> calling connect
        if (deviceHandler != null) {
            deviceHandler.requestToConnect()
            return
        }

        // device not exist -> create new DeviceHandler
        deviceHandler = DeviceHandler(context, scannedDevice.btDevice, this)
        deviceHandler.requestToConnect()
        connectedDevices.add(deviceHandler)
    }

    fun reconnect(address: String, autoConnect: Boolean = false) {
        Log.e(tag, "reconnect: $address")
        if (!isBleAvailable) {
            Log.e(tag, "Ignore when bluetooth is off!!!")
            return
        }

        val bluetoothDevice = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(address)

        // device not exist -> create new DeviceHandler
        val deviceHandler = DeviceHandler(context, bluetoothDevice, this)
        deviceHandler.requestToConnect(autoConnect)

        val index = connectedDevices.indexOfFirst { it.getDevice().getAddress() == address }

        if (index == -1) {
            connectedDevices.add(deviceHandler)
        } else {
            connectedDevices[index] = deviceHandler
        }
    }

    fun requestToDisconnect(address: String) {
        Log.e(tag, "requestToDisconnect: $address")
        // Find DeviceHandler in list connected
        val device = connectedDevices.firstOrNull { it.getDevice().getAddress() == address }
        if (device == null) return

        connectedDevices.remove(device)
        device.requestToDisconnect()
    }

    fun getDevice(address: String): DeviceHandler? {
        val device = connectedDevices.firstOrNull { it.isEqual(address) }
        return device
    }

    fun enableBle() {
        bleStateController.enableBtAdapter(context)
    }

    private fun isDeviceExistedInScanList(device: FoundDevice): Boolean {
        if (scannedDeviceList.isEmpty()) return false
        val filterDevice =
            scannedDeviceList.firstOrNull { it.btDevice.address == device.btDevice.address }
        return filterDevice != null
    }

    /**********************************************************************************************
     * DEVICE CONNECTION CHANGED LISTENER
     *********************************************************************************************/

    private fun getInitFirstConnected(device: DeviceHandler) {
        Log.e(tag, "getInitFirstConnected:")
//        GetDeviceInfoHandler.send(device)
//        GetCurrentTempCmd.get(device)
    }


    override fun onConnected(handler: DeviceHandler) {
        if (!connectedDevices.contains(handler)) {
            connectedDevices.add(handler)
        }

        scannedDeviceList.clear()
        coreHandlerCallBack?.onConnected(handler)

        //GET DEVICE INFO
        Timer().schedule(timerTask {
            getInitFirstConnected(handler)
        }, 2000)
    }


    /**
     * May trigger when:
     * - request to disconnect
     * - bluetooth off
     * - far distance
     */
    override fun onDisConnected(handler: DeviceHandler) {
        Log.e(tag, "onDisConnected: ")
        coreHandlerCallBack?.onDisConnected(handler)

        // peripheral not exist in connectedDeviceList
        // -> that's mean that peripheral has been request to disconnect by user
        // -> There'll no need to try to reconnect
        if (!connectedDevices.contains(handler)) {
            return
        }

        // trying to reconnect
        Log.e(tag, "start reconnecting: handler: ${handler.getDevice().model}")
//        handler.reconnect()
    }

    override fun onDeviceNameRsp(deviceName: String, handler: DeviceHandler) {
        coreHandlerCallBack?.onDeviceNameRsp(deviceName, handler)
    }

    override fun onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler) {
        coreHandlerCallBack?.onDeviceInfoRsp(deviceInfo, handler)
    }

    override fun onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler) {
        coreHandlerCallBack?.onBasicInfoRsp(basicInfo, handler)
    }

    override fun onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler) {
        Log.e(tag, "onHotBoxDataRsp: " )
        coreHandlerCallBack?.onHotBoxDataRsp(hotBoxData, handler)
    }

    override fun onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler) {
        coreHandlerCallBack?.onTimeStampRsp(timeStamp, handler)
    }

    override fun onScheduleRsp(schedule: Schedule, handler: DeviceHandler) {
        coreHandlerCallBack?.onScheduleRsp(schedule, handler)
    }

    /**********************************************************************************************
     * BLUETOOTH STATE CHANGED LISTENER
     *********************************************************************************************/
    override fun onBluetoothOn() {
        isBleAvailable = true
        reconnectAll()
    }

    private fun reconnectAll() {
        Handler(Looper.getMainLooper()).postDelayed({
            for (device in connectedDevices) {
                Log.e(tag, "reconnectAll: ${device.getDevice().getAddress()}")
//                device.connect()
                reconnect(device.getDevice().getAddress(), true)
            }
        }, 2000)
    }

    override fun onBluetoothOff() {
        isBleAvailable = false
//        for (device in connectedDevices) {
//            device.requestToDisconnect()
//        }

    }

}