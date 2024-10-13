import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

enum RainbowButtonStyle {
  blue,
  peach,
  orange;
}

class RainbowButton extends StatefulWidget {
  const RainbowButton({
    required this.icon,
    required this.style,
    required this.isWide,
    required this.isPressed,
    super.key,
  });

  final String icon;

  final RainbowButtonStyle style;

  final bool isWide;

  final bool isPressed;

  @override
  State<RainbowButton> createState() => _RainbowButtonState();
}

class _RainbowButtonState extends State<RainbowButton>
    with SingleTickerProviderStateMixin {
  static const _borderRadius = BorderRadius.all(Radius.circular(18));

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final _opacity = Tween<double>(begin: 0, end: 1)
      .chain(
        CurveTween(
          curve: const Interval(0, 250 / 300, curve: Curves.easeInOut),
        ),
      )
      .animate(_controller);

  late final _offset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 2),
  )
      .chain(
        CurveTween(
          curve: const Interval(100 / 300, 300 / 300, curve: Curves.easeInOut),
        ),
      )
      .animate(_controller);

  Gradient get _maskGradient {
    return switch (widget.style) {
      RainbowButtonStyle.blue => const LinearGradient(
          stops: [0, 0.53, 0.64, 1],
          colors: [
            Color(0xFF04EFFE),
            Color(0xFFB581CF),
            Color(0xFFDC69C4),
            Color(0xFFFE5CB3),
          ],
        ),
      RainbowButtonStyle.peach => const LinearGradient(
          colors: [
            Color(0xFFFF63A2),
            Color(0xFFFE7C73),
            Color(0xFFFF8563),
          ],
        ),
      RainbowButtonStyle.orange => const LinearGradient(
          colors: [
            Color(0xFFFE8D54),
            Color(0xFFFFA32F),
            Color(0xFFFFB115),
          ],
        ),
    };
  }

  Gradient get _backgroundGradient {
    return switch (widget.style) {
      RainbowButtonStyle.blue => const LinearGradient(
          colors: [
            Color(0xFF032E31),
            Color(0xFF211A2A),
            Color(0xFF30151E),
          ],
        ),
      RainbowButtonStyle.peach => const LinearGradient(
          colors: [
            Color(0xFF33161C),
            Color(0xFF331917),
            Color(0xFF331B12),
          ],
        ),
      RainbowButtonStyle.orange => const LinearGradient(
          colors: [
            Color(0xFF331E0E),
            Color(0xFF332009),
            Color(0xFF332305),
          ],
        ),
    };
  }

  @override
  void didUpdateWidget(RainbowButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isPressed != widget.isPressed) {
      if (widget.isPressed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Positioned.fill(
            top: 6,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: Color(0x72242529),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0x722A2C2E)),
                        borderRadius: _borderRadius,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: FadeTransition(
                    opacity: _opacity,
                    child: ClipRRect(
                      borderRadius: _borderRadius,
                      child: ShaderMask(
                        shaderCallback: _maskGradient.createShader,
                        child: const DecoratedBox(
                          decoration: ShapeDecoration(
                            color: Color(0x72242529),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0x72FFFFFF)),
                              borderRadius: _borderRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _offset,
            builder: (context, child) {
              return Transform.translate(
                offset: _offset.value,
                child: child,
              );
            },
            child: Builder(
              builder: (context) {
                final icon = Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isWide ? 32 : 10,
                    vertical: 10,
                  ),
                  child: VectorGraphic(
                    loader: AssetBytesLoader(widget.icon),
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: const ShapeDecoration(
                            color: Color(0xFF242529),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFF2A2C2E)),
                              borderRadius: _borderRadius,
                            ),
                          ),
                          child: icon,
                        ),
                      ),
                      Opacity(
                        opacity: widget.isPressed ? 1 : 0,
                        child: ClipRRect(
                          borderRadius: _borderRadius,
                          child: ShaderMask(
                            shaderCallback: _maskGradient.createShader,
                            blendMode: BlendMode.darken,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                gradient: _backgroundGradient,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: _borderRadius,
                                ),
                              ),
                              child: icon,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
