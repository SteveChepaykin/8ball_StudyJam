import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_ball/controllers/sharedpref_controller.dart';
import 'package:magic_ball/widgets/sizeanimatedlight_widget.dart';
import 'package:magic_ball/widgets/updownanimatedball_widget.dart';

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({super.key});

  @override
  State<MagicBallScreen> createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen> {
  final SharedprefController prefcont = Get.find<SharedprefController>();
  bool isError = false;

  void setError(bool value) {
    setState(() {
      isError = value;
    });
  }

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
          Column(
            children: [
              const Spacer(flex: 3),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: UpDowhAnimatedBall(setError: setError),
              ),
              const Spacer(),
              // BottomLightWidget(),
              SizeAnimatedLight(isError: isError),
              const Spacer(),
              const Padding(
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
              const Spacer(
                flex: 2,
              )
            ],
          ),
          Positioned(
            top: 40,
            right: 0,
            child: IconButton(
              onPressed: () {
                prefcont.setVoicing(!prefcont.isVoicing);
              },
              icon: Obx(
                () => Icon(
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
