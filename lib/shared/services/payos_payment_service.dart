import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String payOsBackendBaseUrl = String.fromEnvironment(
  'PAYOS_BACKEND_URL',
  // IP LAN may dev de test local backend payOS.
  // Khong nen commit/push gia tri nay neu nhom chua thong nhat.
  defaultValue: 'http://192.168.1.170:3000',
);

class PayOsPaymentRequest {
  const PayOsPaymentRequest({
    required this.orderCode,
    required this.amount,
    required this.description,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.idUser,
    required this.idTour,
  });

  final int orderCode;
  final num amount;
  final String description;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final String idUser;
  final String idTour;

  Map<String, dynamic> toJson() {
    return {
      'orderCode': orderCode,
      'amount': amount,
      'description': description,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'idUser': idUser,
      'idTour': idTour,
    };
  }
}

class PayOsPaymentResponse {
  const PayOsPaymentResponse({
    required this.success,
    this.checkoutUrl,
    this.paymentLinkId,
    this.orderCode,
    this.message,
  });

  final bool success;
  final String? checkoutUrl;
  final String? paymentLinkId;
  final int? orderCode;
  final String? message;

  factory PayOsPaymentResponse.fromJson(Map<String, dynamic> json) {
    return PayOsPaymentResponse(
      success: json['success'] == true,
      checkoutUrl: json['checkoutUrl']?.toString(),
      paymentLinkId: json['paymentLinkId']?.toString(),
      orderCode: int.tryParse(json['orderCode']?.toString() ?? ''),
      message: json['message']?.toString(),
    );
  }
}

class PayOsPaymentService {
  PayOsPaymentService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? payOsBackendBaseUrl).replaceAll(
          RegExp(r'/$'),
          '',
        );

  final http.Client _client;
  final String _baseUrl;

  Future<PayOsPaymentResponse> createPayment(
    PayOsPaymentRequest request,
  ) async {
    final uri = Uri.parse('$_baseUrl/create-payos-payment');
    final requestBody = request.toJson();

    debugPrint('[PAYOS_FLUTTER] backendUrl: $_baseUrl');
    debugPrint('[PAYOS_FLUTTER] request url: $uri');
    debugPrint('[PAYOS_FLUTTER] request body: $requestBody');

    final response = await _client
        .post(
          uri,
          headers: const {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 20));

    debugPrint('[PAYOS_FLUTTER] response status: ${response.statusCode}');

    final decoded = jsonDecode(response.body);
    final responseBody = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'success': false, 'message': 'Invalid response'};

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
        '[PAYOS_FLUTTER][ERROR] ${responseBody['message'] ?? response.body}',
      );
      return PayOsPaymentResponse(
        success: false,
        message: responseBody['message']?.toString() ??
            'payOS backend returned ${response.statusCode}',
      );
    }

    final paymentResponse = PayOsPaymentResponse.fromJson(responseBody);
    debugPrint('[PAYOS_FLUTTER] success: ${paymentResponse.success}');
    debugPrint(
      '[PAYOS_FLUTTER] checkoutUrl: '
      '${paymentResponse.checkoutUrl?.isNotEmpty == true}',
    );
    debugPrint(
      '[PAYOS_FLUTTER] paymentLinkId: ${paymentResponse.paymentLinkId ?? ''}',
    );

    return paymentResponse;
  }
}
