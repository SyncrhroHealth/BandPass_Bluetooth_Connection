package com.syncrhrohealth.bandpass_ble_connection.core.model

import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode


data class Header(
    val commandCode: CommandCode?,
    val length: Int,
    val msgIndex: Int
) {
    companion object {
        const val HEADER_SIZE = 4
    }
}

data class Packet(val header: Header, val data: ByteArray) {
    // TODO, check why they use these below functions
    // Previous code: the header is the type: CommandCode (Enum)
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Packet

        if (header != other.header) return false
        if (!data.contentEquals(other.data)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = header.hashCode()
        result = 31 * result + data.contentHashCode()
        return result
    }
}