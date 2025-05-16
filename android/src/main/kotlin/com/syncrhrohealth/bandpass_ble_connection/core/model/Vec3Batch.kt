package com.syncrhrohealth.bandpass_ble_connection.core.model

data class Vec3Batch(
    val x: ShortArray,
    val y: ShortArray,
    val z: ShortArray
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Vec3Batch

        if (!x.contentEquals(other.x)) return false
        if (!y.contentEquals(other.y)) return false
        if (!z.contentEquals(other.z)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = x.contentHashCode()
        result = 31 * result + y.contentHashCode()
        result = 31 * result + z.contentHashCode()
        return result
    }
}