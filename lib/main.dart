import 'package:doan_clean_achitec/dark_mode.dart';
import 'package:doan_clean_achitec/routes/app_pages.dart';
import 'package:doan_clean_achitec/shared/constants/colors.dart';
import 'package:doan_clean_achitec/shared/constants/local_storage.dart';
import 'package:doan_clean_achitec/shared/services/notification.dart';
import 'package:doan_clean_achitec/shared/widgets/chatbot/chatbot_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'modules/lang/translation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  AppController darkMode = AppController();

  await darkMode.loadDarkMode();
  await LocalStorageHelper.initLocalStorageHelper();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstants.blue,
  ));

  Stripe.publishableKey =
      "pk_test_51Ta1gPHnLuEeltx02gRZeFFSf6nlhNzMROZejPetr7gh9RHrDGsWBFON2kAC3f07g736ENCU8E59YX559Xu0RS1F00uCDPunUz";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  // Khởi tạo Firebase mới từ file:
  // android/app/google-services.json
  await initializeFirebaseSafely();
  // await SeedFirestore.seedAll();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("onMessage: $event");
    });

    await subscribeToBookingTopic();
    LocalStorageHelper.setString('fcmToken', fcmToken);
  } else {
    print('fcmToken is null');
  }

  final handler = NotificationHandler();
  handler.setListeners();

  runApp(MyApp());
}

Future<void> initializeFirebaseSafely() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      print('Firebase đã được khởi tạo trước đó, bỏ qua duplicate-app.');
    } else {
      rethrow;
    }
  }
}

Future<void> subscribeToBookingTopic() async {
  await FirebaseMessaging.instance.subscribeToTopic("topic");
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeFirebaseSafely();

  print("onBackgroundMessage: $message");
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppController controller = Get.put(AppController());

  final mainTheme = ThemeData(
    scaffoldBackgroundColor: ColorConstants.bgrLight,
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
    ),
  );

  final darkTheme = ThemeData.dark();

  @override
  Widget build(BuildContext context) {
    final easyLoadingBuilder = EasyLoading.init();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: Routes.SPLASH,
        defaultTransition: Transition.fade,
        getPages: AppPages.routes,
        smartManagement: SmartManagement.keepFactory,
        title: 'Flutter GetX Clean Travel',
        theme: controller.isDarkModeOn.value
            ? darkTheme.copyWith(brightness: Brightness.dark)
            : mainTheme.copyWith(brightness: Brightness.light),
        locale: TranslationService.locale,
        fallbackLocale: TranslationService.fallbackLocale,
        translations: TranslationService(),
        builder: (context, child) {
          return easyLoadingBuilder(
            context,
            ChatbotOverlay(
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..radius = 10.0
    ..backgroundColor = ColorConstants.lightGray
    ..indicatorColor = hexToColor('#64DEE0')
    ..textColor = hexToColor('#64DEE0')
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}
