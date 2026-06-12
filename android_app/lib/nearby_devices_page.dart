import 'dart:io';

import 'package:flutter/material.dart';

class NearbyDevicesPage extends StatefulWidget {
  const NearbyDevicesPage({super.key});

  @override
  State<NearbyDevicesPage> createState() => _NearbyDevicesPageState();
}

class _NearbyDevicesPageState extends State<NearbyDevicesPage> {
  final List<String> devices = [];

  RawDatagramSocket? socket;

  @override
  void initState() {
    super.initState();
    discover();
  }

  Future<void> discover() async {
    socket?.close();
    try {
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      socket!.broadcastEnabled = true;

      socket!.send(
        "ENCLAVEDESK_DISCOVER".codeUnits,
        InternetAddress("255.255.255.255"),
        7879,
      );

      socket!.listen((event) {
        if (event != RawSocketEvent.read) {
          return;
        }

        final dg = socket!.receive();

        if (dg == null) {
          return;
        }

        final msg = String.fromCharCodes(dg.data);

        if (devices.any((d) => d == msg)) {
          return;
        }

        setState(() {
          devices.add(msg);
        });

        socket?.close();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Devices"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                devices.clear();
              });

              discover();
            },
          ),
        ],
      ),
      body: devices.isEmpty
          ? const Center(
              child: Text("Searching...", style: TextStyle(fontSize: 24)),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final parts = devices[index].split("|");
                String name = parts[1];
                String ip = parts[2];

                return ListTile(
                  leading: const Icon(Icons.computer),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [const Text("Windows PC"), Text(ip)],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, devices[index]);
                    },
                    child: const Text("CONNECT"),
                  ),
                );
              },
            ),
    );
  }
}
