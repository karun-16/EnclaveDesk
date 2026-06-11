import 'package:flutter/material.dart';
import 'device.dart';
import 'device_manager.dart';

class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({super.key});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final nameController = TextEditingController();

  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Device"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Device Name"),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: ipController,
            decoration: const InputDecoration(labelText: "IP Address"),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            if (nameController.text.isEmpty || ipController.text.isEmpty) {
              return;
            }

            DeviceManager.addDevice(
              Device(
                name: nameController.text,
                ip: ipController.text,
                connected: false,
              ),
            );

            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
