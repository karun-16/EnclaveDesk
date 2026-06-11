import 'package:flutter/material.dart';

class AddDeviceDialog extends StatelessWidget {
  const AddDeviceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Device"),

      content: const Text("QR Pairing coming soon."),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
