import 'package:flutter/material.dart';

import 'main.dart';
import 'mouse_page.dart';
import 'keyboard_page.dart';

const int _kKeyboardPageIndex = 2;

class MainPager extends StatefulWidget {
  const MainPager({super.key});

  @override
  State<MainPager> createState() => MainPagerState();
}

class MainPagerState extends State<MainPager> with WidgetsBindingObserver {
  static final ValueNotifier<bool> mouseActive = ValueNotifier(false);

  final PageController _pageController = PageController(initialPage: 1);

  int _currentPage = 1;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _currentPage == _kKeyboardPageIndex) {
      keyboardPageKey.currentState?.openKeyboard();
    }
  }

  void _onPageChanged(int index) {
    if (_currentPage == _kKeyboardPageIndex && index != _kKeyboardPageIndex) {
      keyboardPageKey.currentState?.closeKeyboard();
    } else if (index == _kKeyboardPageIndex) {
      keyboardPageKey.currentState?.openKeyboard();
    }

    _currentPage = index;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: mouseActive,
      builder: (context, active, child) {
        return PageView(
          controller: _pageController,
          physics: active
              ? const NeverScrollableScrollPhysics()
              : const PageScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: [
            const MousePage(),
            const HomePage(),
            KeyboardPage(key: keyboardPageKey),
          ],
        );
      },
    );
  }
}
