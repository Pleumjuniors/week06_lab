# คำตอบและรายการส่งงาน Week 6

ให้แทนข้อความในวงเล็บและเพิ่มภาพหน้าจอจริงจากเครื่องก่อนส่ง

## Checkpoint 1.1

Request สำเร็จด้วย Status Code `200 OK` โดย key ที่ใช้คือ:

- ชื่อเมือง: `name`
- อุณหภูมิ: `main.temp`
- อุณหภูมิที่รู้สึกได้: `main.feels_like`
- คำอธิบาย: `weather[0].description`

ภาพที่ต้องถ่าย: Postman ซึ่งเห็น URL (ปิดบัง API key), Status 200 และ Response Body

## Checkpoint 1.2

กรณีทดสอบ: เปลี่ยนชื่อเมืองเป็น `ThisCityDoesNotExist12345`  
คาดการณ์: `404 Not Found`  
ผลจริง: (กรอกหลังทดสอบ)  
คำอธิบาย: เป็นสถานะกลุ่ม `4xx Client Error` เพราะ resource/เมืองที่ client ขอไม่มีอยู่

## Checkpoint 2.1

รัน `dart run lib/test_weather_parse.dart` แล้วค่าที่คาดหวังคือ Bangkok, 32.5, เมฆบางส่วน และ 36.1

## Checkpoint 2.2

- เมืองจริง: `200` แล้วแปลง JSON เป็น `Weather`
- เมืองที่ไม่มี: `404` แล้วแสดง “ไม่พบเมืองที่ค้นหา”

## Checkpoint 2.3

ถ่ายภาพ 3 ภาพ: Bangkok สำเร็จ, เมืองปลอมแสดง error และปิดอินเทอร์เน็ตแล้วแสดงข้อความเชื่อมต่อไม่ได้

## Checkpoint 3.1–3.2

- POST ควรได้ `201 Created`
- PUT ควรได้ `200 OK`

แก้ข้อความชื่อ/รหัสนักศึกษาใน `demo_post_service.dart` ก่อนถ่าย Debug Console

## Checkpoint 4.2

กด “โหลดสินค้า AI Client” แล้วถ่ายผลที่แสดงจำนวนสินค้า พร้อม Debug Console หากต้องการแสดงรายการเต็ม

## Checkpoint 5.1–5.3

กด “ค้นหาด้วย Dio” แล้วถ่ายผลลัพธ์

เปรียบเทียบ:

1. `http` ต้อง `jsonDecode()` เอง ส่วน Dio แปลง response JSON ใน `response.data`
2. `http` มักสร้าง `Uri` เอง ส่วน Dio ส่ง `queryParameters` เป็น Map ได้โดยตรง
3. `http` ดัก `TimeoutException`, `ClientException`, `FormatException` แยกกัน ส่วน Dio รวมปัญหาเครือข่ายไว้ใน `DioException` และจำแนกด้วย `DioExceptionType`

ชนิดที่เพิ่มเอง: `receiveTimeout` สำหรับรอรับข้อมูลนานเกินไป และ `connectionError` สำหรับเชื่อมต่อเครือข่ายไม่ได้

## Checkpoint 7.1 และ 7.3

รัน `dart run lib/test_item_parse.dart` เพื่อถ่ายค่าทั้ง 6 ฟิลด์ จากนั้นรันแอปและถ่าย:

1. หน้า Home ที่โหลดสินค้าจริง
2. โครงสร้างไฟล์ `item_repository.dart` และ `item_repository_api.dart`
3. สินค้าหลังเพิ่มลงตะกร้า
4. หน้า Checkout ที่มีสินค้าจาก API

