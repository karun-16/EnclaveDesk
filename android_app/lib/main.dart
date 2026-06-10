import 'dart:io';
import 'package:flutter/material.dart';
import 'device.dart';
import 'device_manager.dart';
import 'connected_devices.dart';

void main() {
  runApp(const EnclaveDeskApp());
}

class EnclaveDeskApp extends StatelessWidget {
  const EnclaveDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EnclaveDesk",
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Device? current = DeviceManager.currentDevice();

  List<String> apps = [];

  Future<String> sendCommand(String command) async {
    try {
      if (current == null) {
        return "";
      }

      debugPrint("Connecting...");

      final socket = await Socket.connect(current!.ip, 7878);

      debugPrint("Connected!");

      socket.write(command);

      await socket.flush();

      debugPrint("Sent: $command");

      String response = "";

      await for (var data in socket) {
        response += String.fromCharCodes(data);
      }

      await socket.close();

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<void> loadApps() async {
    String result = await sendCommand("LIST_APPS");

    if (result.isEmpty) return;

    apps = result.split(",").where((e) => e.isNotEmpty).toList();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Custom Apps"),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: apps.length,
              itemBuilder: (context, index) {
                String appName = apps[index].split("|")[0];

                String appPath = apps[index].split("|")[1];

                return ListTile(
                  title: Text(appName),
                  onTap: () {
                    sendCommand("OPEN_PATH:$appPath");

                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget actionButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            switch (text) {
              case "PING":
                sendCommand("PING");
                break;

              case "DEVICE INFO":
                sendCommand("DEVICE_INFO");
                break;

              case "OPEN APPS":
                sendCommand("OPEN:notepad");
                break;

              case "CUSTOM APPS":
                loadApps();
                break;

              case "SETTINGS":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConnectedDevicesPage(),
                  ),
                ).then((_) {
                  setState(() {
                    current = DeviceManager.currentDevice();
                  });
                });
                break;
            }
          },
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EnclaveDesk"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.computer, size: 90),

            const SizedBox(height: 20),

            Text(
              current?.name ?? "No Device",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Text(current?.ip ?? "", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            Text(
              current?.connected == true ? "🟢 Connected" : "🔴 Disconnected",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            actionButton("PING"),

            actionButton("DEVICE INFO"),

            actionButton("OPEN APPS"),

            actionButton("CUSTOM APPS"),

            actionButton("SETTINGS"),
          ],
        ),
      ),
    );
  }
}
