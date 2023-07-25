import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:magic_ball/controllers/http_controller.dart';
import 'package:magic_ball/controllers/sharedpref_controller.dart';
import 'package:magic_ball/controllers/ttscache_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake/shake.dart';

class BallWidget extends StatefulWidget {
  final Function(bool) setError;
  const BallWidget({super.key, required this.setError});

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
  Offset prevoffset = Offset.zero;
  Offset curoffset = Offset.zero;
  final streamsub = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    streamsub.add(gyroscopeEvents.listen((event) {
      setState(() {
        prevoffset = curoffset;
        curoffset = Offset(-event.y, -event.x);
      });
    }));
    shakeDetector = ShakeDetector.waitForStart(
      shakeThresholdGravity: 1.8,
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
    widget.setError(false);
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
          widget.setError(true);
          setState(() {
            errorhappened = true;
            waitsAnswer = false;
          });
        }
      },
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
              parallaxStar(
                Image.asset('assets/small star.png', scale: 5, fit: BoxFit.fitWidth),
                5,
              ),
              parallaxStar(
                Image.asset('assets/star.png', scale: 2.7, fit: BoxFit.fitWidth),
                -5,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (waitsAnswer || currentReading != '') ? Colors.black.withOpacity(0.9) : Colors.transparent,
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: errorhappened ? Colors.red.withOpacity(0.3) : Colors.transparent,
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

  //Виджет для отображения эффекта параллакса
  Widget parallaxStar(Widget child, double modifier) => TweenAnimationBuilder(
        tween: Tween<Offset>(begin: prevoffset, end: curoffset * modifier),
        duration: const Duration(milliseconds: 400),
        builder: (context, offset, __) => Transform(
          transform: Matrix4.identity()
            ..translate(
              offset.dx,
              offset.dy,
            ),
          child: child,
        ),
      );
}
