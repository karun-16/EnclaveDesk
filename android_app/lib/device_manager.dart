import 'device.dart';

class DeviceManager {
  static final List<Device> devices = [
    Device(name: "ACER", ip: "192.168.0.5", connected: true),
  ];

  static Device? currentDevice() {
    if (devices.isEmpty) {
      return null;
    }

    for (final device in devices) {
      if (device.connected) {
        return device;
      }
    }

    return devices.first;
  }

  static void addDevice(Device device) {
    devices.add(device);
  }

  static void removeDevice(Device device) {
    devices.remove(device);
  }

  static void connect(Device device) {
    for (final d in devices) {
      d.connected = false;
    }

    device.connected = true;
  }
}
