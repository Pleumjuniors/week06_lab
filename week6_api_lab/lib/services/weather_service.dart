import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService {
  static const _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  static const _apiKey =
      String.fromEnvironment('OPENWEATHER_API_KEY');

  Future<Weather> fetchWeather(String city) async {
    final cleanCity = city.trim();

    if (cleanCity.isEmpty) {
      throw Exception('กรุณากรอกชื่อเมือง');
    }

    if (_apiKey.isEmpty) {
      throw Exception(
        'ไม่พบ API Key กรุณารันด้วย '
        '--dart-define=OPENWEATHER_API_KEY=...',
      );
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': cleanCity,
        'appid': _apiKey,
        'units': 'metric',
        'lang': 'th',
      },
    );

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      // แสดงผลใน Debug Console สำหรับ Checkpoint 2.2
      debugPrint('เมืองที่ค้นหา: $cleanCity');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('ผลลัพธ์: เรียกข้อมูลสำเร็จ');

        final json = jsonDecode(
          utf8.decode(response.bodyBytes),
        ) as Map<String, dynamic>;

        return Weather.fromJson(json);
      }

      if (response.statusCode == 404) {
        debugPrint('ผลลัพธ์: ไม่พบเมืองที่ค้นหา');
        throw Exception('ไม่พบเมืองที่ค้นหา');
      }

      if (response.statusCode == 401) {
        debugPrint('ผลลัพธ์: API Key ไม่ถูกต้อง');
        throw Exception(
          'API Key ไม่ถูกต้องหรือยังไม่พร้อมใช้งาน',
        );
      }

      debugPrint(
        'ผลลัพธ์: เกิดข้อผิดพลาด ${response.statusCode}',
      );

      throw Exception(
        'ไม่สามารถโหลดข้อมูลได้ '
        '(สถานะ ${response.statusCode})',
      );
    } on TimeoutException {
      throw Exception(
        'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง',
      );
    } on http.ClientException {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ '
        'กรุณาตรวจสอบการเชื่อมต่อ',
      );
    } on FormatException {
      throw Exception(
        'ข้อมูลจากเซิร์ฟเวอร์มีรูปแบบไม่ถูกต้อง',
      );
    }
  }
}