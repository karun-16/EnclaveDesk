import 'package:flutter/material.dart';

import 'keyboard_page.dart';
import 'device_manager.dart';
import 'network_service.dart';

class MousePage extends StatelessWidget {
  const MousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mouse")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) async {
                  final device = DeviceManager.currentDevice();

                  if (device == null) return;

                  int dx = details.delta.dx.toInt();
                  int dy = details.delta.dy.toInt();

                  await NetworkService.sendCommand(device.ip, "MOVE:$dx:$dy");
                },
                onTap: () async {
                  final device = DeviceManager.currentDevice();

                  if (device == null) return;

                  await NetworkService.sendCommand(device.ip, "LEFT_CLICK");
                },
                onLongPress: () async {
                  final device = DeviceManager.currentDevice();

                  if (device == null) return;

                  await NetworkService.sendCommand(device.ip, "RIGHT_CLICK");
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Center(
                    child: Text("Touch Pad", style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KeyboardPage()),
                  );
                },
                icon: const Icon(Icons.keyboard),
                label: const Text("Keyboard", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
