import 'package:flutter/material.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  double volume = 50;

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
            const Text(
              "Volume",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Slider(
              value: volume,

              min: 0,

              max: 100,

              divisions: 100,

              label: volume.round().toString(),

              onChanged: (v) {
                setState(() {
                  volume = v;
                });
              },
            ),

            const SizedBox(height: 30),

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
