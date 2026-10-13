# StockApp - แอป iOS สำหรับ stock99.xo.je (IPA)

โปรเจกต์นี้เป็นแอป iOS Native (Swift + SwiftUI + WKWebView) ที่แปลงเว็บไซต์ `http://stock99.xo.je/projects.html?i=1` ให้กลายเป็นแอป iOS เต็มรูปแบบ พร้อมสร้างไฟล์ `.ipa`

---

## ✨ ฟีเจอร์ของตัวแอป
- **รองรับ HTTP (App Transport Security):** อนุญาตให้โหลดหน้าเว็บ `http://` ได้โดยไม่โดน iOS บล็อก
- **WKWebView Engine:** โหลดเร็ว ลื่นไหล พร้อม Persistent Cookie / LocalStorage ไม่หลุด Login
- **Pull to Refresh:** ดึงหน้าจอลงเพื่อรีเฟรชข้อมูล
- **Gesture Navigation:** ปัดขอบจอซ้าย-ขวาเพื่อย้อนกลับ / ไปข้างหน้า
- **แถบนำทางด่วนด้านล่าง (Bottom Toolbar):** ปุ่มย้อนกลับ, ปุ่มไปข้างหน้า, ปุ่มหน้าแรก (Home), และปุ่มรีเฟรช
- **Progress Bar สวยงาม:** แสดงแถบโหลดข้อมูลด้านบน
- **รองรับ Alert / Confirm:** แสดง Popup แจ้งเตือนของ JavaScript ในรูปแบบ iOS Native Alert Dialog
- **หน้าจอเตือนเมื่อเน็ตหลุด (Offline Error Handler):** มีปุ่มให้กดลองใหม่อีกครั้ง
- **ไอคอนแอป (App Icon):** มีชุดไอคอนขนาด 1024x1024 สไตล์ 3D Neon Box เรียบร้อย

---

## 🚀 วิธีสร้างไฟล์ .ipa (สำหรับผู้ใช้ Windows - ฟรี 100% ไม่ต้องมี Mac)

เนื่องจากการคอมไพล์โค้ด iOS จำเป็นต้องใช้ macOS + Xcode ทางเราจึงได้ตั้งค่า **GitHub Actions Workflow** ให้เรียบร้อย สามารถให้ Cloud ของ GitHub สร้างไฟล์ `.ipa` ให้ได้ฟรีทันที:

### ขั้นตอนการรับไฟล์ .ipa:
1. ไปที่ [GitHub](https://github.com) แล้วสร้าง **New Repository** ใหม่ (ตั้งชื่ออะไรก็ได้ เช่น `stock-ios-app`)
2. เปิด Terminal ในโฟลเดอร์นี้ แล้วพิมพ์คำสั่งเพื่อส่งโค้ดขึ้น GitHub:
   ```bash
   git remote add origin https://github.com/<USERNAME>/<REPO_NAME>.git
   git push -u origin main
   ```
3. เข้าไปที่หน้า Repository บนเว็บ GitHub แล้วคลิกแท็บ **Actions**
4. จะเห็น Workflow ชื่อ **"Build iOS IPA"** กำลังทำงานโดยอัตโนมัติบน macOS Runner
5. รอประมาณ 1-2 นาที เมื่อสถานะขึ้นติ๊กถูกสีเขียว (Success) ให้คลิกเข้าไปที่ผลการรัน
6. เลื่อนลงมาที่ส่วน **Artifacts** ด้านล่าง จะพบไฟล์ **`StockApp-ipa`** ให้กดดาวน์โหลด
7. แตกไฟล์ ZIP จะได้ไฟล์ **`StockApp.ipa`** พร้อมใช้งานทันที!

---

## 📲 วิธีนำไฟล์ .ipa ไปติดตั้งลงบน iPhone / iPad

คุณสามารถติดตั้งไฟล์ `.ipa` ลงเครื่องได้หลายวิธี:

### 1. ใช้โปรแกรม Sideloadly (แนะนำที่สุดสำหรับ Windows)
- ดาวน์โหลดโปรแกรม [Sideloadly](https://sideloadly.io/) ลงบนคอมพิวเตอร์ Windows
- เสียบสาย iPhone เข้ากับคอม
- เปิดโปรแกรม Sideloadly แล้วลากไฟล์ `StockApp.ipa` ไปวางในโปรแกรม
- กรอก Apple ID ของคุณ (ใช้ Apple ID ฟรีได้)
- กดปุ่ม **Start** รอระบบติดตั้งแอปเข้าสู่ iPhone
- เมื่อติดตั้งเสร็จ ให้ไปที่ iPhone: **การตั้งค่า (Settings) > ทั่วไป (General) > การจัดการ VPN และอุปกรณ์ (VPN & Device Management)** แล้วกด **เชื่อถือ (Trust)** โปรไฟล์ Apple ID ของคุณ

### 2. ใช้ TrollStore (สำหรับเครื่อง iOS 14.0 - 16.6.1 / 17.0 ที่รองรับ)
- ส่งไฟล์ `StockApp.ipa` เข้า iPhone (ผ่าน AirDrop, LINE, Telegram หรือ iCloud Drive)
- กดเปิดไฟล์ด้วย TrollStore เพื่อติดตั้งได้ถาวร ไม่ต้องต่ออายุทุก 7 วัน

### 3. ใช้ AltStore
- ติดตั้ง AltServer บนคอมพิวเตอร์ แล้วซิงค์ไฟล์ `.ipa` เข้า iPhone ผ่าน Wi-Fi หรือสายชาร์จ

---

## 💻 สำหรับผู้ที่มีเครื่อง Mac หรือ Xcode
หากคุณหรือเพื่อนมีเครื่อง Mac สามารถเปิดและรันได้โดยตรง:
1. ดับเบิลคลิกที่ไฟล์ `StockApp.xcodeproj`
2. เลือกอุปกรณ์ iPhone ของคุณ หรือเครื่อง Simulator
3. กดปุ่ม **Run (Cmd + R)** เพื่อทดสอบ หรือกด **Product > Archive** เพื่อ Export IPA

---

## 🌐 ทางเลือกเสริม: Add to Home Screen (ไม่ต้องติดตั้ง IPA)
เนื่องจากเว็บไซต์ของคุณรองรับ PWA อยู่แล้ว คุณสามารถเปิดใช้งานได้ทันทีโดยไม่ต้องลงแอป:
1. เปิด **Safari** บน iPhone แล้วไปที่ `http://stock99.xo.je/projects.html?i=1`
2. กดปุ่ม **แชร์ (ไอคอนสี่เหลี่ยมมีลูกศรชี้ขึ้น)** ที่แถบด้านล่าง
3. เลือก **"เพิ่มไปยังหน้าจอโฮม" (Add to Home Screen)**
4. กด "เพิ่ม" แอปจะไปปรากฏบนหน้าจอหลัก และเปิดได้แบบเต็มหน้าจอ (Standalone Fullscreen) ทันที
