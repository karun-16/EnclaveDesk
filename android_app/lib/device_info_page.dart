import 'package:flutter/material.dart';

class DeviceInfoPage extends StatelessWidget {
  final String name;
  final String os;
  final String user;

  const DeviceInfoPage({
    super.key,
    required this.name,
    required this.os,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Information")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.computer, size: 80),

            const SizedBox(height: 20),

            Text(
              name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text("Operating System"),

            Text(os, style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            Text("User"),

            Text(user, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
