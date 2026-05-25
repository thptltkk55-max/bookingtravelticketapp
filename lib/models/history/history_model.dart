import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String? id;
  final String? idUser;
  final String? idTour;
  final bool isActive;
  bool? isCheckUserParti;
  final Timestamp? bookingDate;
  String? status;
  double? adult;
  double? children;
  double? totalPrice;
  String? paymentMethod;
  String? paymentStatus;
  dynamic orderCode;
  String? paymentLinkId;
  String? paymentIntentId;

  HistoryModel({
    this.id,
    this.idUser,
    this.idTour,
    this.bookingDate,
    this.status,
    this.adult,
    this.children,
    this.totalPrice,
    this.isCheckUserParti,
    this.paymentMethod,
    this.paymentStatus,
    this.orderCode,
    this.paymentLinkId,
    this.paymentIntentId,
    required this.isActive,
  });

  factory HistoryModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final json = document.data() ?? {};
    return HistoryModel(
      id: document.id,
      idUser: json['idUser'],
      idTour: json['idTour'],
      bookingDate:
          json['bookingDate'] != null ? json['bookingDate'] as Timestamp : null,
      status: json['status'],
      adult: _toDouble(json['adult']),
      children: _toDouble(json['children']),
      totalPrice: _toDouble(json['totalPrice']),
      isActive: json['isActive'] ?? true,
      isCheckUserParti: json['isCheckUserParti'] ?? false,
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      orderCode: json['orderCode'],
      paymentLinkId: json['paymentLinkId'],
      paymentIntentId: json['paymentIntentId'],
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUser': idUser,
      'idTour': idTour,
      'bookingDate': bookingDate,
      'status': status,
      'isActive': isActive,
      'adult': adult,
      'children': children,
      'totalPrice': totalPrice,
      'isCheckUserParti': isCheckUserParti,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderCode': orderCode,
      'paymentLinkId': paymentLinkId,
      'paymentIntentId': paymentIntentId,
    };
  }
}
