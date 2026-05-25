import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String chatbotBackendBaseUrl = String.fromEnvironment(
  'CHATBOT_BACKEND_URL',
  defaultValue: 'http://192.168.1.170:5055',
);

class ChatbotResponse {
  final String answer;
  final bool fromServer;
  final bool inScope;
  final String? source;
  final Map<String, dynamic>? tour;

  const ChatbotResponse({
    required this.answer,
    required this.fromServer,
    required this.inScope,
    this.source,
    this.tour,
  });
}

class ChatbotService {
  ChatbotService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? chatbotBackendBaseUrl).replaceAll(
          RegExp(r'/$'),
          '',
        );

  final http.Client _client;
  final String _baseUrl;

  Map<String, dynamic>? _knowledge;

  Future<ChatbotResponse> ask(String message) async {
    final serverResponse = await _askServer(message);
    if (serverResponse != null) return serverResponse;

    final knowledge = await _loadKnowledge();
    return _answerFromLocalKnowledge(message, knowledge);
  }

  Future<ChatbotResponse?> _askServer(String message) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/chat'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic> || decoded['success'] != true) {
        return null;
      }

      return ChatbotResponse(
        answer: decoded['answer']?.toString() ??
            'Mình chưa tìm thấy câu trả lời phù hợp.',
        fromServer: true,
        inScope: decoded['inScope'] == true,
        source: decoded['source']?.toString(),
        tour: decoded['tour'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(decoded['tour'] as Map)
            : null,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _loadKnowledge() async {
    if (_knowledge != null) return _knowledge!;

    final raw = await rootBundle.loadString(
      'assets/chatbot/chatbot_knowledge_base.json',
    );
    final decoded = jsonDecode(raw);
    _knowledge = decoded is Map<String, dynamic> ? decoded : {};
    return _knowledge!;
  }

  ChatbotResponse _answerFromLocalKnowledge(
    String input,
    Map<String, dynamic> knowledge,
  ) {
    final message = _normalize(input);
    final scopeAnswer = knowledge['scope']?['outOfScopeAnswer']?.toString() ??
        'Mình chỉ hỗ trợ các câu hỏi về app Travel Booking.';

    if (!_isInScope(message)) {
      return ChatbotResponse(
        answer: scopeAnswer,
        fromServer: false,
        inScope: false,
        source: 'local/scope',
        tour: null,
      );
    }

    final tour = _matchTour(message, knowledge);
    if (tour != null) {
      final name = tour['name']?.toString() ?? 'Tour';
      final duration = tour['duration']?.toString() ?? 'đang cập nhật';
      final location = tour['location']?.toString() ?? 'đang cập nhật';
      final price = _money(tour['price']);

      return ChatbotResponse(
        answer:
            '$name ở $location, thời lượng $duration, giá khoảng $price. Bạn có thể bấm Book Tour để đặt.',
        fromServer: false,
        inScope: true,
        source: 'local/tour',
        tour: tour,
      );
    }

    final city = _matchByName(message, knowledge['cities']);
    if (city != null) {
      return ChatbotResponse(
        answer: '${city['name']}: ${city['description'] ?? 'Chưa có mô tả.'}',
        fromServer: false,
        inScope: true,
        source: 'local/city',
      );
    }

    if (_containsAny(message, ['dat', 'booking', 'book'])) {
      return const ChatbotResponse(
        answer:
            'Bạn mở chi tiết tour, bấm Book Tour, chọn số người, kiểm tra tổng tiền rồi chọn phương thức thanh toán.',
        fromServer: false,
        inScope: true,
        source: 'local/booking',
      );
    }

    if (_containsAny(
        message, ['thanh toan', 'payos', 'qr', 'banking', 'visa', 'stripe'])) {
      return const ChatbotResponse(
        answer:
            'App hỗ trợ QR/banking qua payOS và Visa test mode qua Stripe. Nếu lỗi kết nối, hãy kiểm tra backend local, IP LAN và endpoint /health.',
        fromServer: false,
        inScope: true,
        source: 'local/payment',
      );
    }

    if (_containsAny(message, ['history', 'lich su'])) {
      return const ChatbotResponse(
        answer:
            'Bạn mở tab History để xem booking đang chờ, sắp diễn ra, đang diễn ra, hoàn thành hoặc đã hủy.',
        fromServer: false,
        inScope: true,
        source: 'local/history',
      );
    }

    return const ChatbotResponse(
      answer:
          'Bạn có thể hỏi mình về tour, điểm đến, đặt tour, thanh toán, lịch sử booking hoặc yêu thích.',
      fromServer: false,
      inScope: true,
      source: 'local/general',
    );
  }

  Map<String, dynamic>? _matchByName(String message, dynamic items) {
    if (items is! List) return null;
    for (final item in items) {
      if (item is! Map<String, dynamic>) continue;
      final name = _normalize(item['name']?.toString() ?? '');
      final location = _normalize(item['location']?.toString() ?? '');
      if (name.isNotEmpty && message.contains(name)) return item;
      if (location.isNotEmpty && message.contains(location)) return item;
    }
    return null;
  }

  Map<String, dynamic>? _matchTour(
    String message,
    Map<String, dynamic> knowledge,
  ) {
    final tours = knowledge['tours'];
    final cities = knowledge['cities'];
    if (tours is! List) return null;

    final cityById = <String, Map<String, dynamic>>{};
    if (cities is List) {
      for (final city in cities) {
        if (city is Map<String, dynamic>) {
          final id = city['id']?.toString();
          if (id != null) cityById[id] = city;
        }
      }
    }

    for (final item in tours) {
      if (item is! Map<String, dynamic>) continue;
      final name = _normalize(item['name']?.toString() ?? '');
      final location = _normalize(item['location']?.toString() ?? '');
      final city = cityById[item['cityId']?.toString()];
      final cityName = _normalize(city?['name']?.toString() ?? '');
      if (name.isNotEmpty && message.contains(name)) return item;
      if (location.isNotEmpty && message.contains(location)) return item;
      if (cityName.isNotEmpty && message.contains(cityName)) return item;
    }
    return null;
  }

  bool _isInScope(String message) {
    return _containsAny(message, [
      'tour',
      'du lich',
      'diem den',
      'dat tour',
      'booking',
      'book',
      'thanh toan',
      'payos',
      'qr',
      'banking',
      'visa',
      'stripe',
      'history',
      'lich su',
      'yeu thich',
      'favorite',
      'firebase',
      'firestore',
      'database',
      'da lat',
      'da nang',
      'nha trang',
      'phu quoc',
      'hoi an',
      'ha noi',
      'hue',
      'sapa',
    ]);
  }

  bool _containsAny(String message, List<String> keywords) {
    return keywords.any(message.contains);
  }

  String _normalize(String value) {
    const accents = {
      'à': 'a',
      'á': 'a',
      'ạ': 'a',
      'ả': 'a',
      'ã': 'a',
      'â': 'a',
      'ầ': 'a',
      'ấ': 'a',
      'ậ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ă': 'a',
      'ằ': 'a',
      'ắ': 'a',
      'ặ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'è': 'e',
      'é': 'e',
      'ẹ': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ê': 'e',
      'ề': 'e',
      'ế': 'e',
      'ệ': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ì': 'i',
      'í': 'i',
      'ị': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ò': 'o',
      'ó': 'o',
      'ọ': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ô': 'o',
      'ồ': 'o',
      'ố': 'o',
      'ộ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ơ': 'o',
      'ờ': 'o',
      'ớ': 'o',
      'ợ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ù': 'u',
      'ú': 'u',
      'ụ': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ư': 'u',
      'ừ': 'u',
      'ứ': 'u',
      'ự': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ỳ': 'y',
      'ý': 'y',
      'ỵ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'đ': 'd',
    };

    final lower = value.toLowerCase();
    final buffer = StringBuffer();
    for (final codeUnit in lower.runes) {
      final char = String.fromCharCode(codeUnit);
      buffer.write(accents[char] ?? char);
    }
    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _money(dynamic value) {
    final amount = num.tryParse(value?.toString() ?? '');
    if (amount == null) return 'đang cập nhật';
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]}.',
        )} VND';
  }
}
