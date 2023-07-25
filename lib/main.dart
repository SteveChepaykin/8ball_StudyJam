import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_ball/controllers/http_controller.dart';
import 'package:magic_ball/controllers/sharedpref_controller.dart';
import 'package:magic_ball/controllers/ttscache_controller.dart';
import 'package:magic_ball/screen/magic_ball_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpController httpcont = HttpController();
  TTSCacheController ttscont = TTSCacheController(size: 4, cont: httpcont);
  SharedprefController prefcont = SharedprefController();
  await prefcont.init();
  Get.put<HttpController>(httpcont);
  Get.put<TTSCacheController>(ttscont);
  Get.put<SharedprefController>(prefcont);
  runApp(const MyApp());
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  /// Constructor for [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MagicBallScreen(),
    );
  }
}
