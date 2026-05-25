import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_clean_achitec/modules/history_tour/history_tour.dart';
import 'package:doan_clean_achitec/shared/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  final _db = FirebaseFirestore.instance;

  final HistoryTourController historyTourController =
      Get.put(HistoryTourController());

  RxString selectedValue = 'Thành phố Hồ Chí Minh'.obs;

  String convertToDDMM(String inputDate) {
    final parts = inputDate.split('-');
    if (parts.length == 3) {
      final month = parts[1];
      final day = parts[2];
      return '$day/$month';
    }
    return inputDate;
  }

  Future<void> bookingTour(
    String userId,
    String tourId,
    Timestamp bookingDate,
    String status,
    double adult,
    double children,
    double totalPrice, {
    String? paymentMethod,
    String? paymentStatus,
    int? orderCode,
    String? paymentLinkId,
    String? paymentIntentId,
  }) async {
    debugPrint('[PAYMENT] bookingTour');
    debugPrint('[PAYMENT] userModel document id: $userId');
    debugPrint('[PAYMENT] idTour: $tourId');
    debugPrint('[PAYMENT] adult: $adult');
    debugPrint('[PAYMENT] children: $children');
    debugPrint('[PAYMENT] totalPrice: $totalPrice');
    debugPrint('[PAYMENT] status: $status');

    if (userId.isEmpty || tourId.isEmpty) {
      Get.snackbar(StringConst.error, 'Booking fail !!!');
    } else {
      try {
        final bookingData = {
          'idUser': userId,
          'idTour': tourId,
          'isActive': true,
          'bookingDate': bookingDate,
          'status': status,
          'adult': adult,
          'children': children,
          'totalPrice': totalPrice,
        };

        if (paymentMethod != null && paymentMethod.isNotEmpty) {
          bookingData['paymentMethod'] = paymentMethod;
        }
        if (paymentStatus != null && paymentStatus.isNotEmpty) {
          bookingData['paymentStatus'] = paymentStatus;
        }
        if (orderCode != null) {
          bookingData['orderCode'] = orderCode;
        }
        if (paymentLinkId != null && paymentLinkId.isNotEmpty) {
          bookingData['paymentLinkId'] = paymentLinkId;
        }
        if (paymentIntentId != null && paymentIntentId.isNotEmpty) {
          bookingData['paymentIntentId'] = paymentIntentId;
        }

        final docRef = await _db.collection('historyModel').add(bookingData);
        debugPrint('[PAYMENT] historyModel created: ${docRef.path}');
        Get.snackbar(
            StringConst.success.tr, StringConst.bookingSuccessfully.tr);

        await historyTourController.getAllTourModelData();
      } on FirebaseException catch (e, stackTrace) {
        debugPrint('[PAYMENT][ERROR] historyModel write failed');
        debugPrint('FirebaseException code: ${e.code}');
        debugPrint('message: ${e.message}');
        debugPrintStack(stackTrace: stackTrace);
        if (e.code == 'permission-denied') {
          debugPrint('[PAYMENT][ERROR] Firestore permission-denied.');
        }
        Get.snackbar(StringConst.error.tr, '${e.code}. Try again!');
        rethrow;
      } catch (e, stackTrace) {
        debugPrint('[PAYMENT][ERROR] historyModel write failed: $e');
        debugPrintStack(stackTrace: stackTrace);
        Get.snackbar(StringConst.error.tr, '$e');
        rethrow;
      }
    }
  }

  // format datetime
  Timestamp formatDateTime(String startDateText) {
    DateTime startDate;

    try {
      final inputFormat = DateFormat('dd MMM yyyy');
      startDate = inputFormat.parse(startDateText);
    } catch (e) {
      startDate = DateTime.now();
    }
    return Timestamp.fromDate(startDate);
  }
}
