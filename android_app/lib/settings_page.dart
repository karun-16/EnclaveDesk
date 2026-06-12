import 'package:flutter/material.dart';
import 'device_info_page.dart';
import 'connected_devices.dart';
import 'system_stats_page.dart';
import 'controls_page.dart';
import 'power_options_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Device Information"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DeviceInfoPage(
                    name: "ACER",
                    os: "windows",
                    user: "mkaru",
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text("Connected Devices"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConnectedDevicesPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.memory),
            title: const Text("System Stats"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SystemStatsPage(
                    cpu: "Intel CPU",
                    gpu: "Unknown GPU",
                    ram: "16 GB",
                    storage: "512 GB",
                    battery: "Unknown",
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text("Controls"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ControlsPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text("Power Options"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PowerOptionsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
