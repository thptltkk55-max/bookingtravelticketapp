import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_clean_achitec/dark_mode.dart';
import 'package:doan_clean_achitec/models/tour/tour_model.dart';
import 'package:doan_clean_achitec/models/user/user_model.dart';
import 'package:doan_clean_achitec/modules/auth/auth.dart';
import 'package:doan_clean_achitec/modules/booking/booking_option/booking_option_controller.dart';
import 'package:doan_clean_achitec/modules/booking/booking_request.dart';
import 'package:doan_clean_achitec/modules/home/home_controller.dart';
import 'package:doan_clean_achitec/modules/profile/profile_controller.dart';
import 'package:doan_clean_achitec/routes/app_pages.dart';
import 'package:doan_clean_achitec/shared/constants/constants.dart';
import 'package:doan_clean_achitec/shared/services/payos_payment_service.dart';
import 'package:doan_clean_achitec/shared/services/stripe_payment_service.dart';
import 'package:doan_clean_achitec/shared/utils/regex.dart';
import 'package:doan_clean_achitec/shared/utils/size_utils.dart';
import 'package:doan_clean_achitec/shared/widgets/button_widget.dart';
import 'package:doan_clean_achitec/shared/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/constants/app_style.dart';
import '../../../shared/utils/app_bar_widget.dart';
import '../../auth/user_controller.dart';
import '../booking_controller.dart';

class BookingOptionScreen extends GetView<BookingOptionController> {
  BookingOptionScreen({super.key});

  final TourModel? tourModel = Get.arguments['arg1'];
  final String statusPaymentMethod = Get.arguments['arg2'];

  final AppController appController = Get.find();
  final AuthController authController = Get.find();
  final HomeController homeController = Get.find();
  final ProfileController profileController = Get.put(ProfileController());
  final UserController userController = Get.put(UserController());
  final BookingController bookingController = Get.put(BookingController());
  final BookingRequestController bookingRequestController =
      Get.put(BookingRequestController());

  static const String _methodQrPayOs = 'qrcode';
  static const String _methodBanking = 'banking';
  static const String _methodVisaCard = 'visacard';

  String get _selectedPaymentTitle {
    if (statusPaymentMethod == _methodQrPayOs) {
      return 'Thanh toán QR payOS';
    }
    if (statusPaymentMethod == _methodBanking) {
      return 'Chuyển khoản ngân hàng';
    }
    if (statusPaymentMethod == _methodVisaCard) {
      return 'Visa Card';
    }
    return statusPaymentMethod;
  }

  String get _selectedPaymentSubtitle {
    if (statusPaymentMethod == _methodQrPayOs) {
      return 'Quét QR bằng ứng dụng ngân hàng qua payOS';
    }
    if (statusPaymentMethod == _methodBanking) {
      return 'Tạo link thanh toán tự động qua payOS';
    }
    if (statusPaymentMethod == _methodVisaCard) {
      return 'Thanh toán thẻ an toàn qua Stripe test mode';
    }
    return 'Thanh toán an toàn qua payOS';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titles: "Confirm Booking".tr,
        backgroundColor: appController.isDarkModeOn.value
            ? ColorConstants.darkAppBar
            : ColorConstants.primaryButton,
        iconBgrColor: ColorConstants.lightBackground,
      ),
      backgroundColor: appController.isDarkModeOn.value
          ? ColorConstants.darkBackground
          : ColorConstants.lightBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: appController.isDarkModeOn.value
                          ? ColorConstants.darkCard
                          : ColorConstants.lightCard,
                      child: Padding(
                        padding: EdgeInsets.all(getSize(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tourModel?.nameTour ?? '',
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.white000Size18Fw600FfMont
                                  : AppStyles.black000Size18Fw600FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(16),
                            ),
                            Text(
                              StringConst.startLocation.tr,
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.gray400Size14Fw400FfMont
                                  : AppStyles.gray600Size14Fw400FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(2),
                            ),
                            Text(
                              '${tourModel?.accommodation}',
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.white000Size14Fw400FfMont
                                  : AppStyles.black000Size14Fw400FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(16),
                            ),
                            Text(
                              StringConst.startDateTour.tr,
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.gray400Size14Fw400FfMont
                                  : AppStyles.gray600Size14Fw400FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(2),
                            ),
                            Text(
                              controller.formatTimeStampToString(
                                  tourModel?.startDate ?? Timestamp.now()),
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.white000Size14Fw400FfMont
                                  : AppStyles.black000Size14Fw400FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(16),
                            ),
                            Text(
                              StringConst.quantity.tr,
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.gray400Size14Fw400FfMont
                                  : AppStyles.gray600Size14Fw400FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(2),
                            ),
                            Text(
                              "${StringConst.adult.tr} x ${bookingRequestController.adultNumb.value?.toInt()}, ${StringConst.children.tr} x ${bookingRequestController.childrenNumb.value?.toInt()}",
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.white000Size14Fw400FfMont
                                  : AppStyles.black000Size14Fw400FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(16),
                    ),
                    Container(
                      width: double.infinity,
                      color: appController.isDarkModeOn.value
                          ? ColorConstants.darkCard
                          : ColorConstants.lightCard,
                      child: Padding(
                        padding: EdgeInsets.all(getSize(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConst.informationCustomer.tr,
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.white000Size18Fw600FfMont
                                  : AppStyles.black000Size18Fw600FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(24),
                            ),
                            Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringConst.firstName.tr,
                                    style: appController.isDarkModeOn.value
                                        ? AppStyles.gray400Size14Fw400FfMont
                                        : AppStyles.black000Size14Fw400FfMont,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  SizedBox(
                                    height: getSize(16),
                                  ),
                                  MyTextField(
                                    controller:
                                        controller.firstNameConfirmController,
                                    hintText: StringConst.enterYourFirstname.tr,
                                    obscureText: false,
                                  ),
                                  SizedBox(
                                    height: getSize(24),
                                  ),
                                  Text(
                                    StringConst.lastName.tr,
                                    style: appController.isDarkModeOn.value
                                        ? AppStyles.white000Size14Fw400FfMont
                                        : AppStyles.black000Size14Fw400FfMont,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  SizedBox(
                                    height: getSize(16),
                                  ),
                                  MyTextField(
                                    controller: controller.lastNameController,
                                    hintText: StringConst.enterYourLastName.tr,
                                    obscureText: false,
                                  ),
                                  SizedBox(
                                    height: getSize(24),
                                  ),
                                  Text(
                                    StringConst.email.tr,
                                    style: appController.isDarkModeOn.value
                                        ? AppStyles.white000Size14Fw400FfMont
                                        : AppStyles.black000Size14Fw400FfMont,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  SizedBox(
                                    height: getSize(16),
                                  ),
                                  MyTextField(
                                    controller: controller.emailController,
                                    hintText: StringConst.enterYourEmail.tr,
                                    obscureText: false,
                                    isCheckReadOnly: true,
                                  ),
                                  SizedBox(
                                    height: getSize(24),
                                  ),
                                  Text(
                                    StringConst.phoneNumber.tr,
                                    style: appController.isDarkModeOn.value
                                        ? AppStyles.white000Size14Fw400FfMont
                                        : AppStyles.black000Size14Fw400FfMont,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  SizedBox(
                                    height: getSize(16),
                                  ),
                                  MyTextField(
                                    controller:
                                        controller.phoneNumberController,
                                    hintText:
                                        StringConst.enterYourPhoneNumber.tr,
                                    obscureText: false,
                                    isTypeNumb: true,
                                    validatorCheck: (value) {
                                      if (!Regex.isPasswordNumber(
                                          value!.trim())) {
                                        return 'password must contain at least one number';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: getSize(24),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(16),
                    ),
                    Container(
                      width: double.infinity,
                      color: appController.isDarkModeOn.value
                          ? ColorConstants.darkCard
                          : ColorConstants.lightCard,
                      child: Padding(
                        padding: EdgeInsets.all(getSize(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConst.paymentMethod.tr,
                              style: appController.isDarkModeOn.value
                                  ? AppStyles.white000Size18Fw600FfMont
                                  : AppStyles.black000Size18Fw600FfMont,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            SizedBox(
                              height: getSize(16),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedPaymentTitle,
                                  style: appController.isDarkModeOn.value
                                      ? AppStyles.gray400Size16Fw400FfMont
                                      : AppStyles.gray600Size16Fw400FfMont,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                SizedBox(
                                  height: getSize(2),
                                ),
                                Text(
                                  _selectedPaymentSubtitle,
                                  style: appController.isDarkModeOn.value
                                      ? AppStyles.white000Size14Fw400FfMont
                                      : AppStyles.black000Size14Fw400FfMont,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(96),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(getSize(16)),
                  color: appController.isDarkModeOn.value
                      ? ColorConstants.darkCard
                      : ColorConstants.lightCard,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${bookingRequestController.totalPrice.toInt()} ',
                                style: AppStyles.blue000Size16Fw500FfMont,
                              ),
                              TextSpan(
                                text: 'VND ',
                                style: appController.isDarkModeOn.value
                                    ? AppStyles.white000Size14Fw400FfMont
                                    : AppStyles.black000Size14Fw400FfMont,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ButtonWidget(
                        textBtn: StringConst.payment.tr,
                        onTap: () async {
                          debugPrint(
                            '[PAYMENT_METHOD] selected title: '
                            '$_selectedPaymentTitle',
                          );
                          debugPrint(
                            '[PAYMENT_METHOD] selected value: '
                            '$statusPaymentMethod',
                          );

                          if (statusPaymentMethod == _methodQrPayOs ||
                              statusPaymentMethod == _methodBanking) {
                            final payOsStarted = await _confirmPayOsPayment();
                            if (!payOsStarted) {
                              debugPrint(
                                '[PAYOS_FLUTTER] fallback demo payment '
                                'because backend unavailable',
                              );
                              await _confirmDemoPayment();
                            }
                            return;
                          }

                          if (statusPaymentMethod == _methodVisaCard) {
                            await _confirmStripePayment();
                            return;
                          }

                          final userOtp = UserModel(
                            id: homeController.userModel.value?.id ?? '',
                            email: homeController.userModel.value?.email ?? '',
                            firstName: controller
                                .firstNameConfirmController.text
                                .trim(),
                            lastName: controller.lastNameController.text.trim(),
                            passWord:
                                homeController.userModel.value?.passWord ?? '',
                            imgAvatar:
                                homeController.userModel.value?.imgAvatar ?? "",
                            phoneNub:
                                controller.phoneNumberController.text.trim(),
                            location:
                                homeController.userModel.value?.location ?? "",
                            isActive: true,
                          );
                          authController.signInPhoneAuthentication(
                            controller.formatPhoneNumber(
                              controller.phoneNumberController.text,
                            ),
                            userOtp,
                            tourModel!,
                            statusPaymentMethod,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDemoPayment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDocId = await _resolveUserDocId();
    final idTour = tourModel?.idTour ?? '';
    final adult = bookingRequestController.adultNumb.value ?? 0;
    final children = bookingRequestController.childrenNumb.value ?? 0;
    final totalPrice = bookingRequestController.totalPrice.value ?? 0;

    debugPrint('[PAYMENT] Confirm booking demo');
    debugPrint('[PAYMENT] current uid: ${currentUser?.uid ?? ""}');
    debugPrint('[PAYMENT] current email: ${currentUser?.email ?? ""}');
    debugPrint('[PAYMENT] userModel document id: $userDocId');
    debugPrint('[PAYMENT] idTour: $idTour');
    debugPrint('[PAYMENT] adult: $adult');
    debugPrint('[PAYMENT] children: $children');
    debugPrint('[PAYMENT] totalPrice: $totalPrice');
    debugPrint('[PAYMENT] method: $statusPaymentMethod');
    debugPrint('[PAYMENT] function: BookingController.bookingTour');

    if (userDocId.isEmpty || idTour.isEmpty) {
      Get.snackbar(StringConst.error.tr, 'Booking fail !!!');
      return;
    }

    try {
      await bookingController.bookingTour(
        userDocId,
        idTour,
        Timestamp.now(),
        'waiting',
        adult,
        children,
        totalPrice,
      );
      debugPrint('[PAYMENT] Booking created in historyModel');
      Get.offAndToNamed(Routes.HISTORY_TOUR_SCREEN);
    } on FirebaseException catch (e) {
      debugPrint('[PAYMENT][ERROR] FirebaseException code: ${e.code}');
      debugPrint('[PAYMENT][ERROR] message: ${e.message}');
      if (e.code == 'permission-denied') {
        debugPrint(
            '[PAYMENT][ERROR] Firestore permission-denied. Check rules.');
      }
      Get.snackbar(StringConst.error.tr, '${e.code}. Try again!');
    } catch (e, stackTrace) {
      debugPrint('[PAYMENT][ERROR] $e');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar(StringConst.error.tr, '$e');
    }
  }

  Future<bool> _confirmPayOsPayment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDocId = await _resolveUserDocId();
    final idTour = tourModel?.idTour ?? '';
    final adult = bookingRequestController.adultNumb.value ?? 0;
    final children = bookingRequestController.childrenNumb.value ?? 0;
    final totalPrice = bookingRequestController.totalPrice.value ?? 0;
    final orderCode = DateTime.now().millisecondsSinceEpoch % 10000000000;
    final buyerName = [
      controller.firstNameConfirmController.text.trim(),
      controller.lastNameController.text.trim(),
    ].where((value) => value.isNotEmpty).join(' ');
    final buyerEmail = controller.emailController.text.trim().isNotEmpty
        ? controller.emailController.text.trim()
        : currentUser?.email ?? '';
    final buyerPhone = controller.phoneNumberController.text.trim();

    debugPrint('[PAYOS_FLUTTER] Payment button -> payOS flow');
    debugPrint('[PAYOS_FLUTTER] current uid: ${currentUser?.uid ?? ""}');
    debugPrint('[PAYOS_FLUTTER] current email: ${currentUser?.email ?? ""}');
    debugPrint('[PAYOS_FLUTTER] userModel document id: $userDocId');
    debugPrint('[PAYOS_FLUTTER] idTour: $idTour');
    debugPrint('[PAYOS_FLUTTER] totalPrice: $totalPrice');
    debugPrint('[PAYOS_FLUTTER] method: $statusPaymentMethod');

    if (userDocId.isEmpty || idTour.isEmpty || totalPrice <= 0) {
      Get.snackbar(StringConst.error.tr, 'Booking fail !!!');
      return false;
    }

    try {
      final paymentResponse = await PayOsPaymentService().createPayment(
        PayOsPaymentRequest(
          orderCode: orderCode,
          amount: totalPrice,
          description: 'Dat tour',
          buyerName: buyerName,
          buyerEmail: buyerEmail,
          buyerPhone: buyerPhone,
          idUser: userDocId,
          idTour: idTour,
        ),
      );

      if (!paymentResponse.success ||
          paymentResponse.checkoutUrl == null ||
          paymentResponse.checkoutUrl!.isEmpty) {
        debugPrint('[PAYOS_FLUTTER][ERROR] ${paymentResponse.message}');
        Get.snackbar(
          StringConst.error.tr,
          'Không kết nối được máy chủ thanh toán payOS. Dùng booking demo.',
        );
        return false;
      }

      final checkoutUri = Uri.parse(paymentResponse.checkoutUrl!);
      final opened = await launchUrl(
        checkoutUri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        debugPrint('[PAYOS_FLUTTER][ERROR] Cannot open checkoutUrl');
        Get.snackbar(
          StringConst.error.tr,
          'Không mở được trang thanh toán payOS. Dùng booking demo.',
        );
        return false;
      }

      await bookingController.bookingTour(
        userDocId,
        idTour,
        Timestamp.now(),
        'waiting',
        adult,
        children,
        totalPrice,
        paymentMethod: 'payos',
        paymentStatus: 'pending',
        orderCode: paymentResponse.orderCode ?? orderCode,
        paymentLinkId: paymentResponse.paymentLinkId,
      );

      debugPrint(
        '[PAYOS_FLUTTER] checkout opened and historyModel pending created',
      );
      Get.offAndToNamed(Routes.HISTORY_TOUR_SCREEN);
      return true;
    } catch (e, stackTrace) {
      debugPrint('[PAYOS_FLUTTER][ERROR] $e');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar(
        StringConst.error.tr,
        'Không kết nối được máy chủ thanh toán payOS. Dùng booking demo.',
      );
      return false;
    }
  }

  Future<void> _confirmStripePayment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDocId = await _resolveUserDocId();
    final idTour = tourModel?.idTour ?? '';
    final adult = bookingRequestController.adultNumb.value ?? 0;
    final children = bookingRequestController.childrenNumb.value ?? 0;
    final totalPrice = bookingRequestController.totalPrice.value ?? 0;
    final buyerEmail = controller.emailController.text.trim().isNotEmpty
        ? controller.emailController.text.trim()
        : currentUser?.email ?? '';

    debugPrint('[STRIPE_FLUTTER] Payment button -> Stripe flow');
    debugPrint('[STRIPE_FLUTTER] current uid: ${currentUser?.uid ?? ""}');
    debugPrint('[STRIPE_FLUTTER] current email: ${currentUser?.email ?? ""}');
    debugPrint('[STRIPE_FLUTTER] userModel document id: $userDocId');
    debugPrint('[STRIPE_FLUTTER] idTour: $idTour');
    debugPrint('[STRIPE_FLUTTER] totalPrice: $totalPrice');

    if (userDocId.isEmpty || idTour.isEmpty || totalPrice <= 0) {
      Get.snackbar(StringConst.error.tr, 'Booking fail !!!');
      return;
    }

    try {
      final paymentIntent = await StripePaymentService().createPaymentIntent(
        StripePaymentIntentRequest(
          amount: totalPrice,
          currency: 'vnd',
          description: 'Dat tour',
          buyerEmail: buyerEmail,
          idUser: userDocId,
          idTour: idTour,
        ),
      );

      if (!paymentIntent.success ||
          paymentIntent.clientSecret == null ||
          paymentIntent.clientSecret!.isEmpty) {
        debugPrint('[STRIPE_FLUTTER][ERROR] ${paymentIntent.message}');
        Get.snackbar(
          StringConst.error.tr,
          'Thanh toán thẻ chưa được cấu hình. Vui lòng dùng QR payOS.',
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Booking Travel',
          paymentIntentClientSecret: paymentIntent.clientSecret,
          style: appController.isDarkModeOn.value
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await bookingController.bookingTour(
        userDocId,
        idTour,
        Timestamp.now(),
        'waiting',
        adult,
        children,
        totalPrice,
        paymentMethod: 'stripe',
        paymentStatus: 'paid',
        paymentIntentId: paymentIntent.paymentIntentId,
      );

      debugPrint(
        '[STRIPE_FLUTTER] PaymentSheet success and historyModel created',
      );
      Get.offAndToNamed(Routes.HISTORY_TOUR_SCREEN);
    } on StripeException catch (e) {
      debugPrint('[STRIPE_FLUTTER][ERROR] ${e.error.localizedMessage}');
      Get.snackbar(
        StringConst.notification.tr,
        e.error.localizedMessage ??
            'Thanh toán thẻ chưa hoàn tất. Vui lòng thử lại.',
      );
    } catch (e, stackTrace) {
      debugPrint('[STRIPE_FLUTTER][ERROR] $e');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar(
        StringConst.error.tr,
        'Thanh toán thẻ chưa được cấu hình. Vui lòng dùng QR payOS.',
      );
    }
  }

  Future<String> _resolveUserDocId() async {
    final cachedUserDocId = homeController.userModel.value?.id ?? '';
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid ?? '';
    final email = currentUser?.email ?? '';

    if (cachedUserDocId.isNotEmpty) {
      return cachedUserDocId;
    }

    if (uid.isNotEmpty) {
      final uidDoc = await FirebaseFirestore.instance
          .collection('userModel')
          .doc(uid)
          .get();
      if (uidDoc.exists) {
        return uid;
      }
    }

    if (email.isNotEmpty) {
      final snapShot = await FirebaseFirestore.instance
          .collection('userModel')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snapShot.docs.isNotEmpty) {
        return snapShot.docs.first.id;
      }
    }

    return uid;
  }
}
