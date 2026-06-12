import 'package:flutter/material.dart';

class PowerOptionsPage extends StatelessWidget {
  const PowerOptionsPage({super.key});

  Widget powerButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(text, style: const TextStyle(fontSize: 18)),
          onPressed: () {},
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
            powerButton("Sleep", Icons.bed),

            powerButton("Shutdown", Icons.power_settings_new),

            powerButton("Restart", Icons.restart_alt),

            powerButton("Sign Out", Icons.logout),
          ],
        ),
      ),
    );
  }
}
