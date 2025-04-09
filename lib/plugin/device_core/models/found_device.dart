class FoundDevice {
  final String? name;
  final String address;
  final int? rssi;

  FoundDevice({
    this.name,
    required this.address,
    this.rssi,
  });

  static FoundDevice fromMap(dynamic map) {
    return FoundDevice(
      name: map['name'],
      address: map['address'],
      rssi: map['rssi'],
    );
  }
}
