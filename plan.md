# Plan: Chuyen media demo sang assets

## Muc tieu

Chuyen phan hien thi anh/video demo cua app Flutter Booking Travel GetX sang ho tro doc truc tiep tu `assets/`, trong khi van giu nguyen Firebase Authentication, Firestore Database, Firebase Messaging, Stripe, GetX routes va logic collection.

App van doc/ghi Firestore cho cac collection:

- `cityModel`
- `tourModel`
- `userModel`
- `historyModel`
- `videos`
- `searchTour`
- `pushNotification`

App van giu cac subcollection:

- `userModel/{userDocumentId}/favourite`
- `userModel/{userDocumentId}/favouriteTour`
- `tourModel/{tourDocumentId}/comments`
- `videos/{videoDocumentId}/comments`

## Nguyen tac

- Khong tao project Flutter moi.
- Khong doi package name/applicationId.
- Khong xoa Firebase Auth, Firestore, Messaging, Stripe.
- Khong doi ten collection hoac model field.
- Khong refactor UI/flow lon.
- Chi thay doi cach render/upload media demo.
- Van ho tro URL `http://` va `https://` neu Firestore con luu link online.
- Neu media null/rong/sai dinh dang thi dung fallback asset.

## Du lieu Firestore muc tieu

Anh/video trong Firestore co the luu path assets:

- `cityModel.imageCity = assets/images/x2/city_1.jpg`
- `cityModel.listArt = [assets/images/x2/city_1.jpg, assets/images/x2/city_2.jpg]`
- `tourModel.images = [assets/images/x2/des1.jpg, assets/images/x2/des2.png]`
- `tourModel.imgqr = assets/images/x2/des1.jpg`
- `videos.videoUrl = assets/videos/travel_1.mp4`
- `videos.thumbnail = assets/images/x2/des1.jpg`
- `videos.profilePhoto = assets/images/x2/img_user_profile_non.png`
- `userModel.imgAvatar = assets/images/x2/img_user_profile_non.png`

## Checklist thuc hien

### 1. Pubspec va assets

- [x] Kiem tra `pubspec.yaml` co khai bao assets hien co.
- [x] Them `assets/videos/` vao `flutter.assets`.
- [x] Tao thu muc `assets/videos/` neu chua co.
- [x] Khong xoa assets cu.
- [x] Sua font path ve dung folder that `assets/fonts/montserrat/`.

### 2. Assets helper

- [x] Kiem tra `lib/shared/constants/assets_helper.dart`.
- [x] Sua `des2` tu `.jpg` sang `.png`.
- [x] Sua `des9` tu `.jpg` sang `.png`.

### 3. Helper anh dung chung

- [x] Tao `lib/shared/utils/app_image.dart`.
- [x] Them `AppImage.isAsset`.
- [x] Them `AppImage.isNetwork`.
- [x] Them `AppImage.provider` tra ve `AssetImage` hoac `CachedNetworkImageProvider`.
- [x] Them `AppImage.widget` tra ve `Image.asset` hoac `CachedNetworkImage`.
- [x] Them fallback mac dinh `assets/icons/ic_nodata.png`.
- [x] Them fallback avatar `assets/images/x2/img_user_profile_non.png`.

### 4. Thay render anh truc tiep

- [x] Tim va thay cac usage `CachedNetworkImage`.
- [x] Tim va thay cac usage `CachedNetworkImageProvider`.
- [x] Tim va thay cac usage `Image.network`.
- [x] Tim va thay cac usage `NetworkImage`.
- [x] Thay avatar/comment/profile photo sang `AppImage.provider`.
- [x] Thay anh city/tour/thumbnail/listArt sang `AppImage.widget` hoac `AppImage.provider`.
- [x] Van giu ho tro URL online qua helper.

### 5. Video player

- [x] Kiem tra `lib/modules/video_screen/views/widgets/video_player_iten.dart`.
- [x] Neu `videoUrl` bat dau bang `assets/` thi dung `VideoPlayerController.asset`.
- [x] Neu `videoUrl` la `http/https` thi dung `VideoPlayerController.network`.
- [x] Neu URL rong hoac init loi thi khong crash, hien error/loading widget.
- [x] Dispose controller an toan.

### 6. Vo hieu hoa Firebase Storage cho demo

- [x] Tim cac usage `FirebaseStorage`, `putFile`, `getDownloadURL`, `ref().child`.
- [x] Khong xoa controller Firestore.
- [x] Khong goi Firebase Storage khi xem Home/Tour/Profile/Video.
- [x] Upload avatar: hien snackbar va giu avatar cu/default asset.
- [x] Upload video: tao document demo voi asset path thay vi upload Storage.
- [x] Giu logic tao/ghi document Firestore.

### 7. Kiem tra

- [x] Chay `fvm flutter pub get`.
- [ ] Chay `fvm flutter analyze` toan project neu may khong timeout.
- [x] Chay build debug de bat loi compile co ban.
- [x] Scan lai de dam bao khong con direct media network/Firebase Storage trong `lib/modules` va `lib/shared/widgets`.

## Lenh kiem tra

```powershell
fvm flutter pub get
fvm flutter analyze
fvm flutter build apk --debug
```

Neu `analyze` timeout tren may hien tai, dung build debug lam moc compile toi thieu:

```powershell
fvm flutter build apk --debug
```

## Ghi chu van hanh

- Neu Firestore luu `assets/videos/travel_1.mp4` nhung file nay chua ton tai, app khong crash nhung video se bao khong tai duoc.
- Muon video demo phat that thi them file that vao `assets/videos/travel_1.mp4`.
- `firebase_storage` co the van nam trong `pubspec.yaml` de tranh thay doi dependency lon, nhung app khong con bat buoc goi Storage cho media demo.

## 2026-05-23 - Tiep tuc kiem tra Google Maps sau khi thay key

### Muc tieu

- Khong thay lai Google Maps API key neu key moi da nam dung trong file.
- Kiem tra `AndroidManifest.xml` va `map_key.dart`.
- Dam bao khong dung `google-services.json`.
- Kiem tra package/app id van la `com.example.doan_clean_achitec`.
- Lay log Google Maps ngan de phan biet loi tile do code hay do Google Cloud.

### Checklist

- [ ] Doc `RUN_OPTIMIZATION.md`.
- [ ] Doc `plan.md`.
- [ ] Doc `lịch sử.md`.
- [ ] Chay `git status --short`.
- [ ] Kiem tra key moi trong `AndroidManifest.xml` bang output mask.
- [ ] Kiem tra key moi trong `map_key.dart` bang output mask.
- [ ] Kiem tra `google-services.json` khong bi sua trong luot nay.
- [ ] Kiem tra `applicationId` va `package_name`.
- [ ] Lay log Google Maps ngan bang adb.
- [ ] Cap nhat `lịch sử.md`.

## 2026-05-23 - Sua loi Booking DropdownButton2

### Muc tieu

- Sua loi crash `DropdownButton2` o man Booking khi value la `Thanh pho Ho Chi Minh`.
- Khong doi Firebase config, package name, Gradle/FVM/pubspec.
- Khong dong cham Google Maps/Location.
- Sua toi thieu de dropdown khong bi duplicate value hoac value khong nam trong items.

### Checklist

- [x] Tim tat ca `DropdownButton2` trong `lib/modules/booking`.
- [x] Xac dinh dropdown nao dung city/name lam value.
- [x] Kiem tra controller booking dang set selected value nhu the nao.
- [x] Uu tien doi value sang id duy nhat neu phu hop.
- [x] Neu phai dung name, dedupe item values va reset value khong hop le.
- [x] Chay analyze folder/file booking lien quan.
- [x] Chay app de xac nhan build/install/run khong loi compile.
- [ ] Test thu cong tab Booking tren dien thoai.
- [ ] Cap nhat `lịch sử.md`.

## 2026-05-23 - Tich hop payOS qua backend local

### Muc tieu

- Them backend Node.js/Express local de tao payOS payment link.
- Khong dua PAYOS secret vao Dart/Flutter.
- Flutter goi backend local, mo `checkoutUrl` bang `url_launcher`.
- Giu fallback QR/banking demo cu neu backend loi.
- Booking van ghi `historyModel` voi cac field cu va field payment bo sung.

### File/thu muc se tao hoac sua

- Tao `backend/package.json`.
- Tao `backend/server.js`.
- Tao `backend/.env`.
- Tao `backend/.env.example`.
- Tao `backend/README.md`.
- Sua `.gitignore` de ignore `.env`/payOS env.
- Them service Flutter goi backend neu project da co `http`.
- Sua payment flow o `lib/modules/booking/booking_option/booking_payment.dart` hoac controller lien quan.
- Cap nhat `RUN_OPTIMIZATION.md`.
- Cap nhat `lịch sử.md`.

### RUI RO BAO MAT

- PAYOS keys chi nam trong `backend/.env`.
- Khong log full key.
- Khong dua key vao Dart.
- `backend/.env` phai duoc gitignore.
- Vi key da duoc gui trong chat, sau demo nen rotate key tren dashboard payOS.

### Kiem tra package

- [x] Kiem tra `pubspec.yaml` da co `http`/`dio` va `url_launcher`.
- [x] Neu da co thi khong them dependency Flutter.
- [x] Backend dung `express`, `dotenv`, `cors`, `@payos/node`.

### Checklist thuc hien

- [x] Tao backend local.
- [x] Tao `.env.example` placeholder va `.env` that.
- [x] Sua `.gitignore`.
- [x] Tao service Flutter goi `/create-payos-payment`.
- [x] Gan payment button goi payOS truoc, fallback demo booking khi loi.
- [x] Them field bo sung vao `historyModel` khi payOS link tao thanh cong.
- [x] Chay `npm install` trong `backend`.
- [x] Test `GET /health`.
- [x] Test request tao payment link neu co the.
- [x] Chay analyze file Flutter lien quan.
- [x] Chay app de xac nhan compile.
- [x] Cap nhat `RUN_OPTIMIZATION.md`.
- [x] Cap nhat `lịch sử.md`.

## 2026-05-23 - Test payOS end-to-end qua IP LAN

### Muc tieu

- Xac dinh IP LAN cua may tinh.
- Dam bao backend payOS truy cap duoc bang `localhost` va bang IP LAN.
- Chay Flutter voi `--dart-define=PAYOS_BACKEND_URL=http://<IP-LAN>:3000`.
- Khong hard-code IP vao Dart.
- Khong dua key payOS vao Flutter.

### Checklist

- [x] Chay `ipconfig` de lay IPv4 LAN.
- [x] Dam bao backend dang chay tren port 3000.
- [x] Test `GET http://localhost:3000/health`.
- [x] Test `GET http://<IP-LAN>:3000/health`.
- [x] Neu IP LAN fail, kiem tra listen `0.0.0.0`/firewall.
- [x] Test `POST http://<IP-LAN>:3000/create-payos-payment`.
- [x] Chay Flutter voi dart-define backend URL.
- [ ] Neu co the, test thu cong bam Payment tren app.
- [x] Cap nhat `lịch sử.md`.

## 2026-05-23 - Kiem tra Flutter goi backend payOS

### Muc tieu

- Xac nhan Flutter service doc `PAYOS_BACKEND_URL` tu `--dart-define`.
- Xac nhan button Payment QR/banking that su goi payOS service.
- Them log Flutter ro hon cho backend URL, request body an toan, response status, checkout URL state va error.
- Khong log key payOS.
- Khong hard-code IP LAN vao code.

### Checklist

- [x] Doc `lib/shared/services/payos_payment_service.dart`.
- [x] Doc `lib/modules/booking/booking_option/booking_option_screen.dart`.
- [x] Them log `[PAYOS_FLUTTER]` neu can.
- [x] Chay analyze file lien quan.
- [x] Chay Flutter voi `--dart-define=PAYOS_BACKEND_URL=http://10.10.10.34:3000`.
- [x] Neu run timeout, chot log va huong dan bam Payment thu cong khi app dang chay.
- [x] Cap nhat `lịch sử.md`.

## 2026-05-23 - Test nhanh payOS bang fallback IP LAN

### Muc tieu

- Tam doi default fallback backend URL sang `http://10.10.10.34:3000`.
- Van giu `String.fromEnvironment('PAYOS_BACKEND_URL')` de `--dart-define` override duoc.
- Them comment ro day la IP LAN may dev de test local backend, khong nen commit/push neu nhom chua thong nhat.
- Khong dua key payOS vao Flutter.

### Checklist

- [x] Sua default fallback trong `payos_payment_service.dart`.
- [x] Chay analyze file service va booking lien quan.
- [x] Chay app khong dart-define.
- [x] Neu run timeout, chot log va yeu cau test tay neu app da install/mo duoc.
- [x] Cap nhat `lịch sử.md`.

## 2026-05-23 - Sua Payment Method / payOS trong Confirm Booking

### Muc tieu

- Bo/thay text mau cua nguoi khac trong man Confirm Booking.
- QR/payOS va Banking deu goi payOS backend.
- Visa/Card khong goi Stripe/secret trong app, hien thong bao cau hinh.
- Khong doi schema cu, chi giu field payment bo sung da co.
- Khong dung text hien thi de quyet dinh logic payment.

### Checklist

- [x] Tim noi hien thi `4242`, `DO VAN LAM`, `BIDV DO VAN LAM`, `Scan QR code`.
- [x] Xac dinh value method hien tai: `qrcode`, `banking`, `visacard`.
- [x] Doi UI method trong Confirm Booking sang text phu hop payOS.
- [x] QR/payOS va Banking goi `_confirmPayOsPayment()`.
- [x] Visa/Card hien snackbar va khong goi Stripe.
- [x] Them log `[PAYMENT_METHOD]`.
- [x] Chay analyze file lien quan.
- [x] Chay app.
- [x] Cap nhat `lịch sử.md`.
- [ ] Test thu cong bam Payment va xem backend console.

## 2026-05-23 - Tich hop Visa Card bang Stripe test mode an toan

### Muc tieu

- Dung backend Node.js hien co de tao Stripe PaymentIntent.
- Flutter chi nhan `clientSecret` va mo Stripe PaymentSheet.
- Khong dua `sk_test` vao Flutter.
- Khong pha luong QR/banking payOS da chay.
- Neu backend Stripe chua co `STRIPE_SECRET_KEY`, hien loi than thien va bao dung QR payOS.

### File se kiem tra/sua

- `backend/package.json`
- `backend/server.js`
- `backend/.env.example`
- `backend/README.md`
- `lib/main.dart`
- `lib/modules/pay/pay_controller.dart`
- `lib/modules/booking/booking_option/booking_option_screen.dart`
- Tao `lib/shared/services/stripe_payment_service.dart`
- `plan.md`
- `lịch sử.md`

### Checklist

- [x] Kiem tra `flutter_stripe` trong `pubspec.yaml`.
- [x] Kiem tra `Stripe.publishableKey` trong `lib/main.dart`.
- [x] Quet `sk_test` trong `lib/`.
- [x] Xoa/vo hieu hoa direct Stripe secret trong Flutter.
- [x] Them package `stripe` cho backend.
- [x] Them endpoint `POST /create-stripe-payment-intent`.
- [x] Cap nhat `.env.example` va `README.md`.
- [x] Tao Flutter `StripePaymentService`.
- [x] Doi Visa/Card trong Confirm Booking sang backend + PaymentSheet.
- [x] Chay `npm install` trong `backend`.
- [x] Test `GET /health`.
- [x] Chay analyze file lien quan.
- [x] Chay app neu can.
- [x] Cap nhat `RUN_OPTIMIZATION.md`.
- [x] Cap nhat `lịch sử.md`.
- [ ] Dien `STRIPE_SECRET_KEY` that vao `backend/.env`.
- [ ] Test thu cong PaymentSheet voi the Stripe test.

## 2026-05-23 - Cau hinh va test Stripe keys

### Muc tieu

- Kiem tra `backend/.env` da co `STRIPE_SECRET_KEY=sk_test...` chua ma khong in full key.
- Kiem tra `backend/.env` dang duoc `.gitignore`.
- Kiem tra Flutter khong chua `sk_test`.
- Kiem tra publishable key trong `lib/main.dart`.
- Test backend health va PaymentIntent neu secret da co.
- Chay app de xac nhan compile/run.

### Checklist

- [x] Kiem tra `backend/.env` co `STRIPE_SECRET_KEY`.
- [x] Kiem tra `.gitignore` co ignore `backend/.env`.
- [x] Quet `lib/` de dam bao khong co `sk_test`.
- [x] Kiem tra `Stripe.publishableKey` trong `lib/main.dart`.
- [x] Test `GET /health`.
- [x] Test `POST /create-stripe-payment-intent`.
- [x] Chay Flutter app.
- [x] Cap nhat `lịch sử.md`.
- [ ] Dien `STRIPE_SECRET_KEY=sk_test...` vao `backend/.env`.
- [ ] Neu co publishable key moi, cap nhat `Stripe.publishableKey`.
- [ ] Test PaymentSheet thu cong.

## 2026-05-23 - Hoan tat cau hinh Stripe test key moi

### Muc tieu

- Ghi `STRIPE_PUBLISHABLE_KEY` va `STRIPE_SECRET_KEY` moi vao `backend/.env`.
- Thay `Stripe.publishableKey` trong Flutter sang key moi.
- Dam bao `sk_test` khong xuat hien trong `lib/`.
- Restart backend va test `stripeConfigured=true`.
- Test tao PaymentIntent.
- Chay Flutter app de xac nhan build/install/run.

### File can sua

- `backend/.env`
- `backend/.env.example`
- `lib/main.dart`
- `plan.md`
- `lịch sử.md`

### Rui ro can tranh

- Khong dua `sk_test` vao Dart/Flutter.
- Khong log full key.
- Khong commit/push `backend/.env`.
- Khong dung `rk_test`.
- Khong sua Google Maps/payOS.

### Checklist

- [x] Cap nhat `backend/.env` voi key moi.
- [x] Cap nhat `backend/.env.example` placeholder publishable/secret.
- [x] Cap nhat `lib/main.dart` publishable key moi.
- [x] Quet `lib/` dam bao khong co `sk_test`.
- [x] Kiem tra `.gitignore` ignore `backend/.env`.
- [x] Restart backend.
- [x] Test `GET /health`.
- [x] Test `POST /create-stripe-payment-intent`.
- [x] Chay Flutter app.
- [x] Cap nhat `lịch sử.md`.
- [ ] Test PaymentSheet thu cong tren dien thoai.

## 2026-05-23 - Sua loi trang History

### Muc tieu

- Sua loi man History bi crash sau khi tao booking/payment.
- Khong sua Google Maps, payOS, Stripe, Firebase config, package name, Gradle/FVM/pubspec.
- Giu schema Firestore cu, chi doc du lieu an toan hon va bo qua history record bi thieu tour tuong ung.

### Nguyen nhan nghi ngo

- `historyModel` co document tro toi `idTour` khong ton tai trong `tourModel` hoac id rong.
- UI History lay `itemCount` theo danh sach history nhung index theo danh sach tour, neu 2 list lech nhau se crash.
- `HistoryModel.fromJson` goi `.toDouble()` truc tiep, co the crash neu Firestore luu so dang String/null.

### Checklist

- [x] Cap nhat `HistoryModel` parse number/payment field an toan.
- [x] Cap nhat `HistoryTourController` de tao danh sach history-tour dong bo.
- [x] Cap nhat UI History dung itemCount an toan.
- [x] Chay analyze cac file History lien quan.
- [x] Chay app neu can.
- [x] Cap nhat `lịch sử.md`.

## 2026-05-23 - Chatbox va tool Python tao data tu Firebase

### Muc tieu

- Tao folder rieng cho tool Python xuat du lieu Firestore thanh dataset/knowledge base dung de huan luyen chatbot.
- Khong dua service account/key vao repo.
- Them chatbox hien thi tren toan bo app Flutter voi sua toi thieu o `main.dart`.
- Khong doi Firebase config, package name, Gradle/FVM/pubspec neu khong bat buoc.

### File se tao/sua

- Tao `chatbot_training/README.md`.
- Tao `chatbot_training/requirements.txt`.
- Tao `chatbot_training/export_firestore_training_data.py`.
- Tao `lib/shared/widgets/chatbot/chatbot_overlay.dart`.
- Sua `lib/main.dart` de wrap app bang chatbox overlay.
- Cap nhat `.gitignore` neu can de ignore output/service account local.
- Cap nhat `lịch sử.md`.

### Huong tiep can

- Tool Python doc cac collection chinh:
  - `cityModel`
  - `tourModel`
  - `searchTour`
  - `videos`
- Xuat:
  - JSONL prompt/answer tieng Viet.
  - JSON knowledge base.
- Chatbox Flutter la UI demo local/rule-based, khong goi API ngoai va khong can key.

### Checklist

- [x] Lap plan.
- [x] Tao tool Python export data Firestore.
- [x] Tao README huong dan chay tool.
- [x] Them ignore output va service account local.
- [x] Tao chatbox overlay Flutter.
- [x] Gan chatbox vao `GetMaterialApp.builder`.
- [x] Format/analyze file lien quan.
- [x] Chay app de kiem tra build/install/run.
- [x] Cap nhat `lịch sử.md`.

## 2026-05-23 - Chatbot server Python va data cho Flutter

### Muc tieu

- Tao server Python local cho chatbox.
- Sinh data chatbot de Flutter co the dung offline/fallback.
- Gioi han pham vi tra loi dung chu de project Travel Booking.
- Khong them backend key/AI key, khong goi OpenAI hay dich vu ngoai.
- Khong doi Firebase config, package name, Gradle/FVM.

### File se tao/sua

- Tao `chatbot_training/generate_project_chatbot_data.py`.
- Tao `chatbot_training/chatbot_server.py`.
- Sua `chatbot_training/README.md`.
- Tao `assets/chatbot/chatbot_knowledge_base.json`.
- Tao `lib/shared/services/chatbot_service.dart`.
- Sua `lib/shared/widgets/chatbot/chatbot_overlay.dart`.
- Sua `pubspec.yaml` them `assets/chatbot/` neu can.
- Cap nhat `RUN_OPTIMIZATION.md`.
- Cap nhat `lịch sử.md`.

### Pham vi chatbot

Chatbot chi tra loi ve:

- tour/diem den/gia tour
- dat tour/booking
- payment payOS/Stripe/Visa
- history booking
- favorite/yêu thích
- Firestore/data project

Ngoai pham vi se tra ve cau tu choi than thien va goi y hoi dung chu de.

### Checklist

- [x] Tao data generator.
- [x] Sinh data asset cho Flutter.
- [x] Tao Python server `/health` va `/chat`.
- [x] Tao Flutter service goi server va fallback local.
- [x] Cap nhat chatbox UI goi service bat dong bo.
- [x] Chay py_compile.
- [x] Chay server health/chat.
- [x] Chay analyze Flutter.
- [ ] Chay app/build debug: timeout do Flutter/Gradle tool khong co log moi.
- [x] Cap nhat lich su.

## 2026-05-23 - Nang cap chatbox keo tha va card tour

### Muc tieu

- Bong chat co the keo di chuyen tren man hinh.
- Khi hoi ve tour, chatbot tra loi kem anh va thong tin tour.
- Nut trong card tour co the dieu huong den man chi tiet tour.
- Neu cau hoi khong dung chu de project, chatbot van gioi han pham vi va tu choi nhe.

### File sua

- `chatbot_training/generate_project_chatbot_data.py`
- `chatbot_training/chatbot_server.py`
- `assets/chatbot/chatbot_knowledge_base.json`
- `lib/shared/services/chatbot_service.dart`
- `lib/shared/widgets/chatbot/chatbot_overlay.dart`
- `plan.md`
- `lịch sử.md`

### Checklist

- [x] Them anh/mo ta vao data tour chatbot.
- [x] Server `/chat` tra ve object `tour` khi match duoc tour.
- [x] Flutter service parse `tour` tu server/local.
- [x] Chatbox hien card tour co anh, ten, vi tri, thoi luong, gia.
- [x] Nut `Xem chi tiết tour` tao `TourModel` va mo `Routes.TOUR_DETAILS`.
- [x] Bong chat keo tha bang gesture.
- [x] Chay generator, py_compile, analyze.

## 2026-05-26 - Don file, cap nhat README va up GitHub

### Muc tieu

- Tao folder chua thong tin demo va anh demo cho project.
- Cap nhat `README.md` de mo ta day du Booking Travel App.
- Don file sinh ra/cache an toan truoc khi day code len GitHub.
- Commit/push len repo:
  - `https://github.com/thptltkk55-max/bookingtravelticketapp.git`

### Nhom file duoc xoa neu co

- `build/`
- `.dart_tool/`
- `android/.gradle/`
- `backend/node_modules/`
- `chatbot_training/__pycache__/`
- `chatbot_training/output/`
- `*.log`
- `.DS_Store`
- Flutter/Gradle cache sinh ra co the tao lai.

### Nhom file khong duoc xoa

- `lib/`
- `assets/`
- `pubspec.yaml`
- `pubspec.lock`
- `android/`
- `android/app/google-services.json`
- `android/app/src/main/AndroidManifest.xml`
- `.fvmrc`
- `.fvm/`
- `backend/server.js`
- `backend/package.json`
- `backend/package-lock.json`
- `backend/.env.example`
- `backend/.env` local secrets
- `README.md`
- `RUN_OPTIMIZATION.md`
- `plan.md`
- `lịch sử.md`
- `.gitignore`

### Secret check

- [ ] Dam bao `.gitignore` ignore `backend/.env`, `.env`, `.env.local`, `firebase-adminsdk*.json`.
- [ ] Dam bao `backend/.env` khong bi stage/commit.
- [ ] Khong ghi key that vao README.

### Lenh kiem tra

- [x] `git status --short`
- [x] `git remote -v`
- [x] `git branch --show-current`
- [x] `git clean -ndX`
- [ ] Don cache/log chon loc.
- [ ] `fvm flutter pub get`
- [ ] `fvm flutter analyze`
- [ ] `git status --short`

### Commit/push

- [ ] Doi remote origin sang repo GitHub moi.
- [ ] `git add .`
- [ ] Kiem tra staged secret truoc commit.
- [ ] `git commit -m "Clean project and update Booking Travel app"`
- [ ] `git branch -M main`
- [ ] `git push -u origin main`
