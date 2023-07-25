import 'package:flutter/material.dart';
import 'package:magic_ball/widgets/ball_widget.dart';

class UpDowhAnimatedBall extends StatefulWidget {
  final Function(bool) setError;
  const UpDowhAnimatedBall({super.key, required this.setError});

  @override
  State<UpDowhAnimatedBall> createState() => _UpDowhAnimatedBallState();
}

class _UpDowhAnimatedBallState extends State<UpDowhAnimatedBall> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> animation;
  late Animation<Offset> idleanimation;
  bool animates = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    animation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: const Offset(0, -0.04),
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
    return SlideTransition(
      position: animation,
      child: BallWidget(setError: widget.setError),
    );
  }
}