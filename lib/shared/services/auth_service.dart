import 'package:doan_clean_achitec/models/user/user_model.dart';
import 'package:doan_clean_achitec/modules/auth/user_controller.dart';
import 'package:doan_clean_achitec/modules/home/home.dart';
import 'package:doan_clean_achitec/modules/profile/profile_controller.dart';
import 'package:doan_clean_achitec/shared/constants/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/string_constants.dart';

class AuthService {
  final ProfileController profileController =
      Get.put<ProfileController>(ProfileController());

  final UserController userController = Get.put(UserController());

  final HomeController homeController = Get.put(HomeController());

  Future<User?> signInWithGoogle() async {
    try {
      debugPrint('[AuthService] Starting Google sign-in.');
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        debugPrint('[AuthService] Google sign-in was cancelled by user.');
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = authResult.user;
      debugPrint('[AuthService] Firebase Google sign-in success: '
          'uid=${user?.uid}, email=${user?.email}');

      if (user != null) {
        userController.user.value = user;
        userController.userUID = user.uid;
        userController.userEmail.value = user.email ?? '';
        if ((user.email ?? '').isNotEmpty) {
          userController.userName.value = user.email!.substring(
            0,
            user.email!.length < 5 ? user.email!.length : 5,
          );
        }

        final existingUser =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(user.email!);
        debugPrint('[AuthService] Existing sign-in methods for '
            '${user.email}: $existingUser');

        if (existingUser.isNotEmpty) {
          if (!await profileController.isCheckExist(user.email ?? '')) {
            final UserModel userModel = UserModel(
              email: user.email ?? "",
              passWord: "",
              phoneNub: "",
              isActive: true,
            );
            await profileController.createUser(userModel);
          }
        }

        await homeController.getUserDetails(user.email ?? '');
        final fcmTokenGet = LocalStorageHelper.getValue('fcmToken') ?? "";
        await profileController.createPushNotification(
          homeController.userModel.value?.id ?? "",
          fcmTokenGet,
        );
      }

      return user;
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('[AuthService] Firebase Google sign-in failed: '
          'code=${e.code}, message=${e.message}');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar(
        StringConst.errorSigningInWithGoogle.tr,
        '${e.code}: ${e.message ?? e.toString()}',
      );
      return null;
    } on PlatformException catch (e, stackTrace) {
      debugPrint('[AuthService] Google platform sign-in failed: '
          'code=${e.code}, message=${e.message}, details=${e.details}');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar(
        StringConst.errorSigningInWithGoogle.tr,
        '${e.code}: ${e.message ?? e.toString()}',
      );
      return null;
    } catch (error, stackTrace) {
      debugPrint('[AuthService] Google sign-in failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar(StringConst.errorSigningInWithGoogle.tr, '$error');
      return null;
    }
  }
}
