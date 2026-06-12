import 'package:flutter/material.dart';

import 'device_manager.dart';
import 'network_service.dart';

class PowerOptionsPage extends StatelessWidget {
  const PowerOptionsPage({super.key});

  Future<void> sendPower(String command) async {
    final device = DeviceManager.currentDevice();

    if (device == null) {
      return;
    }

    await NetworkService.sendCommand(device.ip, command);
  }

  Widget powerButton(String text, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(text, style: const TextStyle(fontSize: 18)),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Power Options")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            powerButton("Sleep", Icons.bed, () {
              sendPower("SLEEP");
            }),

            powerButton("Shutdown", Icons.power_settings_new, () {
              sendPower("SHUTDOWN");
            }),

            powerButton("Restart", Icons.restart_alt, () {
              sendPower("RESTART");
            }),

            powerButton("Sign Out", Icons.logout, () {
              sendPower("SIGNOUT");
            }),
          ],
        ),
      ),
    );
  }
}
