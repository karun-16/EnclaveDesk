import 'package:flutter/material.dart';
import 'device_manager.dart';

class ConnectedDevicesPage extends StatelessWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connected Devices")),
      body: ListView.builder(
        itemCount: DeviceManager.devices.length,
        itemBuilder: (context, index) {
          final device = DeviceManager.devices[index];

          return ListTile(
            leading: Icon(
              device.connected ? Icons.computer : Icons.computer_outlined,
            ),

            title: Text(device.name),

            subtitle: Text(device.ip),

            trailing: device.connected
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,

            onTap: () {
              DeviceManager.connect(device);

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
