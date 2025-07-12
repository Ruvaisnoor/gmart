import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const GradientBackground({
    Key? key,
    required this.child,
    this.colors = const [
      Color(0xDD000000), // black87
      Color(0xFFFF1744), // redAccent.shade400
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
