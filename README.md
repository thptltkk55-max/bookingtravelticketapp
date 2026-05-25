# Booking Travel App

Booking Travel App la ung dung dat tour du lich xay dung bang Flutter va GetX. Project ho tro xem tour, tim kiem dia diem, yeu thich, ban do, dat tour, thanh toan demo/online, lich su booking, chatbot ho tro nguoi dung, dark mode va da ngon ngu.

## Demo

- Video demo: https://drive.google.com/file/d/1Ik4-4BUGXO_aqbEVGsMuI1B1aK1gfr_Q/view?usp=drive_link
- Anh demo: xem trong thu muc `docs/demo/images/`

> Luu y: cac anh screenshot demo gui trong chat can duoc luu vao `docs/demo/images/` neu muon hien truc tiep tren GitHub. Thu muc da duoc tao san de nhom bo anh vao.

## Cong nghe su dung

- Flutter 3.10.5 qua FVM
- Dart 3.0.5
- GetX state management va routing
- Firebase Authentication
- Cloud Firestore
- Firebase Messaging
- Google Maps API
- payOS QR/Banking payment qua Node.js backend local
- Stripe Test Mode cho Visa Card qua Node.js backend local
- Python chatbot server va chatbot training data
- Assets local cho anh/video demo

## Chuc nang chinh

- Dang nhap, dang ky tai khoan
- Dang nhap Google
- Xem danh sach tour va dia diem du lich
- Tim kiem tour
- Xem chi tiet tour, lich trinh, tien ich, vi tri ban do
- Yeu thich tour va dia diem
- Dat tour va luu lich su booking
- Thanh toan QR/Banking bang payOS
- Thanh toan Visa Card bang Stripe Test Mode
- Lich su booking theo trang thai
- Video/discover screen
- Chatbot ho tro hoi ve tour, booking, thanh toan va lich su
- Dark mode
- Da ngon ngu

## Cau truc thu muc quan trong

```text
lib/
  main.dart
  models/
  modules/
  routes/
  shared/
  theme/
assets/
  images/
  icons/
  videos/
  chatbot/
backend/
  server.js
  package.json
  .env.example
chatbot_training/
  chatbot_server.py
  generate_project_chatbot_data.py
docs/
  demo/
    images/
```

## Chay Flutter app

Project dung FVM Flutter 3.10.5.

```powershell
fvm flutter pub get
fvm flutter run
```

Neu chay tren dien thoai Android that va can ket noi backend local:

```powershell
fvm flutter run -d <DEVICE_ID> --dart-define=PAYOS_BACKEND_URL=http://<IP-LAN>:3000 --dart-define=CHATBOT_BACKEND_URL=http://<IP-LAN>:5055
```

Vi du:

```powershell
fvm flutter run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://192.168.1.170:3000 --dart-define=CHATBOT_BACKEND_URL=http://192.168.1.170:5055
```

## Chay backend payOS/Stripe

Backend dung Node.js/Express.

```powershell
cd backend
npm install
npm run dev
```

Health check:

```powershell
Invoke-RestMethod http://localhost:3000/health
```

File `backend/.env` can co cac bien moi truong sau:

```env
PAYOS_CLIENT_ID=your_payos_client_id
PAYOS_API_KEY=your_payos_api_key
PAYOS_CHECKSUM_KEY=your_payos_checksum_key
STRIPE_SECRET_KEY=your_stripe_secret_key
```

Khong commit `backend/.env` len GitHub. Chi commit `backend/.env.example`.

## Chay chatbot server

```powershell
python chatbot_training\generate_project_chatbot_data.py
python chatbot_training\chatbot_server.py --host 0.0.0.0 --port 5055
```

Health check:

```powershell
Invoke-RestMethod http://localhost:5055/health
```

Chatbot chi tra loi trong pham vi project Travel Booking: tour, dat tour, thanh toan, lich su, yeu thich va cac chuc nang app.

## Firebase

Project giu Firebase Authentication, Firestore va Messaging. File Android Firebase config nam tai:

```text
android/app/google-services.json
```

Khong doi package name/applicationId neu khong can thiet.

## Luu y bao mat

- Khong commit `backend/.env`.
- Khong dua payOS secret hoac Stripe secret vao Flutter/Dart.
- Khong commit service account Firebase Admin.
- Neu key demo da tung chia se cong khai, nen rotate key sau khi nop/demo.

## Repo

- GitHub: https://github.com/thptltkk55-max/bookingtravelticketapp.git
