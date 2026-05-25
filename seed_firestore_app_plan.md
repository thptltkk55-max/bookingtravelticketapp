# Plan: Seed Firestore truc tiep tu app Flutter

## Muc tieu

Them chuc nang seed nhanh du lieu mau len Firestore ngay trong app Flutter Booking Travel GetX, phu hop voi UI hien tai va khong can tao tay collection/document tren Firebase Console.

## Nguyen tac

- Khong tao project Flutter moi.
- Khong xoa Firebase Authentication.
- Khong xoa Firestore.
- Khong xoa Firebase Messaging.
- Khong xoa Stripe.
- Khong doi ten collection.
- Khong doi ten field model.
- Khong dung Firebase Storage.
- Tat ca anh/video seed bang path `assets/...`.
- Dung `SetOptions(merge: true)` de chay lai khong tao trung document.

## Collection seed

- `cityModel`
- `tourModel`
- `searchTour`
- `videos`
- `userModel/{uid}` neu da dang nhap

## File can tao/sua

- `lib/shared/services/seed_firestore.dart`
  - Tao class `SeedFirestore`.
  - Tao `seedAll()`.
  - Tao `_seedCities()`.
  - Tao `_seedTours()`.
  - Tao `_seedSearchTour()`.
  - Tao `_seedVideos()`.
  - Tao `seedCurrentUser()`.
- `lib/main.dart`
  - Import `seed_firestore.dart`.
  - Goi `await SeedFirestore.seedAll();` ngay sau Firebase initialize.

## Checklist

- [x] Kiem tra `pubspec.yaml` co `assets/videos/`.
- [x] Kiem tra thu muc `assets/videos/` ton tai.
- [x] Tao `lib/shared/services/seed_firestore.dart`.
- [x] Dung `WriteBatch`.
- [x] Dung `SetOptions(merge: true)`.
- [x] Seed 8 city.
- [x] Seed 8 tour.
- [x] Seed keyword `searchTour`.
- [x] Seed 2 video demo asset.
- [x] Seed current user neu da dang nhap.
- [x] Gan seed vao `main.dart` sau Firebase initialize.
- [x] Chay `fvm flutter pub get`.
- [x] Chay `fvm flutter analyze`.

## Sau khi seed thanh cong

Sau khi chay app mot lan va Firestore da co du lieu, comment dong sau trong `lib/main.dart`:

```dart
// await SeedFirestore.seedAll();
```

Khong xoa file `seed_firestore.dart`; giu lai de sau nay can seed lai thi mo comment.
