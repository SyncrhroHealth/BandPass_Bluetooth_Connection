# bandpass_ble_connection

A Flutter plugin for connecting to BandPass devices via Bluetooth Low Energy (BLE). This plugin provides functionality to scan, connect, and communicate with BandPass BLE devices, including receiving IMU data and battery information.

## Features

- 🔍 Scan for BandPass BLE devices
- 🔌 Connect and disconnect from devices
- 📊 Receive IMU (Inertial Measurement Unit) data
- 🔋 Receive battery level information
- 📱 Device information retrieval
- 🔄 Automatic reconnection support
- 📡 Event-based architecture for real-time updates

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  bandpass_ble_connection:
    path: ../bandpass_ble_connection  # or use git/version if published
  permission_handler: ^12.0.0+1
  device_info_plus: ^11.2.1
```

Then run:

```bash
flutter pub get
```

## Platform Configuration

### iOS Configuration

#### 1. Add Bluetooth Permissions to Info.plist

Open `ios/Runner/Info.plist` and add the following keys:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth access to connect to BandPass devices</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app needs Bluetooth access to connect to BandPass devices</string>
```

#### 2. Add Background Mode (Optional)

If you need background BLE functionality, add:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
</array>
```

#### 3. Minimum iOS Version

The plugin requires iOS 13.0 or higher. Ensure your `ios/Podfile` specifies:

```ruby
platform :ios, '13.0'
```

### Android Configuration

#### 1. Add Permissions to AndroidManifest.xml

Open `android/app/src/main/AndroidManifest.xml` and add the following permissions:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Bluetooth permissions for Android 12+ (API 31+) -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" 
                     android:usesPermissionFlags="neverForLocation" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    
    <!-- Location permission (required for BLE scanning on older Android versions) -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <!-- Required for Android 12+ -->
    <uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />
</manifest>
```

#### 2. Minimum Android Version

The plugin requires Android API level 21 (Android 5.0) or higher.

## Usage

### 1. Initialize the Plugin

In your `main.dart`, initialize the plugin before running your app:

```dart
import 'package:bandpass_ble_connection/bandpass_ble_connection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Subscribe to plugin events (required)
  BandpassBleConnection.subscribePluginEvents();
  
  runApp(const MyApp());
}
```

### 2. Request Permissions

Request Bluetooth and Location permissions before scanning:

```dart
// Request permissions
await BandpassBleConnection.checkPermission();

// Check if permissions are granted
final hasPermission = await DeviceCorePlugin.hasPermission();
if (!hasPermission) {
  // Handle permission denial
  return;
}
```

### 3. Check Bluetooth Status

```dart
final isEnabled = await BandpassBleConnection.isBleEnabled();
if (!isEnabled) {
  // Prompt user to enable Bluetooth
}
```

### 4. Scan for Devices

```dart
// Start scanning
await BandpassBleConnection.startScan();

// Stop scanning
await BandpassBleConnection.stopScan();
```

### 5. Listen for Found Devices

```dart
BandpassBleConnection.listenFoundDevice((device) {
  print('Found device: ${device.name}');
  print('Address: ${device.address}');
  print('RSSI: ${device.rssi}');
});
```

### 6. Connect to a Device

```dart
// Connect using device address
await BandpassBleConnection.connect(deviceAddress);

// Listen for connection events
BandpassBleConnection.listenConnectedDevice((device) {
  print('Connected to: ${device.name}');
  print('Address: ${device.address}');
});

// Listen for disconnection events
BandpassBleConnection.listenDisconnectedDevice((device) {
  print('Disconnected from: ${device.name}');
});
```

### 7. Receive IMU Data

```dart
BandpassBleConnection.listenImuData((imuData) {
  print('IMU Data received:');
  print('  Count: ${imuData.count}');
  print('  Accelerometer: X=${imuData.accelX}, Y=${imuData.accelY}, Z=${imuData.accelZ}');
  print('  Gyroscope: X=${imuData.gyroX}, Y=${imuData.gyroY}, Z=${imuData.gyroZ}');
  print('  ADC Raw: ${imuData.adcRaw}');
  print('  Date: ${imuData.date}');
  print('  Time: ${imuData.timeMs}');
});
```

### 8. Receive Battery Information

```dart
BandpassBleConnection.listenBatteryInfo((batteryInfo) {
  print('Battery Level: ${batteryInfo.level}%');
  print('Device Address: ${batteryInfo.address}');
});
```

### 9. Get Device Information

```dart
// Request device info (triggers an event response)
await DeviceCorePlugin.getDeviceInfo(address: deviceAddress);

// Listen for device info response
DeviceCorePlugin.listenEvent().listen((event) {
  if (event.event == EventEnum.onDeviceInfoRsp) {
    final deviceInfo = event.toDeviceInfo();
    print('FW Version: ${deviceInfo.fwVersion}');
    print('HW Version: ${deviceInfo.hwVersion}');
    print('MAC Address: ${deviceInfo.macAddress}');
    print('Device Name: ${deviceInfo.deviceName}');
  }
});
```

### 10. Disconnect from Device

```dart
await BandpassBleConnection.disconnect(deviceAddress);
```

## Complete Example

```dart
import 'package:bandpass_ble_connection/bandpass_ble_connection.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BandpassBleConnection.subscribePluginEvents();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _connectedDeviceAddress;

  @override
  void initState() {
    super.initState();
    _setupListeners();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await BandpassBleConnection.checkPermission();
  }

  void _setupListeners() {
    // Listen for found devices
    BandpassBleConnection.listenFoundDevice((device) {
      print('Found: ${device.name} (${device.address})');
      // Auto-connect to first found device (optional)
      if (_connectedDeviceAddress == null) {
        BandpassBleConnection.connect(device.address);
      }
    });

    // Listen for connections
    BandpassBleConnection.listenConnectedDevice((device) {
      setState(() {
        _connectedDeviceAddress = device.address;
      });
      print('Connected to: ${device.name}');
    });

    // Listen for IMU data
    BandpassBleConnection.listenImuData((imuData) {
      print('IMU: Accel(${imuData.accelX}, ${imuData.accelY}, ${imuData.accelZ})');
    });

    // Listen for battery info
    BandpassBleConnection.listenBatteryInfo((batteryInfo) {
      print('Battery: ${batteryInfo.level}%');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BandPass BLE Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => BandpassBleConnection.startScan(),
                child: const Text('Start Scan'),
              ),
              ElevatedButton(
                onPressed: () => BandpassBleConnection.stopScan(),
                child: const Text('Stop Scan'),
              ),
              if (_connectedDeviceAddress != null)
                Text('Connected: $_connectedDeviceAddress'),
            ],
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### Static Methods

#### Connection Management
- `Future<bool> isBleEnabled()` - Check if Bluetooth is enabled
- `Future<void> checkPermission()` - Request Bluetooth and Location permissions
- `Future<void> startScan()` - Start scanning for devices
- `Future<void> stopScan()` - Stop scanning
- `Future<void> connect(String address)` - Connect to a device by address
- `Future<void> disconnect(String address)` - Disconnect from a device
- `void subscribePluginEvents()` - Subscribe to plugin events (call in main())

#### Event Listeners
- `void listenFoundDevice(Function(FoundDevice) callback)` - Listen for found devices
- `void listenConnectedDevice(Function(ConnectedDevice) callback)` - Listen for connections
- `void listenDisconnectedDevice(Function(DisconnectedDevice) callback)` - Listen for disconnections
- `void listenImuData(Function(ImuData) callback)` - Listen for IMU data
- `void listenBatteryInfo(Function(BatteryInfo) callback)` - Listen for battery information

### Data Models

#### FoundDevice
```dart
class FoundDevice {
  final String name;
  final String address;
  final int rssi;
}
```

#### ConnectedDevice / DisconnectedDevice
```dart
class ConnectedDevice {
  final String name;
  final String address;
}
```

#### ImuData
```dart
class ImuData {
  final int count;
  final double accelX, accelY, accelZ;  // Accelerometer values
  final double gyroX, gyroY, gyroZ;     // Gyroscope values
  final int adcRaw;                      // ADC raw value
  final String date;                     // Date in yyyy-MM-dd format (UTC)
  final String timeMs;                   // Time in HH:mm:ss.SSS format (UTC)
  final String address;                   // Device address
}
```

#### BatteryInfo
```dart
class BatteryInfo {
  final int level;        // Battery level (0-100)
  final String address;   // Device address
}
```

## Important Notes

### iOS

1. **Physical Device Required**: BLE does not work on iOS Simulator. You must test on a physical iOS device.

2. **MTU Size**: iOS automatically negotiates MTU size (typically 185 bytes, sometimes up to 251 bytes). The plugin requests 512 bytes but will work with the negotiated size. The actual MTU is logged during connection.

3. **Permissions**: Bluetooth permissions are required. The app will prompt the user on first use.

4. **Background Mode**: If you need background BLE functionality, ensure `bluetooth-central` is added to `UIBackgroundModes` in Info.plist.

### Android

1. **Runtime Permissions**: Android 6.0+ requires runtime permissions. The plugin handles this automatically via `checkPermission()`.

2. **Location Permission**: BLE scanning requires location permission on Android 6.0-11. On Android 12+, only Bluetooth permissions are needed.

3. **MTU Size**: Android supports requesting MTU size up to 512 bytes. The plugin automatically requests this during connection.

4. **Bluetooth State**: Always check if Bluetooth is enabled before scanning or connecting.

## Troubleshooting

### iOS: "BLE is not enabled yet"
- Ensure Bluetooth is enabled in iOS Settings
- Grant Bluetooth permissions when prompted
- Wait for `centralManagerDidUpdateState` to be called (happens asynchronously)
- Check logs for the actual BLE state

### Android: Permission Denied
- Ensure all required permissions are in AndroidManifest.xml
- Call `checkPermission()` before scanning
- For Android 12+, ensure all Bluetooth permissions are granted

### No Devices Found
- Ensure the device is powered on and advertising
- Check that the device name starts with the expected prefix (default: "HOT-BOX")
- Verify Bluetooth is enabled on both devices
- On Android, ensure location services are enabled (required for BLE scanning)

### Connection Fails
- Verify the device address is correct
- Ensure the device is in range
- Check that the device is not already connected to another app
- Verify Bluetooth is enabled

## Dependencies

This plugin requires the following dependencies (already included in pubspec.yaml):

- `permission_handler: ^12.0.0+1` - For requesting permissions
- `device_info_plus: ^11.2.1` - For device information
- `location: ^7.0.1` - For location services (Android BLE requirement)

## License

[Add your license here]

## Support

For issues and feature requests, please open an issue on the project repository.
