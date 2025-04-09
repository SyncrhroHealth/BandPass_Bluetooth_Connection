package com.syncrhrohealth.bandpass_ble_connection.util

import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.RejectedExecutionHandler
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit

object ThreadPoolCreater {
    private const val MIN_NUMBER_OF_CORES = 6
    private const val MAX_NUMBER_OF_CORES = 6
    // Sets the amount of time an idle thread waits before terminating
    private const val KEEP_ALIVE_TIME = 1L
    // Sets the Time Unit to seconds
    private val KEEP_ALIVE_TIME_UNIT = TimeUnit.SECONDS

    // Creates a thread pool manager
    fun create(): ThreadPoolExecutor {
        return ThreadPoolExecutor(
                MIN_NUMBER_OF_CORES,       // Initial pool size
                MAX_NUMBER_OF_CORES,       // Max pool size
                KEEP_ALIVE_TIME,
                KEEP_ALIVE_TIME_UNIT,
                LinkedBlockingQueue<Runnable>(),
                HandlerReject()
        )
    }

}

class HandlerReject: RejectedExecutionHandler {
    override fun rejectedExecution(r: Runnable?, executor: ThreadPoolExecutor?) {
        try {
            executor?.setMaximumPoolSize(executor.maximumPoolSize + 1)
            executor?.submit(r)
        }catch (_: Exception){ }
    }
}