import 'package:flutter/material.dart';
import 'package:magic_ball/widgets/bottom_light_widget.dart';

class SizeAnimatedLight extends StatefulWidget {
  final bool isError;
  const SizeAnimatedLight({super.key, this.isError = false});

  @override
  State<SizeAnimatedLight> createState() => _SizeAnimatedLightState();
}

class _SizeAnimatedLightState extends State<SizeAnimatedLight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> animation;
  bool animates = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    animation = Tween<double>(
      begin: 1.08,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: BottomLightWidget(error: widget.isError),
    );
  }
}