import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_clean_achitec/models/tour/tour_model.dart';
import 'package:doan_clean_achitec/routes/app_pages.dart';
import 'package:doan_clean_achitec/shared/services/chatbot_service.dart';
import 'package:doan_clean_achitec/shared/utils/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatbotOverlay extends StatefulWidget {
  final Widget child;

  const ChatbotOverlay({
    super.key,
    required this.child,
  });

  @override
  State<ChatbotOverlay> createState() => _ChatbotOverlayState();
}

class _ChatbotOverlayState extends State<ChatbotOverlay> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatbotService _chatbotService = ChatbotService();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          'Xin chào, mình là trợ lý Travel Booking. Bạn có thể hỏi về tour, đặt tour, thanh toán hoặc lịch sử booking.',
      isUser: false,
    ),
  ];

  bool _isOpen = false;
  bool _isThinking = false;
  double _buttonRight = 16;
  double _buttonBottom = 20;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _buildDraggableChatButton(context),
        if (_isOpen) _buildChatPanel(context),
      ],
    );
  }

  Widget _buildDraggableChatButton(BuildContext context) {
    final media = MediaQuery.of(context);
    return Positioned(
      right: _buttonRight,
      bottom: _buttonBottom + media.padding.bottom,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _buttonRight = (_buttonRight - details.delta.dx)
                .clamp(8.0, media.size.width - 72);
            _buttonBottom = (_buttonBottom - details.delta.dy)
                .clamp(8.0, media.size.height - 120);
          });
        },
        child: _buildChatButton(),
      ),
    );
  }

  Widget _buildChatButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => setState(() => _isOpen = !_isOpen),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            _isOpen ? Icons.close_rounded : Icons.chat_bubble_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildChatPanel(BuildContext context) {
    final media = MediaQuery.of(context);
    final panelWidth = media.size.width < 380 ? media.size.width - 32 : 340.0;
    final panelHeight =
        media.size.height < 680 ? media.size.height * 0.62 : 480.0;

    return Positioned(
      right: 16,
      bottom: 88 + media.padding.bottom,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: panelWidth,
          height: panelHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildMessages()),
              if (_isThinking) _buildThinking(),
              _buildInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThinking() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Travel Assistant đang trả lời...',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0EA5E9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.travel_explore_rounded, color: Color(0xFF0EA5E9)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Travel Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hỗ trợ tour và thanh toán',
                  style: TextStyle(color: Color(0xFFE0F2FE), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => _isOpen = false),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(14),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return Align(
          alignment:
              message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? const Color(0xFF0EA5E9)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color:
                        message.isUser ? Colors.white : const Color(0xFF111827),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
              if (!message.isUser && message.tour != null)
                _buildTourCard(message.tour!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTourCard(Map<String, dynamic> tour) {
    final name = tour['name']?.toString() ?? 'Tour du lịch';
    final location = tour['location']?.toString() ?? 'Đang cập nhật';
    final duration = tour['duration']?.toString() ?? 'Đang cập nhật';
    final price = _formatMoney(tour['price']);
    final image = tour['image']?.toString();

    return Container(
      width: 260,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: AppImage.widget(
              image,
              width: 260,
              height: 118,
              fit: BoxFit.cover,
              fallback: AppImage.noData,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$location • $duration',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFF0EA5E9),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openTourDetail(tour),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Xem chi tiết tour'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Nhập câu hỏi...',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF0EA5E9),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.send_rounded, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final value = _messageController.text.trim();
    if (value.isEmpty || _isThinking) return;

    setState(() {
      _messages.add(_ChatMessage(text: value, isUser: true));
      _isThinking = true;
      _messageController.clear();
    });

    _scrollToBottom();

    final response = await _chatbotService.ask(value);
    if (!mounted) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: response.answer,
          isUser: false,
          source: response.fromServer ? 'server' : 'local',
          tour: response.tour,
        ),
      );
      _isThinking = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openTourDetail(Map<String, dynamic> tour) {
    setState(() => _isOpen = false);
    Get.toNamed(
      Routes.TOUR_DETAILS,
      arguments: _tourModelFromChatData(tour),
    );
  }

  TourModel _tourModelFromChatData(Map<String, dynamic> tour) {
    final now = DateTime.now();
    final image = tour['image']?.toString() ?? AppImage.noData;
    final price = double.tryParse(tour['price']?.toString() ?? '') ?? 0;

    return TourModel(
      idTour: tour['id']?.toString(),
      nameTour: tour['name']?.toString() ?? 'Tour du lịch',
      description: tour['description']?.toString() ??
          'Thông tin tour được lấy từ dữ liệu chatbot của project.',
      idCity: tour['cityId']?.toString(),
      startDate: Timestamp.fromDate(now),
      endDate: Timestamp.fromDate(now.add(const Duration(days: 3))),
      price: price,
      images: [image],
      duration: tour['duration']?.toString(),
      accommodation: 'Khách sạn tiêu chuẩn',
      itinerary: const [
        'Ngày 1 / Khởi hành và tham quan điểm nổi bật',
        'Ngày 2 / Check-in các địa điểm nổi tiếng',
        'Ngày 3 / Mua đặc sản và trở về',
      ],
      includedServices: const [
        'Xe đưa đón',
        'Khách sạn',
        'Vé tham quan',
        'Hướng dẫn viên',
      ],
      excludedServices: const ['Chi phí cá nhân'],
      reviews: 120,
      rating: 4.8,
      active: true,
      status: 'chatbot',
      specialOffers: const ['Ưu đãi demo từ chatbot'],
      type: 1,
      imgqr: image,
      location: tour['location']?.toString(),
      isFavourite: false,
    );
  }

  String _formatMoney(dynamic value) {
    final amount = num.tryParse(value?.toString() ?? '');
    if (amount == null) return 'Đang cập nhật';
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]}.',
        )} VND';
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final String? source;
  final Map<String, dynamic>? tour;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.source,
    this.tour,
  });
}
