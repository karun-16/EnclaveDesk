import 'package:flutter/material.dart';

import 'main.dart';
import 'mouse_page.dart';
import 'keyboard_page.dart';

class MainPager extends StatelessWidget {
  const MainPager({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(initialPage: 1),

      children: const [MousePage(), HomePage(), KeyboardPage()],
    );
  }
}
