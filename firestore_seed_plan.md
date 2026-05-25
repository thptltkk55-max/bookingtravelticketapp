# Plan: Tool tao va dong bo du lieu Firestore demo

## Muc tieu

Tao mot tool chay ngoai app Flutter de seed/upsert du lieu demo len Firebase Firestore, dung dung collection va field ma project dang doc, giup app Booking Travel GetX co du du lieu hien thi bang tieng Viet va media path tu `assets/`.

## Nguyen tac

- Khong tao project Flutter moi.
- Khong doi package name/applicationId.
- Khong doi Firebase config trong app.
- Khong sua UI/logic app.
- Khong xoa du lieu Firestore mac dinh.
- Tool chi upsert document bang `set(..., { merge: true })`.
- Khong commit service account key.
- Du lieu text dung UTF-8 tieng Viet.
- Media dung path `assets/...` de khong can Firebase Storage.

## Collection can seed

- `cityModel`
- `tourModel`
- `userModel`
- `historyModel`
- `videos`
- `searchTour`
- `pushNotification`

## Subcollection can seed

- `userModel/{userDocumentId}/favourite`
- `userModel/{userDocumentId}/favouriteTour`
- `tourModel/{tourDocumentId}/comments`
- `videos/{videoDocumentId}/comments`

## Cau truc tool

- `tools/firestore_seed_data.js`
  - Chua toan bo du lieu demo.
  - Chua helper tao duong dan document/subcollection.
  - Chua marker timestamp de importer chuyen thanh Firestore Timestamp.
- `tools/import_firestore_seed.js`
  - Ho tro `--dry-run` de xem truoc.
  - Ho tro `--yes` de xac nhan ghi Firestore.
  - Doc service account tu `GOOGLE_APPLICATION_CREDENTIALS` hoac `FIREBASE_SERVICE_ACCOUNT`.
  - Doc project id tu `FIREBASE_PROJECT_ID` hoac service account.
- `package.json`
  - Them script `npm run seed:firestore`.
  - Khai bao dependency `firebase-admin`.

## Checklist thuc hien

- [x] Doc model Dart va controller Firestore de lay dung field.
- [x] Tao seed data dung `cityModel`.
- [x] Tao seed data dung `tourModel`.
- [x] Tao seed data dung `userModel`.
- [x] Tao seed data dung `historyModel`.
- [x] Tao seed data dung `videos`.
- [x] Tao seed data dung `searchTour`.
- [x] Tao seed data dung `pushNotification`.
- [x] Tao subcollection favourite/favouriteTour/comments.
- [x] Tao importer Firestore Admin SDK.
- [x] Them che do dry-run an toan.
- [x] Them ignore service account key.
- [x] Kiem tra dry-run.

## Cach chay

Lan dau cai package Node:

```powershell
npm install
```

Dat service account key local, vi du:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\duong-dan-rieng\serviceAccountKey.json"
```

Xem truoc du lieu se ghi:

```powershell
npm run seed:firestore:dry
```

Ghi len Firestore:

```powershell
npm run seed:firestore
```

Hoac chay truc tiep:

```powershell
node tools/import_firestore_seed.js --dry-run
node tools/import_firestore_seed.js --yes
```

## Luu y Firebase

- Can tao Firestore Database tren Firebase Console truoc.
- Can service account JSON cua dung Firebase project.
- Khong dua service account JSON len GitHub.
- Tool nay khong tao Firebase Auth user that, chi tao document `userModel` demo de UI co du du lieu.
