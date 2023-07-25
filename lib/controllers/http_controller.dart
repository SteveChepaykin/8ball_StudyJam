import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

const _ballbase = 'https://eightballapi.com/api';
const _elevenlabsbase = 'https://api.elevenlabs.io/v1';

class HttpController extends GetxController {
  final Dio dio = Dio();

  HttpController() {
    if (dio.httpClientAdapter is IOHttpClientAdapter) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        HttpClient client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  Future<String?> getReading() async {
    try {
      var res = await dio.getUri(Uri.parse('$_ballbase/'));
      var decresponse = res.data!;
      return decresponse['reading'];
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List> generateSpeechFromPhrase(String message) async {
    var response = await dio.postUri<List<int>>(
      Uri.parse('$_elevenlabsbase/text-to-speech/EXAVITQu4vr4xnSDxMaL'),
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'xi-api-key': '366b3fb08f68d56681d3ec1ffc953b0d',
          'content-type': 'application/json',
          'accept': 'audio/mpeg',
        },
      ),
      data: json.encode(
        {
          "text": message,
          "voice_settings": {
            "stability": 0,
            "similarity_boost": 0,
          },
        },
      ),
    );
    print(response.data);
    Uint8List audioresponse = Uint8List.fromList(response.data!);
    return audioresponse;
  }
}
