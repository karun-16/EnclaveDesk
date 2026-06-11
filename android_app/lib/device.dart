class Device {
  final String name;
  final String ip;
  bool connected;

  Device({required this.name, required this.ip, this.connected = false});

  Map<String, dynamic> toJson() {
    return {"name": name, "ip": ip, "connected": connected};
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      name: json["name"],
      ip: json["ip"],
      connected: json["connected"] ?? false,
    );
  }
}
