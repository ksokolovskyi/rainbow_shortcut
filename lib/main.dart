import 'package:flutter/material.dart';
import 'package:rainbow_shortcut/shortcut_card.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _isLogoVisible = ValueNotifier(false);

  @override
  void dispose() {
    _isLogoVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: ShortcutCard(
                onShortcut: () {
                  _isLogoVisible.value = true;
                },
              ),
            ),
            Positioned(
              right: 15,
              bottom: -35,
              child: ValueListenableBuilder(
                valueListenable: _isLogoVisible,
                builder: (context, isLogoVisible, child) {
                  return AnimatedOpacity(
                    opacity: isLogoVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
                child: FlutterLogo(
                  size: 130,
                  textColor: Colors.white.withOpacity(0.8),
                  style: FlutterLogoStyle.horizontal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
