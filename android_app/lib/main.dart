import 'dart:io';
import 'package:flutter/material.dart';
import 'device.dart';
import 'device_manager.dart';
import 'connected_devices.dart';
import 'nearby_devices_page.dart';
import 'settings_page.dart';
import 'mouse_page.dart';
import 'main_pager.dart';
import 'keyboard_page.dart' show routeObserver;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DeviceManager.loadDevices();

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
      home: const MainPager(),
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
  Future<void> discoverDevices() async {
    try {
      RawDatagramSocket socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0,
      );

      socket.broadcastEnabled = true;

      socket.send(
        "ENCLAVEDESK_DISCOVER".codeUnits,
        InternetAddress("255.255.255.255"),
        7879,
      );

      socket.listen((event) async {
        if (event != RawSocketEvent.read) {
          return;
        }

        Datagram? dg = socket.receive();

        if (dg == null) {
          return;
        }

        String msg = String.fromCharCodes(dg.data);

        List<String> parts = msg.split("|");

        if (parts.length != 4) {
          return;
        }

        if (parts[0] != "ENCLAVEDESK") {
          return;
        }

        String name = parts[1];
        String ip = parts[2];

        final device = await DeviceManager.addDevice(
          Device(name: name, ip: ip),
        );

        await DeviceManager.connect(device);

        if (!mounted) {
          return;
        }

        setState(() {
          current = device;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Connected to $name")));

        socket.close();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> sendCommand(String command) async {
    try {
      if (current == null) {
        debugPrint("No device selected.");
        return "";
      }

      debugPrint("================================");
      debugPrint("Current Device : ${current!.name}");
      debugPrint("Current IP     : ${current!.ip}");
      debugPrint("Command        : $command");
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

      debugPrint("Response: $response");
      debugPrint("Connection closed.");
      debugPrint("================================");

      return response;
    } catch (e) {
      debugPrint("================================");
      debugPrint("ERROR:");
      debugPrint(e.toString());
      debugPrint("================================");
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
                () async {
                  String result = await sendCommand("DEVICE_INFO");

                  if (result.isEmpty) {
                    return;
                  }

                  List<String> parts = result.split("|");

                  if (parts.length != 3) {
                    return;
                  }

                  if (!context.mounted) {
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Device Information"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🖥 ${parts[0]}"),
                            const SizedBox(height: 10),
                            Text("OS : ${parts[1]}"),
                            Text("User : ${parts[2]}"),
                          ],
                        ),
                      );
                    },
                  );
                }();

                break;

              case "OPEN APPS":
                sendCommand("OPEN:notepad");
                break;

              case "CUSTOM APPS":
                loadApps();
                break;
              case "MOUSE":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MousePage()),
                );
                break;

              case "NEARBY":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NearbyDevicesPage()),
                ).then((result) async {
                  if (result == null) {
                    return;
                  }

                  List<String> parts = result.toString().split("|");

                  if (parts.length != 4) {
                    return;
                  }

                  String name = parts[1];
                  String ip = parts[2];

                  final device = await DeviceManager.addDevice(
                    Device(name: name, ip: ip),
                  );

                  await DeviceManager.connect(device);

                  setState(() {
                    current = device;
                  });

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Connected to $name")));
                });

                break;
              case "SETTINGS":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
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

            actionButton("OPEN APPS"),

            actionButton("CUSTOM APPS"),

            actionButton("SETTINGS"),
          ],
        ),
      ),
    );
  }
}
