import 'dart:convert';

import 'package:doan_clean_achitec/shared/services/payos_payment_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String stripeBackendBaseUrl = String.fromEnvironment(
  'STRIPE_BACKEND_URL',
  defaultValue: 'http://192.168.1.170:3000',
);

class StripePaymentIntentRequest {
  const StripePaymentIntentRequest({
    required this.amount,
    required this.currency,
    required this.description,
    required this.buyerEmail,
    required this.idUser,
    required this.idTour,
  });

  final num amount;
  final String currency;
  final String description;
  final String buyerEmail;
  final String idUser;
  final String idTour;

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'description': description,
      'buyerEmail': buyerEmail,
      'idUser': idUser,
      'idTour': idTour,
    };
  }
}

class StripePaymentIntentResponse {
  const StripePaymentIntentResponse({
    required this.success,
    this.clientSecret,
    this.paymentIntentId,
    this.amount,
    this.currency,
    this.message,
  });

  final bool success;
  final String? clientSecret;
  final String? paymentIntentId;
  final num? amount;
  final String? currency;
  final String? message;

  factory StripePaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return StripePaymentIntentResponse(
      success: json['success'] == true,
      clientSecret: json['clientSecret']?.toString(),
      paymentIntentId: json['paymentIntentId']?.toString(),
      amount: num.tryParse(json['amount']?.toString() ?? ''),
      currency: json['currency']?.toString(),
      message: json['message']?.toString(),
    );
  }
}

class StripePaymentService {
  StripePaymentService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? stripeBackendBaseUrl).replaceAll(
          RegExp(r'/$'),
          '',
        );

  final http.Client _client;
  final String _baseUrl;

  Future<StripePaymentIntentResponse> createPaymentIntent(
    StripePaymentIntentRequest request,
  ) async {
    final uri = Uri.parse('$_baseUrl/create-stripe-payment-intent');
    final requestBody = request.toJson();

    debugPrint('[STRIPE_FLUTTER] backendUrl: $_baseUrl');
    debugPrint('[STRIPE_FLUTTER] request url: $uri');
    debugPrint('[STRIPE_FLUTTER] request body: $requestBody');

    final response = await _client
        .post(
          uri,
          headers: const {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 20));

    debugPrint('[STRIPE_FLUTTER] response status: ${response.statusCode}');

    final decoded = jsonDecode(response.body);
    final responseBody = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'success': false, 'message': 'Invalid response'};

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
        '[STRIPE_FLUTTER][ERROR] ${responseBody['message'] ?? response.body}',
      );
      return StripePaymentIntentResponse(
        success: false,
        message: responseBody['message']?.toString() ??
            'Stripe backend returned ${response.statusCode}',
      );
    }

    final paymentResponse =
        StripePaymentIntentResponse.fromJson(responseBody);
    debugPrint('[STRIPE_FLUTTER] success: ${paymentResponse.success}');
    debugPrint(
      '[STRIPE_FLUTTER] clientSecret: '
      '${paymentResponse.clientSecret?.isNotEmpty == true}',
    );
    debugPrint(
      '[STRIPE_FLUTTER] paymentIntentId: '
      '${paymentResponse.paymentIntentId ?? ''}',
    );

    return paymentResponse;
  }
}
