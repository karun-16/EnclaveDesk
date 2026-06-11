import 'package:flutter/material.dart';
import 'device_manager.dart';
import 'add_device_dialog.dart';

class ConnectedDevicesPage extends StatefulWidget {
  const ConnectedDevicesPage({super.key});

  @override
  State<ConnectedDevicesPage> createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connected Devices")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddDeviceDialog(),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),

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

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (device.connected)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),

            onTap: () {
              setState(() {
                DeviceManager.connect(device);
              });

              Navigator.pop(context);
            },
            onLongPress: () {
              if (device.connected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cannot remove active device.")),
                );

                return;
              }

              setState(() {
                DeviceManager.removeDevice(device);
              });
            },
          );
        },
      ),
    );
  }
}
