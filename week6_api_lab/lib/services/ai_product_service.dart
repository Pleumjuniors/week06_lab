import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_product.dart';

const _productsUrl = 'https://fakestoreapi.com/products';

Future<List<AiProduct>> fetchAiProducts() async {
  try {
    final response = await http.get(Uri.parse(_productsUrl)).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('ไม่สามารถโหลดสินค้าได้ (สถานะ ${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => AiProduct.fromJson(e as Map<String, dynamic>)).toList();
  } on TimeoutException {
    // ป้องกันการรอเซิร์ฟเวอร์โดยไม่สิ้นสุด
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // เกิดเมื่อเชื่อมต่อเครือข่ายไม่ได้
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
  } on FormatException {
    // เกิดเมื่อ response ไม่ใช่ JSON ที่ถูกต้อง
    throw Exception('ข้อมูลสินค้ามีรูปแบบไม่ถูกต้อง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  try {
    final response = await http.get(Uri.parse('$_productsUrl/$id')).timeout(const Duration(seconds: 10));
    if (response.statusCode == 404) throw Exception('ไม่พบสินค้าหมายเลข $id');
    if (response.statusCode != 200) {
      throw Exception('ไม่สามารถโหลดสินค้าได้ (สถานะ ${response.statusCode})');
    }
    return AiProduct.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } on TimeoutException {
    // จำกัดเวลารอเมื่อเซิร์ฟเวอร์ช้า
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // แยกปัญหาเครือข่ายออกจากปัญหา response
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
  } on FormatException {
    // แจ้งข้อความอ่านง่ายเมื่อ JSON เสีย
    throw Exception('ข้อมูลสินค้ามีรูปแบบไม่ถูกต้อง');
  }
}

