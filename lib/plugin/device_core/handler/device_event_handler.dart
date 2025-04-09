import 'dart:async';

import '../device_event_task.dart';

class DeviceEventHandler {
  static final listeners = StreamController<DeviceEventTask>.broadcast();

  static void handle({DeviceEventTask? data}) async {
    if (data == null) {
      return;
    }
    listeners.add(data);
  }
}
