import 'package:flutter/material.dart';
import 'device_manager.dart';
import 'network_service.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  double volume = 50;
  double previousVolume = 50;
  double brightness = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controls")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- VOLUME ----------------
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    volume == 0 ? Icons.volume_off : Icons.volume_up,
                    size: 32,
                  ),

                  onPressed: () async {
                    final device = DeviceManager.currentDevice();

                    if (device == null) {
                      return;
                    }

                    if (volume > 0) {
                      previousVolume = volume;

                      setState(() {
                        volume = 0;
                      });

                      await NetworkService.sendCommand(device.ip, "MUTE");
                    } else {
                      setState(() {
                        volume = previousVolume;
                      });

                      await NetworkService.sendCommand(
                        device.ip,
                        "VOLUME:${previousVolume.round()}",
                      );
                    }
                  },
                ),

                const SizedBox(width: 10),

                const Text(
                  "Volume",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Slider(
              value: volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: volume.round().toString(),
              onChanged: (v) async {
                setState(() {
                  volume = v;
                });
                if (v > 0) {
                  previousVolume = v;
                }

                final device = DeviceManager.currentDevice();

                if (device == null) return;

                await NetworkService.sendCommand(
                  device.ip,
                  "VOLUME:${v.round()}",
                );
              },
            ),

            const SizedBox(height: 30),

            // ---------------- BRIGHTNESS ----------------
            const Text(
              "Brightness",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Slider(
              value: brightness,
              min: 0,
              max: 100,
              divisions: 100,
              label: brightness.round().toString(),
              onChanged: (v) {
                setState(() {
                  brightness = v;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
