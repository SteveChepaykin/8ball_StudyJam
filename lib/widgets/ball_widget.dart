import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:magic_ball/controllers/http_controller.dart';
import 'package:magic_ball/controllers/sharedpref_controller.dart';
import 'package:magic_ball/controllers/ttscache_controller.dart';
import 'package:shake/shake.dart';

class BallWidget extends StatefulWidget {
  final Function onTap;
  const BallWidget({super.key, required this.onTap});

  @override
  State<BallWidget> createState() => _BallWidgetState();
}

class _BallWidgetState extends State<BallWidget> {
  bool waitsAnswer = false;
  String currentReading = '';
  bool errorhappened = false;
  late ShakeDetector shakeDetector;
  HttpController httpcont = Get.find<HttpController>();
  TTSCacheController ttscont = Get.find<TTSCacheController>();
  SharedprefController prefcont = Get.find<SharedprefController>();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    shakeDetector = ShakeDetector.waitForStart(
      onPhoneShake: onGetReading,
    );
    shakeDetector.startListening();
    super.initState();
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    super.dispose();
  }

  Future<void> onGetReading() async {
    widget.onTap();
    setState(() {
      waitsAnswer = true;
      currentReading = '';
    });
    await httpcont.getReading().then(
      (response) async {
        if (response != null) {
          if (prefcont.isVoicing) {
            Uint8List audio = await ttscont.getAudioFromCache(response).whenComplete(() {
              setState(() {
                currentReading = response;
              });
            });
            audioPlayer.play(BytesSource(audio)).whenComplete(() {
              setState(() {
                waitsAnswer = false;
              });
            });
          } else {
            setState(() {
              currentReading = response;
              waitsAnswer = false;
            });
          }
        } else {
          setState(() {
            errorhappened = true;
          });
        }
      },
    ).whenComplete(
      () => Future.delayed(
        const Duration(seconds: 2),
      ).whenComplete(
        () => widget.onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GestureDetector(
        onTap: !waitsAnswer ? onGetReading : () {},
        child: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/ball.png',
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                'assets/small star.png',
                scale: 5,
                fit: BoxFit.contain,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (waitsAnswer || currentReading != '') ? Colors.black.withOpacity(0.8) : Colors.transparent,
                      offset: const Offset(0, 0),
                      blurRadius: 30,
                      spreadRadius: 30,
                    ),
                  ],
                ),
                width: 150,
                height: 150,
                child: Center(
                  child: Text(
                    currentReading,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                      .animate(
                        target: currentReading != '' ? 1 : 0,
                      )
                      .fade(
                        delay: const Duration(
                          milliseconds: 300,
                        ),
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
