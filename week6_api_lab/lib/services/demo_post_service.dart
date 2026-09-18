import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> createDemoPost() async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'title': 'ทดสอบส่งข้อมูลจาก Flutter',
      'body': 'นี่คือเนื้อหาที่ส่งด้วย HTTP POST',
      'userId': 1,
    }),
  );
  final result = 'POST Status: ${response.statusCode}\n${response.body}';
  print(result);
  return result;
}

Future<String> updateDemoPost() async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'title': 'แก้ไขข้อมูลโดยนักศึกษา',
      'body': 'ชื่อ: pattarapon รหัสนักศึกษา: 67030172',
      'userId': 1,
    }),
  );
  final result = 'PUT Status: ${response.statusCode}\n${response.body}';
  print(result);
  return result;
}
