package com.syncrhrohealth.bandpass_ble_connection.ble;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;


public class BleStateController {
    public interface BluetoothStateListener {
        void onBluetoothOn();
        void onBluetoothOff();
    }

    private final String TAG = this.getClass().getName();
    private static BleStateController mBleController = null;
    private BluetoothAdapter mBtAdapter;
    private final List<BluetoothStateListener> mListeners = new ArrayList<>();

    private BleStateController(Context context) {
        try {
            mBtAdapter = BluetoothAdapter.getDefaultAdapter();

            // Register for broadcasts when a device is discovered.
            IntentFilter BTIntent = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
            BroadcastReceiver mReceiver = new BroadcastReceiver() {
                public void onReceive(Context context, Intent intent) {
                    String action = intent.getAction();
                    assert action != null;

                    if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
                        final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);
                        if (mListeners.isEmpty()) return;

                        switch (state) {
                            case BluetoothAdapter.STATE_OFF:
                                Log.d(TAG, "Bluetooth state change: " + BluetoothAdapter.STATE_OFF);
                                for (BluetoothStateListener listener : mListeners) {
                                    listener.onBluetoothOff();
                                }
                                break;
                            case BluetoothAdapter.STATE_ON:
                                Log.d(TAG, "Bluetooth state change: " + BluetoothAdapter.STATE_ON);
                                for (BluetoothStateListener listener : mListeners) {
                                    listener.onBluetoothOn();
                                }
                                break;
                        }
                    }
                }
            };
            context.registerReceiver(mReceiver, BTIntent);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    public static BleStateController getInstance(Context context) {
        if (mBleController == null) {
            mBleController = new BleStateController(context);
        }
        return mBleController;
    }

    public void setListener(BluetoothStateListener listener) {
        this.mListeners.add(listener);
    }

    public boolean isBluetoothEnabled() {
        return mBtAdapter.isEnabled();
    }

    // TODO: test if the new function works then remove this
//    @SuppressLint("MissingPermission")
//    public void enableBtAdapter() {
//        if (!mBtAdapter.isEnabled()) {
//            mBtAdapter.enable();
//        }
//    }

    @SuppressLint("MissingPermission")
    public void enableBtAdapter(Context context) {
        if (!mBtAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            context.startActivity(enableBtIntent);
        }
    }
}