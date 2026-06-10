class Device {
  final String name;
  final String ip;
  bool connected;

  Device({required this.name, required this.ip, this.connected = false});
}
