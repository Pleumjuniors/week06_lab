# ข้อมูลสำหรับผู้ส่งงาน

- ชื่อ: pattarapon
- รหัสนักศึกษา: 67030172

## ก่อนรัน

โปรเจกต์ Weather ต้องใช้ OpenWeather API Key ของเจ้าของงานเอง โดยไม่เขียนคีย์ลงในซอร์สโค้ด:

```powershell
cd week6_api_lab
flutter pub get
flutter run -d chrome --dart-define=OPENWEATHER_API_KEY=คีย์ใหม่ของเจ้าของงาน
```

โปรเจกต์ Campus Marketplace:

```powershell
cd campus_marketplace
flutter pub get
flutter run -d chrome
```

ต้องรันและถ่ายภาพ Checkpoint จากเครื่องของเจ้าของงานเอง และปิดบัง API Key ในทุกภาพ

## ก่อนสร้าง Git repository

กำหนดชื่อและอีเมล GitHub ของเจ้าของงานเฉพาะโฟลเดอร์นี้:

```powershell
git init
git config --local user.name "GITHUB_USERNAME"
git config --local user.email "GITHUB_VERIFIED_EMAIL"
git add .
git commit -m "Complete Week 6 API lab"
```

