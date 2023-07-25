import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefController extends GetxController {
  late bool isVoicing;

  static const String voicingKey = 'isVoicing';

  late final SharedPreferences prefs;

  late RxBool $isVoicing;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isVoicing = getVoicing()!;
    $isVoicing = isVoicing.obs;
  }

  Future<void> setVoicing(bool newValue) {
    isVoicing = newValue;
    $isVoicing.value = newValue;
    $isVoicing.refresh();
    return prefs.setBool(voicingKey, newValue);
  }

  bool? getVoicing() {
    return prefs.containsKey(voicingKey) ? prefs.getBool(voicingKey) : false;
  }
}