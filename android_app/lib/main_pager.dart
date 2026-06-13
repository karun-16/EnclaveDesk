import 'package:flutter/material.dart';

import 'main.dart';
import 'keyboard_page.dart';
import 'mouse_page.dart';

/// Index of the keyboard page inside the [PageView].
const int _kKeyboardPageIndex = 2;

class MainPager extends StatefulWidget {
  const MainPager({super.key});

  @override
  State<MainPager> createState() => _MainPagerState();
}

class _MainPagerState extends State<MainPager> with WidgetsBindingObserver {
  // Start on HomePage (index 1).
  final PageController _pageController = PageController(initialPage: 1);

  /// Tracks the most-recently settled page so we can reopen the keyboard
  /// when the app resumes while on the keyboard page.
  int _currentPage = 1;

  // ── lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  // ── app lifecycle (Home button / app-switcher) ─────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _currentPage == _kKeyboardPageIndex) {
      // The user came back to the app while the keyboard page was visible.
      keyboardPageKey.currentState?.openKeyboard();
    }
    // Closing on pause/inactive/detach is handled inside KeyboardPageState
    // via its own WidgetsBindingObserver — no duplicate logic needed here.
  }

  // ── page-change handler ────────────────────────────────────────────────────

  void _onPageChanged(int index) {
    // Close keyboard whenever we leave page 2, open it when we arrive.
    if (_currentPage == _kKeyboardPageIndex && index != _kKeyboardPageIndex) {
      keyboardPageKey.currentState?.closeKeyboard();
    } else if (index == _kKeyboardPageIndex) {
      keyboardPageKey.currentState?.openKeyboard();
    }

    _currentPage = index;
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      children: [
        const MousePage(),
        const HomePage(),
        // Pass the global key so MainPager can reach KeyboardPageState.
        KeyboardPage(key: keyboardPageKey),
      ],
    );
  }
}
