# Run On Any Machine

## Open the Correct Folder

Open the project root folder that contains `pubspec.yaml`.

## Required Tools

- FVM
- Flutter `3.10.5`
- Android Studio or Android SDK command-line tools
- JDK 17 is recommended for this Gradle setup

Install FVM:

```powershell
dart pub global activate fvm
```

## First-Time Setup

```powershell
fvm install 3.10.5
fvm use 3.10.5 --force
fvm flutter clean
fvm flutter pub get
```

## Run the App

```powershell
fvm flutter run
```

## Build APK

Debug:

```powershell
fvm flutter build apk --debug
```

Release:

```powershell
fvm flutter build apk --release
```

## Common Issues

### Flutter SDK not found

Run:

```powershell
fvm install 3.10.5
fvm use 3.10.5 --force
fvm flutter pub get
```

Do not commit `.fvm/flutter_sdk` or `.fvm/versions/`.

### Android SDK not found

Install Android Studio, open SDK Manager, and install the Android SDK. Then run:

```powershell
fvm flutter doctor -v
```

Do not commit `android/local.properties`; Flutter creates it per machine.

### Android license not accepted

Run:

```powershell
fvm flutter doctor --android-licenses
```

Accept the licenses, then run `fvm flutter doctor -v` again.

### NDK missing

Install the NDK version shown by the Gradle error in Android Studio SDK Manager. This project declares the NDK version in Gradle, so do not hardcode `ndk.dir`.

### Gradle build failed

Run:

```powershell
fvm flutter clean
fvm flutter pub get
fvm flutter build apk --debug
```

If the error mentions a dependency or Android SDK package, install only the missing package or adjust the dependency minimally.

If Gradle says Java is too old, install JDK 17 and set `JAVA_HOME` to that JDK before building. If Gradle says `Unsupported class file major version 65`, your Java is too new for this Gradle version; use JDK 17 instead of JDK 21.

### Firebase `google-services.json` missing

This project uses Firebase. Keep `android/app/google-services.json` in the project if Firebase is enabled. If it is missing, ask the project owner for the correct Firebase config file.
