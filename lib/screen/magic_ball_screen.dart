import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_ball/controllers/sharedpref_controller.dart';
import 'package:magic_ball/widgets/ball_widget.dart';
import 'package:magic_ball/widgets/bottom_light_widget.dart';

class MagicBallScreen extends StatelessWidget {
  MagicBallScreen({super.key});

  final SharedprefController prefcont = Get.find<SharedprefController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1b032e), Colors.black],
              ),
            ),
          ),
          const Column(
            children: [
              Spacer(flex: 3),
              UpDowhAnimatedBall(),
              Spacer(),
              // BottomLightWidget(),
              SizeAnimatedLight(),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Нажмите на шар или встряхните устройство.',
                  style: TextStyle(
                    color: Color(
                      0xFF727272,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
          Positioned(
            top: 10,
            right: 0,
            child: IconButton(
              onPressed: () {
                prefcont.setVoicing(!prefcont.isVoicing);
              },
              icon: Obx(() =>
                Icon(
                  prefcont.$isVoicing.value ? Icons.volume_up : Icons.volume_off,
                  color: const Color(0xFF727272),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpDowhAnimatedBall extends StatefulWidget {
  const UpDowhAnimatedBall({super.key});

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
    idleanimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: const Offset(0, 0.04,),
    ).animate(_controller);

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
      position: animates ? animation : idleanimation,
      child: BallWidget(onTap: () {
        setState(() {
          animates = !animates;
        });
      }),
    );
  }
}

class SizeAnimatedLight extends StatefulWidget {
  const SizeAnimatedLight({super.key});

  @override
  State<SizeAnimatedLight> createState() => _SizeAnimatedLightState();
}

class _SizeAnimatedLightState extends State<SizeAnimatedLight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> animation;
  late Animation<double> idleanimation;
  bool animates = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    animation = Tween<double>(
      begin: 1.04,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    idleanimation = Tween<double>(
      begin: 1.04,
      end: 1.04,
    ).animate(_controller);

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
      scale: animates ? animation : idleanimation,
      child: const BottomLightWidget()
    );
  }
}
