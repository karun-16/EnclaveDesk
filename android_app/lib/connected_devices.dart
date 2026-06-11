import 'package:flutter/material.dart';

import 'device.dart';
import 'device_manager.dart';
import 'add_device_dialog.dart';
import 'qr_scanner_page.dart';

class ConnectedDevicesPage extends StatefulWidget {
  const ConnectedDevicesPage({super.key});

  @override
  State<ConnectedDevicesPage> createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connected Devices")),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text("Add Device"),

                      onTap: () {
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          builder: (_) => const AddDeviceDialog(),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                    ),

                    ListTile(
                      leading: const Icon(Icons.qr_code_scanner),
                      title: const Text("Scan QR"),

                      onTap: () async {
                        Navigator.pop(context);

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QRScannerPage(),
                          ),
                        );

                        if (result == null) {
                          return;
                        }

                        String data = result.toString();

                        List<String> parts = data.split("|");

                        if (parts.length == 3 && parts[0] == "ENCLAVEDESK") {
                          String name = parts[1];
                          String ip = parts[2];

                          final device = await DeviceManager.addDevice(
                            Device(name: name, ip: ip),
                          );

                          await DeviceManager.connect(device);

                          if (!mounted) return;

                          setState(() {});
                        } else {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid EnclaveDesk QR"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      body: ListView.builder(
        itemCount: DeviceManager.devices.length,

        itemBuilder: (context, index) {
          final device = DeviceManager.devices[index];

          return ListTile(
            leading: Icon(
              device.connected ? Icons.computer : Icons.computer_outlined,
            ),

            title: Text(device.name),

            subtitle: Text(device.ip),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (device.connected)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),

            onTap: () async {
              await DeviceManager.connect(device);

              if (!mounted) return;

              setState(() {});

              Navigator.pop(context);
            },

            onLongPress: () async {
              if (device.connected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cannot remove active device.")),
                );

                return;
              }

              await DeviceManager.removeDevice(device);

              if (!mounted) return;

              setState(() {});
            },
          );
        },
      ),
    );
  }
}
