import 'package:flutter/material.dart';

import 'mouse_page.dart';

/// A [GlobalKey] that lets [MainPager] call [KeyboardPageState.openKeyboard]
/// and [KeyboardPageState.closeKeyboard] directly.
///
/// Because KeyboardPage lives inside a persistent PageView it is never pushed
/// or popped, so RouteAware / RouteObserver are irrelevant. Instead, MainPager
/// detects the page-index change and instructs KeyboardPage through this key.
final GlobalKey<KeyboardPageState> keyboardPageKey =
    GlobalKey<KeyboardPageState>();

class KeyboardPage extends StatefulWidget {
  const KeyboardPage({super.key});

  @override
  State<KeyboardPage> createState() => KeyboardPageState();
}

/// State is intentionally public so [MainPager] can call
/// [openKeyboard] / [closeKeyboard] via [keyboardPageKey].
class KeyboardPageState extends State<KeyboardPage>
    with WidgetsBindingObserver {
  // ── controllers ────────────────────────────────────────────────────────────

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // ── lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Watch app-lifecycle events so the keyboard closes when the user
    // presses Home or switches apps, and reopens on resume (if on this page).
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── WidgetsBindingObserver ─────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // Always close IME when the app loses focus.
        _closeIME();
        break;
      case AppLifecycleState.resumed:
        // MainPager tracks the current page index. On resume it will call
        // openKeyboard() itself if the user left the app on page 2.
        break;
      default:
        break;
    }
  }

  // ── public API called by MainPager ─────────────────────────────────────────

  /// Called by [MainPager] when page 2 becomes the visible page.
  void openKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  /// Called by [MainPager] when the user swipes away from page 2.
  void closeKeyboard() => _closeIME();

  // ── private helpers ────────────────────────────────────────────────────────

  void _closeIME() {
    // unfocus() is the correct Flutter mechanism. It sends
    // TextInput.clearClient to the platform, which causes Android to hide
    // the soft keyboard — no manual channel calls needed.
    _focusNode.unfocus();
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keeps the Mouse button visible above the IME.
      resizeToAvoidBottomInset: true,

      appBar: AppBar(title: const Text('Keyboard')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── single-line text field ──────────────────────────────────────
            TextField(
              autofocus: true,
              controller: _controller,
              focusNode: _focusNode,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Type here…',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            // ── mouse button ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  _closeIME();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MousePage()),
                  );
                },
                icon: const Icon(Icons.mouse),
                label: const Text('Mouse', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
