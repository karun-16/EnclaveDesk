import 'package:flutter/material.dart';
import 'mouse_page.dart';

class KeyboardPage extends StatelessWidget {
  const KeyboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keyboard")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.grey.shade900,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: Colors.white24, width: 2),
                ),

                child: const Center(
                  child: Text("Keyboard", style: TextStyle(fontSize: 28)),
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
                    MaterialPageRoute(builder: (_) => const MousePage()),
                  );
                },

                icon: const Icon(Icons.mouse),

                label: const Text("Mouse", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
