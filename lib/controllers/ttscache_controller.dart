import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:magic_ball/controllers/http_controller.dart';


class TTSCacheController extends GetxController {
  late final int _ssize;
  late final HttpController _cont;
  final Map<String, Uint8List> _audios = {};
  final Map<String, int> _dates = {};
  
  TTSCacheController({required int size, required HttpController cont}) {
    _ssize = size;
    _cont = cont;
  }

  Future<Uint8List> getAudioFromCache(String responseText) async {
    if(_audios.keys.contains(responseText)) {
      _dates[responseText] = DateTime.now().millisecondsSinceEpoch;
      return _audios[responseText]!;
    }
    var audio = await _cont.generateSpeechFromPhrase(responseText);
    if (_audios.length == _ssize) {
      _removeFromCache();
    }
    _audios[responseText] = audio;
    _dates[responseText] = DateTime.now().millisecondsSinceEpoch;
    return audio; 
  }

  void _removeFromCache() {
    String minId = '';
    int minmilliseconds = _dates.values.reduce((value, element) => min(value, element));
    for(var i in _dates.keys) {
      if(_dates[i] == minmilliseconds) {
        minId = i;
        break;
      }
    }
    _dates.remove(minId);
    _audios.remove(minId);
  }
}