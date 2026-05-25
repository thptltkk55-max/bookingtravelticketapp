# Lich su thuc hien: Chuyen media demo sang assets

## 2026-05-22

### Da thuc hien

- Tao ke hoach tai `plan.md`.
- Tao helper anh dung chung:
  - `lib/shared/utils/app_image.dart`
- Cap nhat `pubspec.yaml`:
  - Them `assets/videos/`.
  - Sua font path ve `assets/fonts/montserrat/`.
- Tao thu muc:
  - `assets/videos/`
- Cap nhat `lib/shared/constants/assets_helper.dart`:
  - `des2 = assets/images/x2/des2.png`
  - `des9 = assets/images/x2/des9.png`

### Cac man hinh/widget da chuyen sang AppImage

- `lib/modules/booking/booking_option/booking_payment.dart`
- `lib/modules/detail_place/detail_place_screen.dart`
- `lib/modules/history_tour/history_tour_screen.dart`
- `lib/modules/history_tour/tour_history_detail/comment_screen.dart`
- `lib/modules/history_tour/tour_history_detail/comment_see_screen.dart`
- `lib/modules/home/widgets/carousel_slide.dart`
- `lib/modules/home/widgets/home_header.dart`
- `lib/modules/home/widgets/special_offer_card.dart`
- `lib/modules/pay/pay_screen.dart`
- `lib/modules/profile/edit_profile.dart`
- `lib/modules/profile/image_full_screen.dart`
- `lib/modules/profile/image_full_screen_all.dart`
- `lib/modules/profile/profile_screen.dart`
- `lib/modules/rate/rate.dart`
- `lib/modules/room/room_screen.dart`
- `lib/modules/search/search_screen.dart`
- `lib/modules/search/search_tour.dart`
- `lib/modules/search/tab_search.dart`
- `lib/modules/tour/tour_details_screen.dart`
- `lib/modules/tour/tour_item_widget.dart`
- `lib/modules/video_screen/views/screens/comment_screen.dart`
- `lib/modules/video_screen/views/screens/search_screen.dart`
- `lib/modules/video_screen/views/screens/video_screen.dart`
- `lib/shared/widgets/stateful/DestinationItem.dart`
- `lib/shared/widgets/stateful/item_favourite.dart`
- `lib/shared/widgets/stateful/item_favourite_tour.dart`
- `lib/shared/widgets/stateful/profile_widget.dart`
- `lib/shared/widgets/tour_sight_seeing_widget.dart`

### Controller/media logic da cap nhat

- `lib/modules/video_screen/views/widgets/video_player_iten.dart`
  - Ho tro `VideoPlayerController.asset` cho `assets/`.
  - Van ho tro `VideoPlayerController.network` cho URL online.
  - Khong crash khi video rong/loi init.
- `lib/modules/profile/profile_controller.dart`
  - Khong upload avatar len Firebase Storage.
  - Hien snackbar thong bao upload file dang tam tat.
  - Giu avatar cu hoac default asset.
- `lib/modules/video_screen/views/controllers/upload_video_controller.dart`
  - Khong upload video/thumbnail len Firebase Storage.
  - Tao document video demo voi:
    - `videoUrl = assets/videos/travel_1.mp4`
    - `thumbnail = assets/images/x2/des1.jpg`
- `lib/modules/search/search_controller.dart`
  - `getImageStorage` chi tra ve path hop le `assets/http/https`, khong goi Storage.
- `lib/modules/tour/tour_controller.dart`
  - `getImageStorage` chi tra ve path hop le `assets/http/https`, khong goi Storage.

### Kiem tra da chay

- `fvm flutter pub get`
  - Ket qua: thanh cong.
- `fvm flutter build apk --debug`
  - Ket qua: thanh cong.
  - APK: `build/app/outputs/flutter-apk/app-debug.apk`

### Kiem tra scan

- Scan trong `lib/modules` va `lib/shared/widgets`:
  - Khong con direct `CachedNetworkImage`.
  - Khong con direct `CachedNetworkImageProvider`.
  - Khong con direct `Image.network`.
  - Khong con direct `NetworkImage`.
- Scan trong `lib`:
  - Khong con direct `FirebaseStorage`.
  - Khong con direct `putFile`.
  - Khong con direct `getDownloadURL`.
  - Khong con direct `ref().child`.

### Viec chua hoan tat / luu y

- `fvm flutter analyze` toan project bi timeout tren may hien tai, chua co output hoan tat.
- `fvm dart format` bi timeout tren may hien tai, chua format duoc bang command.
- Neu muon phat video asset demo that, can them file:
  - `assets/videos/travel_1.mp4`
- Hien tai neu video asset chua ton tai, app se khong crash nhung hien thong bao khong tai duoc video.

### Nguyen tac da giu

- Khong doi ten collection.
- Khong doi cau truc model field.
- Khong xoa Firebase Auth.
- Khong xoa Firestore.
- Khong xoa Firebase Messaging.
- Khong xoa Stripe.
- Khong xoa GetX routes.
- Khong doi package name/applicationId.
- Khong tao project Flutter moi.

## 2026-05-22 - Tool seed Firestore demo

### Da thuc hien

- Tao ke hoach rieng tai `firestore_seed_plan.md`.
- Tao tool seed/upsert Firestore:
  - `tools/firestore_seed_data.js`
  - `tools/import_firestore_seed.js`
- Tao `package.json` de chay script:
  - `npm run seed:firestore:dry`
  - `npm run seed:firestore`
- Cap nhat `.gitignore` de tranh dua service account Firebase len Git:
  - `serviceAccountKey.json`
  - `firebase-service-account.json`
  - `*.service-account.json`
  - `firebase-adminsdk*.json`

### Du lieu demo da bao gom

- `cityModel`: 8 thanh pho Viet Nam.
- `tourModel`: 8 tour co day du field theo `TourModel`.
- `userModel`: 2 user demo co avatar asset va thumbnail.
- `historyModel`: 5 lich su booking voi cac status app dang dung.
- `videos`: 3 video demo dung `assets/videos/travel_1.mp4`.
- `searchTour`: tu khoa tim kiem pho bien.
- `pushNotification`: token demo.
- Subcollection:
  - `userModel/{id}/favourite`
  - `userModel/{id}/favouriteTour`
  - `tourModel/tour_01/comments`
  - `videos/video_01/comments`
  - `videos/video_02/comments`

### Nguyen tac da giu

- Tool chi upsert document bang merge, khong xoa database.
- Khong sua UI/logic app.
- Khong doi collection/model field.
- Khong dung Firebase Storage.
- Du lieu media dung path `assets/...`.
- Du lieu text dung tieng Viet UTF-8.

### Kiem tra da chay

- Lenh:
  - `node tools/import_firestore_seed.js --dry-run`
- Ket qua:
  - Thanh cong.
  - Tong so write du kien: 47.
  - Khong ghi du lieu len Firebase vi dang o che do dry-run.

## 2026-05-23 - Seed Firestore truc tiep tu app Flutter

### Da thuc hien

- Tao plan rieng:
  - `seed_firestore_app_plan.md`
- Kiem tra `pubspec.yaml`:
  - Da co `assets/videos/`.
- Kiem tra thu muc:
  - `assets/videos/` da ton tai.
  - Da co `travel_1.mp4`.
  - Da co `travel_2.mp4`.
- Tao file:
  - `lib/shared/services/seed_firestore.dart`
- Gan seed vao `lib/main.dart`:
  - Import `SeedFirestore`.
  - Goi `await SeedFirestore.seedAll();` ngay sau `await initializeFirebaseSafely();`.

### Du lieu seed trong app

- `cityModel`: 8 document `city_01` den `city_08`.
- `tourModel`: 8 document `tour_01` den `tour_08`.
- `searchTour`: cac keyword demo.
- `videos`: `video_01`, `video_02`.
- `userModel/{uid}`: tao/merge user hien tai neu da dang nhap.

### Nguyen tac da giu

- Khong dung Firebase Storage.
- Khong upload anh/video.
- Anh/video deu la path `assets/...`.
- Dung `SetOptions(merge: true)`.
- Khong doi collection.
- Khong doi field model.
- Khong sua UI/flow app.

### Kiem tra da chay

- `fvm dart format lib/shared/services/seed_firestore.dart lib/main.dart`
  - Thanh cong.
- `fvm flutter pub get`
  - Thanh cong.
- `fvm flutter analyze`
  - Chay xong, co 99 warning/info cu cua project.
  - Khong co loi moi trong `seed_firestore.dart`.
- `fvm flutter analyze lib/shared/services/seed_firestore.dart lib/main.dart`
  - Chay xong.
  - Chi con 4 info `avoid_print` cu trong `main.dart`, khong lien quan seed.
- `fvm flutter build apk --debug`
  - Lan dau fail vi terminal dang dung JDK 8.
  - Chay lai voi JDK 17 bi timeout sau 3 phut, khong co log loi compile moi.

### Viec can lam sau khi seed

- Chay app mot lan de ghi du lieu len Firestore.
- Sau khi thay Firestore da co du lieu, comment dong trong `lib/main.dart`:
  - `// await SeedFirestore.seedAll();`

## 2026-05-23 - Tiep tuc kiem tra Google Maps sau khi thay API key

### Da doc va doi chieu

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da cap nhat `plan.md` voi checklist tiep tuc kiem tra Google Maps.

### Da kiem tra

- `git status --short`:
  - Working tree dang co nhieu thay doi tu cac buoc truoc.
  - Co thay doi o `android/app/src/main/AndroidManifest.xml`.
  - Co thay doi o `lib/modules/google_map/map_key.dart`.
  - `android/app/google-services.json` dang dirty so voi repo baseline, nhung khong sua trong luot tiep tuc nay.
- `android/app/src/main/AndroidManifest.xml`:
  - Meta-data `com.google.android.geo.API_KEY` da co key moi.
- `lib/modules/google_map/map_key.dart`:
  - Hang `GOOGLE_MAPS_API_KEY` da co key moi.
- `android/app/build.gradle`:
  - `applicationId` la `com.example.doan_clean_achitec`.
- `android/app/google-services.json`:
  - `package_name` la `com.example.doan_clean_achitec`.
  - Khong thay Firebase config trong luot tiep tuc nay.

### Lenh da chay

- Kiem tra key moi bang `.Contains(...)`:
  - `AndroidManifest has new key: True`
  - `map_key.dart has new key: True`
- Lay log Google Maps ngan bang `adb logcat -d` va loc cac tu khoa lien quan:
  - `Google Maps API`
  - `authorization denied`
  - `maperror`
  - `billing`
  - `api key`
  - `mapsdk`
  - `request_denied`
  - `developer_error`
  - `authorization failure`

### Ket qua log

- Log hien tai con cac dong:
  - `GoogleApiManager ... ConnectionResult{statusCode=DEVELOPER_ERROR ...}`
  - `Phenotype.API is not available on this device ... DEVELOPER_ERROR`
- Chua bat duoc log ro rang kieu:
  - `API key not authorized`
  - `Maps SDK for Android not enabled`
  - `BillingNotEnabledMapError`
  - `REQUEST_DENIED`

### Trang thai hien tai

- Key Google Maps moi da nam dung trong `AndroidManifest.xml` va `map_key.dart`.
- Chua xac nhan bang mat thu cong rang tile ban do trong man detail tour da hien.
- Neu tile van khong hien, can kiem tra Google Cloud:
  - Bat Maps SDK for Android.
  - Restrict key dung package `com.example.doan_clean_achitec`.
  - Them SHA-1 debug.
  - Kiem tra billing neu Google Cloud yeu cau.

## 2026-05-23 - Sua loi Booking DropdownButton2

### Loi can sua

- Man Booking bi crash do `DropdownButton2` assertion:
  - Value hien tai: `Thanh pho Ho Chi Minh`.
  - Items cua dropdown co 0 hoac nhieu hon 1 item trung value.
- Dropdown city trong `lib/modules/booking/booking_screen.dart` dang dung ten thanh pho lam `value`.
- `BookingController.selectedValue` dang mac dinh la `Thanh pho Ho Chi Minh`, nen khi danh sach city load tu Firestore khong co gia tri nay hoac co gia tri trung, dropdown se crash.

### File da sua

- `lib/modules/booking/booking_screen.dart`

### Cach sua

- Tao danh sach dropdown an toan tu `tourController.items` hoac fallback local.
- Loai bo item rong va duplicate value truoc khi build `DropdownMenuItem`.
- Kiem tra selected value:
  - Neu match dung 1 item thi giu value.
  - Neu khong match hoac duplicate thi truyen `null` cho dropdown de khong crash.
  - Sau frame dau tien reset `bookingController.selectedValue` ve item hop le dau tien.
- Them log tam:
  - `[BOOKING_DROPDOWN] selected value`
  - `[BOOKING_DROPDOWN] item values`
  - `[BOOKING_DROPDOWN] duplicated values`
  - `[BOOKING_DROPDOWN] reset invalid selected value`
  - `[BOOKING_DROPDOWN] changed value`

### Lenh da chay

- `fvm flutter analyze lib/modules/booking lib/models/city lib/models/tour`
  - Bi timeout sau 3 phut, khong co output loi cu the.
- `fvm flutter analyze lib/modules/booking/booking_screen.dart lib/modules/booking/booking_controller.dart`
  - Bi timeout sau 3 phut, khong co output loi cu the.
- `flutter analyze --no-pub lib/modules/booking/booking_screen.dart` bang Flutter FVM truc tiep
  - Bi timeout sau 3 phut, khong co output loi cu the.
- `fvm flutter run -d 25e53b9e12057ece --no-resident`
  - Thanh cong.
  - Build debug thanh cong.
  - Cai app len device thanh cong.
  - Khong co loi compile tu file Booking.

### Ket qua

- App build/install/run duoc sau khi sua.
- Chua test thu cong duoc viec bam vao tab Booking tren dien thoai trong luot nay.
- Con mot overflow cu o splash screen, khong lien quan Booking dropdown.

### Buoc tiep theo

- Mo app tren dien thoai.
- Vao tab Booking.
- Neu console in `[BOOKING_DROPDOWN] reset invalid selected value`, do la co value cu khong hop le va da duoc reset.
- Thu chon `Thanh pho Ho Chi Minh` hoac cac thanh pho khac neu co trong dropdown.
- Di tiep Booking/Payment de xac nhan van tao duoc `historyModel`.

## 2026-05-23 - Tich hop payOS qua backend local

### Da thuc hien

- Doc `RUN_OPTIMIZATION.md`, `plan.md`, `lịch sử.md`.
- Cap nhat `plan.md` voi ke hoach payOS.
- Tham khao docs payOS Node SDK:
  - Dung package `@payos/node`.
  - Tao link bang `createPaymentLink`.
- Tao backend local:
  - `backend/package.json`
  - `backend/package-lock.json`
  - `backend/server.js`
  - `backend/.env`
  - `backend/.env.example`
  - `backend/README.md`
- Them `.gitignore`:
  - `backend/.env`
  - `backend/.env.local`
  - `payos.env`
  - `backend/payos.env`
  - Unignore `backend/.env.example`.
- Tao Flutter service:
  - `lib/shared/services/payos_payment_service.dart`
- Sua payment flow:
  - `lib/modules/booking/booking_option/booking_option_screen.dart`
  - QR/banking goi payOS backend truoc.
  - Neu payOS backend loi thi thong bao va fallback ve booking demo cu.
  - Neu payOS thanh cong thi mo `checkoutUrl` bang `url_launcher`.
- Sua booking history:
  - `lib/modules/booking/booking_controller.dart`
  - Them optional field:
    - `paymentMethod`
    - `paymentStatus`
    - `orderCode`
    - `paymentLinkId`
- Sua Android local HTTP:
  - `android/app/src/main/AndroidManifest.xml`
  - Them `android:usesCleartextTraffic="true"` de dien thoai that goi backend local `http://<LAN-IP>:3000`.
- Cap nhat `RUN_OPTIMIZATION.md` voi lenh chay backend payOS.

### Bao mat

- PAYOS keys that chi nam trong `backend/.env`.
- Flutter khong chua PAYOS secret.
- Khong log full key.
- `backend/.env` da duoc gitignore.
- `backend/.env.example` chi chua placeholder.
- Vi key da tung xuat hien trong chat, sau demo nen rotate key tren dashboard payOS.

### Lenh da chay

- `npm install` trong `backend`
  - Thanh cong.
  - Tao `backend/package-lock.json`.
  - Khong co vulnerability.
- `node server.js`
  - Lan dau loi do import SDK theo named export.
  - Da sua sang default/CommonJS compatible import.
  - Lan sau backend khoi dong duoc.
- `GET http://localhost:3000/health`
  - Thanh cong.
  - `ok: true`
  - `payosConfigured: true`
- `POST http://localhost:3000/create-payos-payment`
  - Thanh cong.
  - `success: true`
  - Co `checkoutUrl`.
  - Co `paymentLinkId`.
- `fvm flutter analyze lib/modules/booking lib/modules/pay lib/shared/services/payos_payment_service.dart`
  - Timeout sau 3 phut, khong co output loi cu the.
- `fvm flutter run -d 25e53b9e12057ece --no-resident`
  - Thanh cong.
  - Build debug thanh cong.
  - Install app len device thanh cong.
  - Khong co loi compile lien quan payOS.

### Luu y hien tai

- Flutter service mac dinh dung:
  - `http://192.168.1.10:3000`
- Khi chay tren dien thoai that can doi thanh IP LAN cua may dang chay backend, hoac chay:
  - `fvm flutter run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://<LAN-IP>:3000 --no-resident`
- Chua lam webhook payOS de tu dong cap nhat `paymentStatus=paid`.
- Hien tai sau khi tao link payOS, app ghi `historyModel` voi:
  - `status: waiting`
  - `paymentMethod: payos`
  - `paymentStatus: pending`
  - `orderCode`
  - `paymentLinkId`

## 2026-05-23 - Test payOS end-to-end qua IP LAN

### Da thuc hien

- Doc `RUN_OPTIMIZATION.md`, `plan.md`, `lịch sử.md`.
- Cap nhat `plan.md` voi checklist test end-to-end payOS.
- Lay IP LAN bang `ipconfig`.
- Kiem tra backend Node.js.
- Test health endpoint qua `localhost`.
- Test health endpoint qua IP LAN.
- Test tao payment link qua IP LAN.
- Thu chay Flutter voi `--dart-define=PAYOS_BACKEND_URL=http://10.10.10.34:3000`.

### Ket qua IP/backend

- IPv4 Wi-Fi hien tai:
  - `10.10.10.34`
- Backend health `localhost`:
  - `ok: true`
  - `payosConfigured: true`
- Backend health qua IP LAN:
  - `GET http://10.10.10.34:3000/health`
  - `ok: true`
  - `payosConfigured: true`
- Backend tao payment qua IP LAN:
  - `POST http://10.10.10.34:3000/create-payos-payment`
  - `success: true`
  - Co `checkoutUrl`.
  - Co `paymentLinkId`.
- Backend dang listen duoc tu IP LAN, nen `server.js` listen `0.0.0.0` da dung.

### Ket qua Flutter

- Lenh thu:
  - `fvm flutter run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://10.10.10.34:3000 --no-resident`
- Ket qua:
  - Timeout sau 5 phut, khong co log moi.
- Thu lai bang Flutter SDK FVM truc tiep:
  - `C:\Users\pdhhi\fvm\versions\3.10.5\bin\flutter.bat run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://10.10.10.34:3000 --no-resident`
- Ket qua:
  - Timeout sau 5 phut, khong co log moi.
- Nguyen nhan kha nang cao:
  - Flutter tool/daemon tren may dang bi treo do co nhieu process Dart/Java dang chay.
  - Chua co log loi compile moi.

### Test thu cong

- Chua test duoc bam Payment tren app trong luot nay vi Flutter run voi dart-define bi timeout.
- Backend van truy cap duoc tu IP LAN va tao payment link thanh cong.
- De test tiep:
  - Dam bao backend dang chay.
  - Dong bot process Flutter/Dart cu neu can.
  - Chay lai Flutter voi dart-define IP LAN.
  - Vao app, book tour, bam Payment.
  - Kiem tra backend co log `[PAYOS] create payment`.
  - Kiem tra app co mo checkoutUrl.
  - Kiem tra `historyModel` co document moi voi `paymentMethod=payos`, `paymentStatus=pending`.

## 2026-05-23 - Kiem tra Flutter goi backend payOS

### Da thuc hien

- Doc `RUN_OPTIMIZATION.md`, `plan.md`, `lịch sử.md`.
- Cap nhat `plan.md` voi checklist kiem tra Flutter goi backend payOS.
- Mo `lib/shared/services/payos_payment_service.dart`.
- Mo `lib/modules/booking/booking_option/booking_option_screen.dart`.
- Xac nhan Flutter service doc backend URL bang:
  - `String.fromEnvironment('PAYOS_BACKEND_URL')`
- Xac nhan button Payment voi `qrcode`/`banking` goi:
  - `_confirmPayOsPayment()`
  - `PayOsPaymentService().createPayment(...)`
  - Neu fail thi fallback `_confirmDemoPayment()`.

### File da sua

- `lib/shared/services/payos_payment_service.dart`
  - Them log `[PAYOS_FLUTTER] backendUrl`.
  - Them log `[PAYOS_FLUTTER] request url`.
  - Them log `[PAYOS_FLUTTER] request body`.
  - Them log `[PAYOS_FLUTTER] response status`.
  - Them log checkoutUrl co/khong, khong log key.
- `lib/modules/booking/booking_option/booking_option_screen.dart`
  - Doi log payOS sang prefix `[PAYOS_FLUTTER]`.
- `plan.md`
- `lịch sử.md`

### Lenh da chay

- `fvm flutter analyze lib/shared/services/payos_payment_service.dart lib/modules/booking/booking_controller.dart lib/modules/booking/booking_option/booking_option_screen.dart`
  - Timeout sau 3 phut, khong co output loi cu the.
- `fvm flutter run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://10.10.10.34:3000 --no-resident`
  - Timeout sau 5 phut, khong co log moi.
- `GET http://10.10.10.34:3000/health`
  - `ok: true`
  - `payosConfigured: true`

### Ket luan hien tai

- Code Flutter da doc duoc `dart-define` ve mat cau truc.
- Button Payment QR/banking da goi payOS service truoc khi fallback demo.
- Backend van song va truy cap duoc qua IP LAN.
- Chua xac nhan duoc log khi bam Payment vi Flutter run bi timeout/treo tool.
- Tren may hien co nhieu process `dart.exe` va `java.exe`, trong do co ca `C:\src\flutter`, co the lam Flutter tool bi ket.

### Buoc tiep theo

- De test thu cong:
  - Dam bao backend Node van chay.
  - Chay app voi dart-define neu Flutter tool het treo.
  - Vao Book Tour -> Payment.
  - Quan sat terminal Flutter cho log `[PAYOS_FLUTTER]`.
  - Quan sat backend console cho log `[PAYOS] create payment`.
  - Neu app mo checkoutUrl va Firestore co `historyModel` pending thi luong OK.

## 2026-05-23 - Test nhanh payOS bang fallback IP LAN

### Da thuc hien

- Doc `RUN_OPTIMIZATION.md`, `plan.md`, `lịch sử.md`.
- Cap nhat `plan.md` voi checklist test nhanh payOS bang fallback IP LAN.
- Sua `lib/shared/services/payos_payment_service.dart`:
  - Doi default fallback URL tu `http://192.168.1.10:3000`
  - Sang `http://10.10.10.34:3000`
  - Van giu `String.fromEnvironment('PAYOS_BACKEND_URL')` de `--dart-define` override duoc.
  - Them comment canh bao day la IP LAN may dev de test local backend, khong nen commit/push neu nhom chua thong nhat.

### Lenh da chay

- `fvm flutter analyze lib/shared/services/payos_payment_service.dart lib/modules/booking/booking_option/booking_option_screen.dart`
  - Timeout sau 3 phut, khong co output loi cu the.
- `fvm flutter run -d 25e53b9e12057ece --no-resident`
  - Thanh cong.
  - Build debug thanh cong.
  - Install app len device thanh cong.
  - App da mo tren dien thoai.

### Trang thai test

- Backend URL mac dinh hien tai trong Flutter:
  - `http://10.10.10.34:3000`
- Dart-define van co the override:
  - `PAYOS_BACKEND_URL`
- Chua test duoc bam Payment bang tay trong luot nay.

### Buoc tiep theo

- Tren dien thoai dang mo app:
  - Book Tour -> Payment.
  - Backend console can hien `[PAYOS] create payment`.
  - Flutter log can hien `[PAYOS_FLUTTER]`.
  - App can mo checkoutUrl.
  - Firestore `historyModel` can co document moi voi `paymentMethod=payos`, `paymentStatus=pending`.
- Truoc khi commit/push:
  - Doi default fallback URL ve placeholder dung chung hoac thong nhat voi team.

## 2026-05-23 - Hoan tat Payment Method / payOS sau khi bi ngat

### Da doc va kiem tra

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da chay `git status --short`.
- Da xem diff:
  - `lib/modules/booking/booking_option/booking_option_screen.dart`
  - `lib/modules/booking/booking_option/booking_payment.dart`

### File da sua

- `plan.md`
- `lib/modules/booking/booking_option/booking_option_screen.dart`
- `lib/modules/booking/booking_option/booking_payment.dart`
- `lịch sử.md`

### Noi dung da sua

- Man Confirm Booking khong con hien:
  - `4242 4242 4242 4242`
  - `DO VAN LAM`
  - `5621 000 246 6118`
  - `BIDV DO VAN LAM`
- Payment method tiep tuc dung value co dinh:
  - `qrcode`
  - `banking`
  - `visacard`
- `qrcode` va `banking` deu goi:
  - `_confirmPayOsPayment()`
  - `PayOsPaymentService().createPayment(...)`
- Neu payOS backend loi, app log fallback va goi `_confirmDemoPayment()`.
- `visacard` khong goi Stripe/OTP/PhoneAuth nua trong man Confirm Booking.
- Khi chon Visa, app hien thong bao:
  - `Thanh toán thẻ đang được cấu hình. Vui lòng chọn QR payOS cho bản demo.`
- Them log:
  - `[PAYMENT_METHOD] selected title`
  - `[PAYMENT_METHOD] selected value`
- Man `booking_payment.dart` cu da bo thong tin tai khoan/ten nguoi khac va thay bang text payOS/demo an toan hon.

### Kiem tra chuoi nhay cam

- Lenh:
  - `rg -n "4242 4242|DO VAN LAM|5621 000|BIDV DO VAN LAM|Scanner with QR|Scan QR code" lib`
- Ket qua:
  - Khong con thong tin the/tai khoan/ten nguoi khac trong `lib`.
  - Chi con label dich tieng Anh generic:
    - `Scan QR code`
    - `Scanner with QR`

### Lenh da chay

- `fvm flutter analyze lib/modules/booking/booking_option/booking_option_screen.dart lib/modules/booking/booking_option/booking_payment.dart lib/shared/services/payos_payment_service.dart`
  - Timeout sau 3 phut.
  - Khong co output loi compile cu the.
- `fvm flutter run -d 25e53b9e12057ece --no-resident`
  - Thanh cong.
  - Build debug thanh cong.
  - APK debug duoc build tai `build\app\outputs\flutter-apk\app-debug.apk`.
  - Install/run len device `SM N960U1` thanh cong.

### Log dang chu y

- Con overflow cu o splash screen:
  - `RenderFlex overflowed by 1.9 pixels on the bottom`
  - Khong lien quan Payment/payOS.
- Khong thay loi compile Payment/payOS trong lan run.

### Viec can test tay tiep

- Dam bao backend dang chay:
  - `cd backend`
  - `npm run dev`
- Vao app:
  - Tour detail -> Book Tour -> Confirm Booking.
- Kiem tra Payment method:
  - Khong con thong tin nguoi khac.
  - QR/payOS va Banking hien text phu hop.
- Bam Payment voi QR/payOS hoac Banking:
  - Backend console can hien `[PAYOS] create payment`.
  - App can mo checkoutUrl.
  - Firestore `historyModel` can co booking `paymentMethod=payos`, `paymentStatus=pending`, `status=waiting`.

## 2026-05-23 - Tich hop Visa Card bang Stripe test mode an toan

### Da doc va lap ke hoach

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da cap nhat `plan.md` voi checklist Stripe test mode.

### Ket qua kiem tra ban dau

- `pubspec.yaml` da co `flutter_stripe: 9.2.2`.
- `lib/main.dart` da co Stripe publishable key `pk_test...`.
- Da quet secret trong app:
  - Phat hien `sk_test...` trong `lib/modules/pay/pay_controller.dart`.
  - Da xoa/vo hieu hoa direct Stripe API call tu Flutter.
  - Quet lai `lib/` khong con `sk_test`/`sk_live`.
- `backend/.env` hien chua co `STRIPE_SECRET_KEY`, nen Stripe backend dang `stripeConfigured=false`.

### File da tao/sua

- `backend/package.json`
- `backend/package-lock.json`
- `backend/server.js`
- `backend/.env.example`
- `backend/README.md`
- `RUN_OPTIMIZATION.md`
- `plan.md`
- `lib/shared/services/stripe_payment_service.dart`
- `lib/modules/booking/booking_option/booking_option_screen.dart`
- `lib/modules/booking/booking_controller.dart`
- `lib/modules/pay/pay_controller.dart`
- `lịch sử.md`

### Backend da sua

- Them dependency backend:
  - `stripe`
- Them health field:
  - `stripeConfigured`
- Them endpoint:
  - `POST /create-stripe-payment-intent`
- Endpoint doc `STRIPE_SECRET_KEY` tu `backend/.env`.
- Endpoint tao Stripe PaymentIntent va tra ve:
  - `clientSecret`
  - `paymentIntentId`
  - `amount`
  - `currency`
- Khong log full secret key; chi log masked key neu co.

### Flutter da sua

- Tao service:
  - `lib/shared/services/stripe_payment_service.dart`
- Visa Card trong Confirm Booking goi:
  - `StripePaymentService().createPaymentIntent(...)`
  - `Stripe.instance.initPaymentSheet(...)`
  - `Stripe.instance.presentPaymentSheet()`
- Neu thanh toan thanh cong, ghi `historyModel` voi:
  - `paymentMethod: stripe`
  - `paymentStatus: paid`
  - `status: waiting`
  - `paymentIntentId`
- `BookingController.bookingTour` duoc them optional field `paymentIntentId`.
- Neu backend Stripe chua cau hinh hoac loi:
  - Hien snackbar: `Thanh toán thẻ chưa được cấu hình. Vui lòng dùng QR payOS.`
- QR/banking payOS khong bi doi.

### Lenh da chay

- `npm install` trong `backend`
  - Thanh cong.
  - Them 3 packages.
  - Khong co vulnerability.
- Test `GET http://localhost:3000/health` bang server start ngan:
  - `ok: true`
  - `payosConfigured: true`
  - `stripeConfigured: false`
- `fvm flutter analyze lib/modules/booking/booking_option/booking_option_screen.dart lib/modules/booking/booking_controller.dart lib/shared/services/stripe_payment_service.dart lib/modules/pay/pay_controller.dart`
  - Timeout sau 3 phut.
  - Khong co output loi compile cu the.
- `fvm flutter run -d 25e53b9e12057ece --no-resident`
  - Thanh cong.
  - Build debug thanh cong.
  - Install/run len device `SM N960U1` thanh cong.

### Viec can lam tiep

- Nguoi dung can lay Stripe test key:
  - `STRIPE_SECRET_KEY=sk_test...`
  - Dien vao `backend/.env`.
- Khong commit `backend/.env`.
- Chay backend:
  - `cd backend`
  - `npm run dev`
- Test Visa Card:
  - Book Tour -> Confirm Booking -> Visa Card -> Payment.
  - PaymentSheet can mo.
  - Dung the test `4242 4242 4242 4242`, ngay tuong lai, CVC `123`.
  - Firestore `historyModel` can co booking `paymentMethod=stripe`, `paymentStatus=paid`, `paymentIntentId`.

## 2026-05-23 - Kiem tra cau hinh Stripe keys

### Da thuc hien

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da cap nhat `plan.md` cho buoc cau hinh/test Stripe keys.

### Kiem tra bao mat

- `backend/.env` ton tai nhung chua co dong:
  - `STRIPE_SECRET_KEY=sk_test...`
- Khong in full secret key ra log.
- `.gitignore` da ignore:
  - `.env*`
  - `backend/.env`
  - `backend/.env.local`
  - van unignore `backend/.env.example`.
- Quet `lib/`:
  - Khong con `sk_test` hoac `sk_live`.
- `lib/main.dart` co Stripe publishable key `pk_test...NULzRX`.
  - Chua thay key moi duoc cung cap trong request, nen chua thay publishable key.

### Kiem tra backend

- `GET http://localhost:3000/health`
  - `ok: true`
  - `payosConfigured: true`
  - `stripeConfigured: false`
- `POST http://localhost:3000/create-stripe-payment-intent`
  - `success: false`
  - `message: Stripe env is missing. Check STRIPE_SECRET_KEY in backend/.env.`

### Kiem tra Flutter

- Lenh:
  - `fvm flutter run -d 25e53b9e12057ece --no-resident`
- Ket qua:
  - Thanh cong.
  - Build debug thanh cong.
  - App sync len device `SM N960U1` thanh cong.

### Ket luan

- Code Visa/Stripe da san sang ve phia app va backend.
- Chua the mo PaymentSheet that vi backend chua co `STRIPE_SECRET_KEY`.
- Can dien secret key that vao `backend/.env`, vi du:
  - `STRIPE_SECRET_KEY=sk_test...`
- Neu Stripe Dashboard co publishable key moi khac key trong `lib/main.dart`, can cung cap `pk_test...` moi de thay trong Flutter.
- Sau khi co key, chay lai:
  - `cd backend`
  - `npm run dev`
  - `Invoke-RestMethod http://localhost:3000/health`
  - Test Visa Card trong app.

## 2026-05-23 - Hoan tat cau hinh Stripe test keys moi

### Da thuc hien

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da cap nhat `plan.md` cho buoc cau hinh key moi.
- Da them Stripe test keys vao `backend/.env`.
- Da cap nhat `backend/.env.example` voi placeholder:
  - `STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key`
  - `STRIPE_SECRET_KEY=your_stripe_secret_key`
- Da thay publishable key trong `lib/main.dart`.
- Khong dung `rk_test`.
- Khong sua Google Maps.
- Khong sua payOS key/logic.

### Bao mat

- `backend/.env` da co:
  - `STRIPE_PUBLISHABLE_KEY=pk_test...DPunUz`
  - `STRIPE_SECRET_KEY=sk_test...c4GQ6`
- Khong in full key ra log.
- `.gitignore` da ignore:
  - `.env*`
  - `backend/.env`
  - `backend/.env.local`
  - va unignore `backend/.env.example`.
- Quet `lib/`:
  - Khong co `sk_test`.
  - Khong co `sk_live`.
  - Khong co `rk_test`.
  - Khong co `rk_live`.
- `lib/main.dart` dang dung publishable key moi:
  - `pk_test...DPunUz`

### Backend

- Da dung cac process Node cu va restart backend sach.
- Backend moi dang chay voi PID:
  - `6112`
- `GET http://localhost:3000/health`
  - `ok: true`
  - `payosConfigured: true`
  - `stripeConfigured: true`
- `POST http://localhost:3000/create-stripe-payment-intent`
  - `success: true`
  - `clientSecretPresent: true`
  - `paymentIntentId: pi_3Ta...AsVY`
  - `amount: 1800000`
  - `currency: vnd`

### Flutter

- Lenh analyze:
  - `fvm flutter analyze lib/main.dart lib/shared/services/stripe_payment_service.dart lib/modules/booking/booking_option/booking_option_screen.dart lib/modules/booking/booking_controller.dart`
  - Timeout sau 3 phut, khong co log loi moi.
- Lenh run:
  - `fvm flutter run -d 25e53b9e12057ece --no-resident`
  - Timeout sau 5 phut, khong co log moi.
- Do backend da san sang, can test thu cong tren app dang co hoac chay lai khi Flutter tool het ket.

### Buoc tiep theo

- Dam bao backend PID `6112` van chay, hoac chay lai:
  - `cd backend`
  - `npm run dev`
- Mo app tren dien thoai.
- Chon tour -> Book Tour -> Confirm Booking -> Visa Card -> Payment.
- PaymentSheet phai mo.
- Dung the test:
  - `4242 4242 4242 4242`
  - Expiry `12/34`
  - CVC `123`
  - ZIP `10000` neu co.
- Sau khi thanh toan, kiem tra Firestore `historyModel`:
  - `paymentMethod = stripe`
  - `paymentStatus = paid`
  - `status = waiting`
  - `paymentIntentId` co gia tri.

## 2026-05-23 - Sua loi trang History

### Da thuc hien

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da cap nhat `plan.md` cho loi History.
- Kiem tra cac file:
  - `lib/models/history/history_model.dart`
  - `lib/modules/history_tour/history_tour_controller.dart`
  - `lib/modules/history_tour/history_tour_screen.dart`

### Nguyen nhan nghi ngo

- Sau khi payment/booking tao document moi trong `historyModel`, neu document co `idTour` rong/khong ton tai trong `tourModel` thi controller cu lam lech danh sach:
  - Danh sach history co item.
  - Danh sach tour bi rong hoac thieu item.
  - UI dung `itemCount` theo history nhung index theo tour nen co the crash.
- `HistoryModel.fromJson` cu goi `.toDouble()` truc tiep, co the loi neu Firestore luu so dang `String` hoac kieu khac.

### File da sua

- `lib/models/history/history_model.dart`
  - Doc `document.data()` an toan hon.
  - Parse `adult`, `children`, `totalPrice` bang helper chap nhan `num`/`String`.
  - Giu lai cac field payment bo sung khi doc/ghi:
    - `paymentMethod`
    - `paymentStatus`
    - `orderCode`
    - `paymentLinkId`
    - `paymentIntentId`
- `lib/modules/history_tour/history_tour_controller.dart`
  - Clear ca list history-date khi reload.
  - Them helper tao cap history-tour dong bo.
  - Bo qua history record co `idTour` rong hoac tour document khong ton tai.
  - Khong xoa toan bo list tour chi vi mot document history bi loi.
  - Log canh bao dang `[HISTORY][WARN]` khi bo qua record loi.
- `lib/modules/history_tour/history_tour_screen.dart`
  - UI doc list truc tiep theo status tab.
  - `itemCount` lay min cua so tour va so history de tranh RangeError.
  - Kiem tra anh tour rong truoc khi lay `.first`.
  - Sua import `rive.dart` khong dung `hide Image` nua.

### Lenh da chay

- `fvm dart format ...`
  - Timeout sau 3 phut do wrapper bi ket.
- `dart.exe format` truc tiep tu FVM SDK:
  - Thanh cong.
  - Format 3 file History.
- `fvm flutter analyze ...`
  - Timeout sau 3 phut do Flutter tool bi ket.
- `dart.exe analyze lib/models/history/history_model.dart lib/modules/history_tour/history_tour_controller.dart lib/modules/history_tour/history_tour_screen.dart`
  - Chay xong.
  - Khong con warning/error moi.
  - Con 10 info style cu trong `history_tour_screen.dart` ve `SizedBox`/`const`.
- `flutter.bat run -d 25e53b9e12057ece --no-resident` bang SDK FVM truc tiep:
  - Thanh cong.
  - Build debug thanh cong.
  - Install/run len device `SM N960U1` thanh cong.

### Ket qua

- App da build/install/run duoc sau khi sua History.
- Trang History se khong crash vi list history-tour bi lech; record history loi se bi bo qua va log canh bao.
- Chua test tay thao tac mo tab History tren dien thoai trong luot nay.

### Buoc tiep theo

- Mo app tren dien thoai.
- Vao tab History.
- Neu console co log `[HISTORY][WARN]`, kiem tra document `historyModel` do co `idTour` khong ton tai trong `tourModel`.

## 2026-05-23 - Tao tool Python data chatbot va chatbox toan app

### Da thuc hien

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.
- Da cap nhat `plan.md` voi muc Chatbox va tool Python.
- Da cap nhat `RUN_OPTIMIZATION.md` voi cach chay tool Python.

### File/folder da tao

- `chatbot_training/`
  - `README.md`
  - `requirements.txt`
  - `export_firestore_training_data.py`
- `lib/shared/widgets/chatbot/chatbot_overlay.dart`

### File da sua

- `.gitignore`
  - Ignore `chatbot_training/output/`.
  - Ignore service account/local env trong `chatbot_training/`.
- `lib/main.dart`
  - Import `ChatbotOverlay`.
  - Wrap `GetMaterialApp.builder` de chatbox hien tren toan bo app.
  - Van giu `EasyLoading.init()`.
- `plan.md`
- `RUN_OPTIMIZATION.md`
- `lịch sử.md`

### Tool Python

- Doc Firestore bang Firebase Admin SDK Python.
- Collection mac dinh:
  - `cityModel`
  - `tourModel`
  - `searchTour`
  - `videos`
- Xuat:
  - `chatbot_training/output/chatbot_knowledge_base.json`
  - `chatbot_training/output/chatbot_training.jsonl`
- Du lieu hoi/dap sinh ra bang tieng Viet, phu hop app dat tour.
- Khong dua service account/key vao code.

### Chatbox Flutter

- Chatbox hien o toan bo man hinh qua overlay trong `main.dart`.
- Co nut noi goc duoi phai.
- Bam nut se mo khung chat.
- Chat hien tai la rule-based demo local, tra loi cac nhom cau hoi:
  - tour/du lich
  - dat tour/booking
  - thanh toan payOS/Stripe/Visa
  - lich su booking
  - yeu thich
  - Firebase/Firestore
- Khong goi API ngoai, khong can key.
- Khong them dependency Flutter.

### Lenh da chay

- `python -m py_compile chatbot_training\export_firestore_training_data.py`
  - Thanh cong.
- `dart.exe format lib/main.dart lib/shared/widgets/chatbot/chatbot_overlay.dart`
  - Thanh cong.
- `dart.exe analyze lib/main.dart lib/shared/widgets/chatbot/chatbot_overlay.dart`
  - Chay xong.
  - Chi con 4 info cu `avoid_print` trong `main.dart`.
- `flutter.bat run -d 25e53b9e12057ece --no-resident`
  - Thanh cong.
  - Build debug thanh cong.
  - Install/run len device `SM N960U1` thanh cong.

### Buoc tiep theo

- Neu muon tao data that:
  - Tao Firebase service account JSON tren Firebase Console.
  - Chay tool trong `chatbot_training/` theo `README.md`.
- Neu muon chatbot tra loi bang data that trong app:
  - Nap output JSON vao backend/RAG hoac tao service doc file knowledge base.
  - Hien tai chatbox moi la UI + rule demo local.

## 2026-05-23 - Chay chatbot server Python va gioi han pham vi hoi

### Da thuc hien

- Da cap nhat `plan.md` cho buoc chatbot server.
- Tao data generator:
  - `chatbot_training/generate_project_chatbot_data.py`
- Tao chatbot server:
  - `chatbot_training/chatbot_server.py`
- Tao script chay server:
  - `chatbot_training/run_chatbot_server.ps1`
- Tao Flutter service:
  - `lib/shared/services/chatbot_service.dart`
- Sua chatbox:
  - `lib/shared/widgets/chatbot/chatbot_overlay.dart`
- Sua `pubspec.yaml`:
  - Them direct dependency `http: 1.1.0`.
  - Them asset folder `assets/chatbot/`.
- Sinh data cho Flutter:
  - `assets/chatbot/chatbot_knowledge_base.json`
- Cap nhat docs:
  - `chatbot_training/README.md`
  - `RUN_OPTIMIZATION.md`

### Data da sinh

- Lenh:
  - `python chatbot_training\generate_project_chatbot_data.py`
- Ket qua:
  - `chatbot_training/output/chatbot_knowledge_base.json`
  - `chatbot_training/output/chatbot_training.jsonl`
  - `assets/chatbot/chatbot_knowledge_base.json`
  - Tong training rows: 30.

### Pham vi chatbot

- Chi tra loi ve:
  - tour/diem den/gia tour
  - dat tour/booking
  - thanh toan payOS/QR/Banking/Visa/Stripe
  - lich su booking
  - yeu thich
  - Firebase/Firestore project
- Cau hoi ngoai pham vi se tra loi:
  - `Mình chỉ hỗ trợ các câu hỏi về app Travel Booking...`

### Server da test

- Chay server trong session test:
  - `python chatbot_training\chatbot_server.py --port 5055`
- `GET http://localhost:5055/health`
  - `ok: true`
  - `service: travel-chatbot`
- `POST http://localhost:5055/chat`
  - Input: `Tour Da Lat gia bao nhieu?`
  - Output: `Tour Đà Lạt 3 ngày 2 đêm có giá khoảng 2.500.000 VND...`
  - Source: `tour/tour_01`
- Test ngoai pham vi:
  - Input: `Bong da hom nay the nao?`
  - `inScope: false`

### Flutter da kiem tra

- `fvm flutter pub get`
  - Thanh cong.
- `dart.exe analyze lib/shared/services/chatbot_service.dart lib/shared/widgets/chatbot/chatbot_overlay.dart lib/main.dart`
  - Chay xong.
  - Chi con 4 info cu `avoid_print` trong `main.dart`.
- `flutter run ... --dart-define=CHATBOT_BACKEND_URL=http://192.168.1.170:5055`
  - Timeout sau 5 phut, khong co log moi.
- `flutter build apk --debug --dart-define=CHATBOT_BACKEND_URL=http://192.168.1.170:5055`
  - Timeout sau 5 phut, khong co log moi.

### Cach chay server that

- Mo terminal rieng:
  - `cd chatbot_training`
  - `.\run_chatbot_server.ps1`
- Sau do chay Flutter voi IP LAN:
  - `fvm flutter run -d 25e53b9e12057ece --dart-define=CHATBOT_BACKEND_URL=http://192.168.1.170:5055 --no-resident`
- Neu server khong chay hoac dien thoai khong truy cap duoc, Flutter fallback sang data trong:
  - `assets/chatbot/chatbot_knowledge_base.json`

## 2026-05-23 - Nang cap chatbox keo tha va card tour

### Da thuc hien

- Sua `chatbot_training/generate_project_chatbot_data.py`
  - Them `image` va `description` cho tung tour.
  - Sinh lai `assets/chatbot/chatbot_knowledge_base.json`.
- Sua `chatbot_training/chatbot_server.py`
  - Khi cau hoi match tour, response `/chat` tra them object `tour`.
  - Van giu gioi han pham vi hoi theo chu de project.
- Sua `lib/shared/services/chatbot_service.dart`
  - Parse `tour` tu response server.
  - Fallback local cung tra ve `tour` khi match tour trong asset.
- Sua `lib/shared/widgets/chatbot/chatbot_overlay.dart`
  - Bong chat co the keo tha tren man hinh.
  - Khi cau tra loi co tour, hien card co anh, ten tour, vi tri, thoi luong, gia.
  - Nut `Xem chi tiết tour` tao `TourModel` tu data chatbot va mo `Routes.TOUR_DETAILS`.

### Lenh da chay

- `python chatbot_training\generate_project_chatbot_data.py`
  - Thanh cong.
  - Training rows: 30.
- `python -m py_compile chatbot_training\chatbot_server.py chatbot_training\generate_project_chatbot_data.py`
  - Thanh cong.
- `dart.exe format lib/shared/services/chatbot_service.dart lib/shared/widgets/chatbot/chatbot_overlay.dart`
  - Thanh cong.
- `dart.exe analyze lib/shared/services/chatbot_service.dart lib/shared/widgets/chatbot/chatbot_overlay.dart`
  - `No issues found!`
- Test server `/chat`:
  - Input: `Tour Da Lat gia bao nhieu?`
  - Output co:
    - `source: tour/tour_01`
    - `tourName: Tour Đà Lạt 3 ngày 2 đêm`
    - `tourImage: assets/images/x2/des1.jpg`

### Ket qua

- Chatbox da co kha nang keo tha.
- Cau hoi ve tour co the hien card tour va dieu huong chi tiet.
- Cau hoi ngoai pham vi van bi tu choi theo scope Travel Booking.

## 2026-05-26 - Don file, cap nhat README va chuan bi up GitHub

### Da doc

- Da doc `RUN_OPTIMIZATION.md`.
- Da doc `plan.md`.
- Da doc `lịch sử.md`.

### Da thuc hien

- Cap nhat `plan.md` cho buoc don file va push GitHub.
- Cap nhat `README.md`:
  - Mo ta project Booking Travel App.
  - Them link video demo Google Drive.
  - Liet ke cong nghe: Flutter, Firebase, Firestore, Google Maps, payOS, Stripe test mode, Node.js backend, chatbot Python.
  - Them huong dan chay Flutter, backend va chatbot.
  - Ghi chu khong commit `.env`.
- Tao folder demo:
  - `docs/demo/README.md`
  - `docs/demo/images/.gitkeep`
- Chuyen remote `origin` sang:
  - `https://github.com/thptltkk55-max/bookingtravelticketapp.git`

### File/thư muc da don

- Xoa cache/build/log sinh ra:
  - `build/`
  - `.dart_tool/`
  - `android/.gradle/`
  - `backend/node_modules/`
  - `backend/backend.stderr.log`
  - `backend/backend.stdout.log`
  - `flutter_run.stderr.log`
  - `flutter_run.stdout.log`
  - `chatbot_training/__pycache__/`
  - `chatbot_training/output/`
  - cac file `.DS_Store`
- Khong xoa:
  - `.fvm/`
  - `.fvmrc`
  - `android/app/google-services.json`
  - Gradle wrapper
  - `backend/.env`
  - `backend/.env.example`

### Secret check

- `backend/.env` dang duoc `.gitignore` ignore.
- Khong thay `backend/.env` bi track.
- Khong dua key that vao `README.md`.
- Cac file docs chi chua placeholder bien moi truong.

### Lenh da chay

- `git status --short`
- `git remote -v`
- `git branch --show-current`
- `git clean -ndX`
- `fvm flutter pub get`
  - Thanh cong bang FVM Flutter 3.10.5.
- `fvm flutter analyze`
  - Timeout sau 3 phut, khong co log loi cu the.

### Luu y

- Anh demo gui trong chat khong tu dong nam trong filesystem, nen thu muc `docs/demo/images/` da tao san de bo screenshot vao neu can hien truc tiep tren GitHub.
- Chua chay `flutter run/build` trong buoc don file vi muc tieu chinh la README/cleanup/push va analyze full project da timeout theo moc quy dinh.
