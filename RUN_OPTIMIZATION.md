# RUN OPTIMIZATION

Ghi chú chạy nhanh cho project Flutter Travel Booking trên máy Windows hiện tại.

## Môi trường

- Dùng Flutter FVM 3.10.5.
- Dùng JDK 17 portable:
  `C:\Users\pdhhi\.jdks\jdk-17.0.19+10`
- Nếu `fvm` trong PATH bị lỗi, gọi trực tiếp:
  `C:\Users\pdhhi\fvm\versions\3.10.5\bin\flutter.bat`

## Lệnh nhanh

PowerShell:

```powershell
$env:JAVA_HOME="$env:USERPROFILE\.jdks\jdk-17.0.19+10"
$env:Path="$env:JAVA_HOME\bin;$env:LOCALAPPDATA\Pub\Cache\bin;$env:Path"
fvm flutter analyze lib/shared/widgets/stateless/google_map_widget.dart lib/modules/google_map/google_map_screen.dart lib/modules/tour/tour_details_screen.dart
fvm flutter run -d 25e53b9e12057ece --no-resident
```

Nếu sandbox/tool bị kẹt lockfile FVM ngoài workspace, dùng trực tiếp SDK:

```powershell
$env:JAVA_HOME="$env:USERPROFILE\.jdks\jdk-17.0.19+10"
$env:Path="$env:JAVA_HOME\bin;$env:Path"
& "$env:USERPROFILE\fvm\versions\3.10.5\bin\flutter.bat" analyze lib/shared/widgets/stateless/google_map_widget.dart lib/modules/google_map/google_map_screen.dart lib/modules/tour/tour_details_screen.dart
& "$env:USERPROFILE\fvm\versions\3.10.5\bin\flutter.bat" run -d 25e53b9e12057ece --no-resident
```

## Log Google Maps

Chạy ngắn, không chờ quá lâu:

```powershell
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" logcat -c
fvm flutter run -d 25e53b9e12057ece --no-resident
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" logcat -d | findstr /i "Google Maps API authorization denied maperror billing api key mapsdk request_denied"
```

Nếu `flutter run` quá 5 phút hoặc không có log mới, dừng và dùng log hiện có.

## Ghi chú Google Map tile

- Nếu widget GoogleMap hiện logo Google/nút +/- nhưng không có tile, code đã tạo map view thành công.
- Ưu tiên kiểm tra logcat cho lỗi authorization/billing/key trước khi đổi code.
- Preview Location trong tour detail ưu tiên dùng GoogleMap thật với marker tour và gesture kéo/zoom; có fallback mini map nằm dưới để tránh nền trống khi native map chưa render.
- Nút Show Map/Chỉ đường mở Google Maps app/web bằng `url_launcher` để chỉ đường thật; `GoogleMapScreen` chỉ còn là màn phụ/cũ nếu cần kiểm tra sau.

## Quét key/config

- Khi quét API key/secret, bỏ qua thư mục generated/local: `build/`, `.dart_tool/`, `.gradle/`, `.git/`, `node_modules/`, `ios/Pods/`.
- Không in full key ra báo cáo; chỉ mask dạng 8 ký tự đầu + `...` + 6 ký tự cuối.
- Ưu tiên PowerShell/rg scan trong 3 phút, không chạy build chỉ để quét key.

## Backend payOS local

Chạy backend payOS/Stripe local:

```powershell
cd backend
npm install
npm run dev
```

Test health endpoint:

```powershell
Invoke-RestMethod http://localhost:3000/health
```

Stripe test mode dùng cùng backend:

- Dien `STRIPE_SECRET_KEY=sk_test...` trong `backend/.env`.
- Khong dua `sk_test` vao Flutter.
- Test endpoint tao PaymentIntent:

```powershell
Invoke-RestMethod http://localhost:3000/create-stripe-payment-intent -Method Post -ContentType "application/json" -Body '{"amount":2500000,"currency":"vnd","description":"Dat tour","buyerEmail":"test@example.com","idUser":"user_id","idTour":"tour_01"}'
```

Khi chạy Flutter trên điện thoại Android thật, dùng IP LAN của máy tính, không dùng `localhost`.

```powershell
fvm flutter run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://192.168.1.10:3000 --no-resident
```

Mốc timeout:

- `npm install`, health check, analyze: tối đa 3 phút.
- `flutter run`/build: tối đa 5 phút.

## Chatbot training data Python

Tool nằm trong `chatbot_training/`.

```powershell
cd chatbot_training
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python export_firestore_training_data.py --service-account "C:\path\to\firebase-service-account.json"
```

Output sinh ra ở `chatbot_training/output/` và đang được `.gitignore`.

Sinh data demo cho Flutter không cần service account:

```powershell
python chatbot_training\generate_project_chatbot_data.py
```

Chạy chatbot server local:

```powershell
cd chatbot_training
.\run_chatbot_server.ps1
```

Test server:

```powershell
Invoke-RestMethod http://localhost:5055/health
Invoke-RestMethod http://localhost:5055/chat -Method Post -ContentType "application/json" -Body '{"message":"Tour Da Lat gia bao nhieu?"}'
```

Chạy Flutter trỏ server chatbot:

```powershell
fvm flutter run -d 25e53b9e12057ece --dart-define=CHATBOT_BACKEND_URL=http://<IP-LAN>:5055 --no-resident
```

Mốc timeout:

- `python -m py_compile chatbot_training\export_firestore_training_data.py`: tối đa 3 phút.
- Export Firestore tùy mạng/dữ liệu, nếu quá 3 phút thì dừng và kiểm tra service account/network trước.
- Chatbot server là process giữ terminal, nên chạy trong terminal riêng.
