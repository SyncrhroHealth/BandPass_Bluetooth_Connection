package com.syncrhrohealth.bandpass_ble_connection.core.model


data class Header(
    val type: Byte
) {
    companion object {
        /** Size of the header in bytes: only the one payload-type byte. */
        const val HEADER_SIZE = 1
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