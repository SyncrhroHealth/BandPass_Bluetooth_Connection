class DisconnectedDevice {
  final String? name;
  final String address;

  DisconnectedDevice({
    this.name,
    required this.address,
  });

  static DisconnectedDevice fromMap(dynamic map) {
    return DisconnectedDevice(
      name: map['name'],
      address: map['address'],
    );
  }
}
