import 'package:flutter/material.dart';

class SystemStatsPage extends StatelessWidget {
  final String cpu;
  final String gpu;
  final String ram;
  final String storage;
  final String battery;

  const SystemStatsPage({
    super.key,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.storage,
    required this.battery,
  });

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
            statTile("CPU", cpu, Icons.memory),

            statTile("GPU", gpu, Icons.videogame_asset),

            statTile("RAM", ram, Icons.storage),

            statTile("Storage", storage, Icons.sd_storage),

            statTile("Battery", battery, Icons.battery_full),
          ],
        ),
      ),
    );
  }
}
