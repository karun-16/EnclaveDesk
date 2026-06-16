import 'package:flutter/material.dart';

import 'device_manager.dart';
import 'keyboard_page.dart';
import 'network_service.dart';

class MousePage extends StatelessWidget {
  const MousePage({super.key});

  static const double baseSensitivity = 3.5;

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
                behavior: HitTestBehavior.opaque,

                onPanUpdate: (details) async {
                  final device = DeviceManager.currentDevice();

                  if (device == null) return;

                  double speed = details.delta.distance;

                  double multiplier = baseSensitivity;

                  if (speed > 1) {
                    multiplier = 4.0;
                  }

                  if (speed > 3) {
                    multiplier = 6.0;
                  }

                  if (speed > 6) {
                    multiplier = 8.0;
                  }

                  if (speed > 10) {
                    multiplier = 10.0;
                  }

                  int dx = (details.delta.dx * multiplier).round();

                  int dy = (details.delta.dy * multiplier).round();

                  if (dx == 0 && dy == 0) {
                    return;
                  }

                  await NetworkService.sendCommand(device.ip, "MOVE:$dx:$dy");
                },

                onTap: () async {
                  final device = DeviceManager.currentDevice();

                  if (device == null) return;

                  await NetworkService.sendCommand(device.ip, "LEFT_CLICK");
                },
                onDoubleTap: () async {
                  final device = DeviceManager.currentDevice();

                  if (device == null) return;

                  await NetworkService.sendCommand(device.ip, "DOUBLE_CLICK");
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
