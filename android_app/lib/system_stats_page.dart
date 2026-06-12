import 'package:flutter/material.dart';

class SystemStatsPage extends StatelessWidget {
  const SystemStatsPage({super.key});

  Widget statTile(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("System Stats")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            statTile("CPU", "--", Icons.memory),

            statTile("GPU", "--", Icons.videogame_asset),

            statTile("RAM", "--", Icons.storage),

            statTile("Storage", "--", Icons.sd_storage),

            statTile("Battery", "--", Icons.battery_full),
          ],
        ),
      ),
    );
  }
}
