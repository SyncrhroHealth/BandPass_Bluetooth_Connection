package com.syncrhrohealth.bandpass_ble_connection.core.parser

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Header
import com.syncrhrohealth.bandpass_ble_connection.core.model.Packet
import com.syncrhrohealth.bandpass_ble_connection.util.ByteUtils
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.BlockingQueue


class DataParser(private val handler: DeviceHandler, private val callback: (Packet) -> Unit) :
    Runnable {
    private val buffer: BlockingQueue<ByteArray> = ArrayBlockingQueue(500)

    override fun run() {
        while (!handler.executor.isShutdown &&
            !handler.executor.isTerminated
        ) {
            try {
                val bytesPacket = buffer.take()
                parse(bytesPacket)
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }
    }

    fun push(bytesPacket: ByteArray) {
        buffer.put(bytesPacket)
    }


    private fun parse(bytesPacket: ByteArray) {
        Log.e(this.javaClass.simpleName, "bytesPacket: $bytesPacket")
        val header = readHeader(bytesPacket)
        if (header != null) {
            val data = readData(bytesPacket)
            callback(Packet(header, data))
        }
    }

    /** Packet structure:
     *
     * Header (1 bytes): Data type(1 byte)
     * DATA (256 bytes)
     *
     */

    /** Header is from pos 0 to 1  of packet
     * Header.HEADER_SIZE = 1
     * */
    private fun readHeader(bytesPacket: ByteArray): Header? {
        try {
            val headerBytes = ByteUtils.subByteStartStopArray(bytesPacket, 0, Header.HEADER_SIZE)
            return Header(
                headerBytes[0]
            )
        } catch (e: Exception) {
            return null
        }

    }

    /** Data is from pos 4 to length of packet
     * Header.HEADER_SIZE = 4
     * */
    private fun readData(bytesPacket: ByteArray): ByteArray {
        return ByteUtils.subByteStartStopArray(bytesPacket, Header.HEADER_SIZE, bytesPacket.size)
    }
}