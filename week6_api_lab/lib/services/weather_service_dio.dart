import 'package:dio/dio.dart';

import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  const apiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
  );

  final cleanCity = city.trim();

  if (cleanCity.isEmpty) {
    throw Exception('กรุณากรอกชื่อเมือง');
  }

  if (apiKey.isEmpty) {
    throw Exception(
      'ไม่พบ API Key กรุณารันด้วย '
      '--dart-define=OPENWEATHER_API_KEY=...',
    );
  }

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  try {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',

      // Dio รับ Query Parameters เป็น Map ได้โดยตรง
      queryParameters: {
        'q': cleanCity,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'th',
      },
    );

    // Dio แปลง JSON เป็น Map ให้อัตโนมัติ
    // จึงไม่ต้องเรียก jsonDecode()
    final data = response.data as Map<String, dynamic>;

    return Weather.fromJson(data);
  } on DioException catch (error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw Exception(
        'หมดเวลาระหว่างเริ่มเชื่อมต่อ กรุณาลองใหม่อีกครั้ง',
      );
    } else if (error.type ==
        DioExceptionType.receiveTimeout) {
      throw Exception(
        'รอรับข้อมูลจากเซิร์ฟเวอร์นานเกินไป '
        'กรุณาลองใหม่อีกครั้ง',
      );
    } else if (error.type ==
        DioExceptionType.connectionError) {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ '
        'กรุณาตรวจสอบเครือข่าย',
      );
    } else if (error.type ==
        DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 404) {
        throw Exception('ไม่พบเมืองที่ค้นหา');
      }

      if (statusCode == 401) {
        throw Exception(
          'API Key ไม่ถูกต้องหรือยังไม่พร้อมใช้งาน',
        );
      }

      throw Exception(
        'เซิร์ฟเวอร์ตอบกลับผิดพลาด '
        '(สถานะ $statusCode)',
      );
    }

    throw Exception(
      'เกิดข้อผิดพลาดระหว่างโหลดข้อมูลสภาพอากาศ',
    );
  } on FormatException {
    throw Exception(
      'ข้อมูลสภาพอากาศจากเซิร์ฟเวอร์มีรูปแบบไม่ถูกต้อง',
    );
  }
}