import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class Title extends StatefulWidget {
  const Title({
    required this.isHighlighted,
    super.key,
  });

  final bool isHighlighted;

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  late final _opacity = Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: Curves.easeInOut))
      .animate(_controller);

  @override
  void initState() {
    super.initState();
    _controller.value = widget.isHighlighted ? 1 : 0;
  }

  @override
  void didUpdateWidget(Title oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isHighlighted != widget.isHighlighted) {
      if (widget.isHighlighted) {
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
    const loader = AssetBytesLoader('assets/open_rainbow.svg');
    const height = 24.0;

    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const VectorGraphic(
            loader: loader,
            height: height,
            colorFilter: ColorFilter.mode(Color(0xFF717377), BlendMode.srcIn),
          ),
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                stops: [0.24, 0.5, 0.77],
                colors: [
                  Color(0xFFCA8DD0),
                  Color(0xFFF97094),
                  Color(0xFFF69169),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: VectorGraphic(
              loader: loader,
              height: height,
              opacity: _opacity,
            ),
          ),
        ],
      ),
    );
  }
}
