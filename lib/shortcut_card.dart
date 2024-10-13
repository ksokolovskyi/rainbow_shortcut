import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:rainbow_shortcut/rainbow_button.dart';
import 'package:rainbow_shortcut/title.dart';

class ShortcutCard extends StatefulWidget {
  const ShortcutCard({
    required this.onShortcut,
    super.key,
  });

  final VoidCallback onShortcut;

  @override
  State<ShortcutCard> createState() => _ShortcutCardState();
}

class _ShortcutCardState extends State<ShortcutCard> {
  final _isShiftPressed = ValueNotifier(false);
  final _isOptionPressed = ValueNotifier(false);
  final _isRPressed = ValueNotifier(false);

  late final _isButtonPressed = Listenable.merge(
    [_isShiftPressed, _isOptionPressed, _isRPressed],
  );

  final _focusNode = FocusNode();

  bool get isShiftPressed => _isShiftPressed.value;
  bool get isOptionPressed => _isOptionPressed.value;
  bool get isRPressed => _isRPressed.value;

  bool get isButtonPressed => isShiftPressed || isOptionPressed || isRPressed;

  @override
  void initState() {
    super.initState();

    _isShiftPressed.addListener(_shortcutListener);
    _isOptionPressed.addListener(_shortcutListener);
    _isRPressed.addListener(_shortcutListener);
  }

  @override
  void dispose() {
    _isShiftPressed.dispose();
    _isOptionPressed.dispose();
    _isRPressed.dispose();

    _focusNode.dispose();

    super.dispose();
  }

  void _shortcutListener() {
    if (isShiftPressed && isOptionPressed && isRPressed) {
      widget.onShortcut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (_, event) {
        final isKeyDown = event is KeyDownEvent || event is KeyRepeatEvent;

        ValueNotifier<bool>? notifier;

        switch (event.logicalKey) {
          case LogicalKeyboardKey.shift:
          case LogicalKeyboardKey.shiftLeft:
          case LogicalKeyboardKey.shiftRight:
            notifier = _isShiftPressed;

          case LogicalKeyboardKey.alt:
          case LogicalKeyboardKey.altLeft:
          case LogicalKeyboardKey.altRight:
            notifier = _isOptionPressed;

          case LogicalKeyboardKey.keyR:
            notifier = _isRPressed;

          case _:
          // Do nothing;
        }

        if (notifier == null) {
          return KeyEventResult.ignored;
        }

        notifier.value = isKeyDown;

        return KeyEventResult.handled;
      },
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: Color(0xFF16181B),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0x722A2C2E)),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 64,
            vertical: 48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListenableBuilder(
                listenable: _isButtonPressed,
                builder: (context, _) {
                  return Title(isHighlighted: isButtonPressed);
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  ListenableBuilder(
                    listenable: _isShiftPressed,
                    builder: (context, _) {
                      return RainbowButton(
                        icon: 'assets/shift.svg',
                        style: RainbowButtonStyle.blue,
                        isWide: true,
                        isPressed: isShiftPressed,
                      );
                    },
                  ),
                  ListenableBuilder(
                    listenable: _isOptionPressed,
                    builder: (context, _) {
                      return RainbowButton(
                        icon: 'assets/option.svg',
                        style: RainbowButtonStyle.peach,
                        isWide: false,
                        isPressed: isOptionPressed,
                      );
                    },
                  ),
                  ListenableBuilder(
                    listenable: _isRPressed,
                    builder: (context, _) {
                      return RainbowButton(
                        icon: 'assets/r.svg',
                        style: RainbowButtonStyle.orange,
                        isWide: false,
                        isPressed: isRPressed,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
