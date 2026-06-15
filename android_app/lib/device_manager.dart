import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'device.dart';

class DeviceManager {
  static const String storageKey = "enclavedesk_devices";

  static final List<Device> devices = [
    Device(name: "ACER", ip: "192.168.0.106", connected: true),
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

  static Future<void> saveDevices() async {
    final prefs = await SharedPreferences.getInstance();

    final data = devices.map((d) => d.toJson()).toList();

    await prefs.setString(storageKey, jsonEncode(data));
  }

  static Future<void> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(storageKey);

    if (data == null) {
      return;
    }

    final decoded = jsonDecode(data) as List;

    devices.clear();

    for (final item in decoded) {
      devices.add(Device.fromJson(item));
    }
  }

  static Device? findDevice(String name, String ip) {
    for (final device in devices) {
      if (device.name == name && device.ip == ip) {
        return device;
      }
    }

    return null;
  }

  static Future<Device> addDevice(Device device) async {
    final existing = findDevice(device.name, device.ip);

    if (existing != null) {
      return existing;
    }

    devices.add(device);

    await saveDevices();

    return device;
  }

  static Future<void> removeDevice(Device device) async {
    devices.remove(device);

    await saveDevices();
  }

  static Future<void> connect(Device device) async {
    for (final d in devices) {
      d.connected = false;
    }

    device.connected = true;

    await saveDevices();
  }
}
