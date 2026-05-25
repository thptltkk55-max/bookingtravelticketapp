import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SeedFirestore {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> seedAll() async {
    debugPrint('[SEED] Start all');

    await _seedCollection('cityModel', _seedCities);
    await _seedCollection('tourModel', _seedTours);
    await _seedCollection('searchTour', _seedSearchTour);
    await _seedCollection('videos', _seedVideos);
    await _seedCollection('historyModel', _seedHistory);
    await seedCurrentUser();
    await _verifySeed();

    debugPrint('[SEED] All done');
  }

  static Future<void> _seedCollection(
    String collectionName,
    int Function(WriteBatch batch) fillBatch,
  ) async {
    debugPrint('[SEED] Start $collectionName');

    try {
      final batch = _db.batch();
      final count = fillBatch(batch);
      await batch.commit();
      debugPrint('[SEED] Done $collectionName: $count docs');
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('[SEED][ERROR] $collectionName');
      debugPrint('FirebaseException code: ${e.code}');
      debugPrint('message: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);
    } catch (e, stackTrace) {
      debugPrint('[SEED][ERROR] $collectionName');
      debugPrint('message: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static int _seedCities(WriteBatch batch) {
    final cities = [
      {
        'docId': 'city_01',
        'idCity': 'city_01',
        'nameCity': 'Đà Lạt',
        'descriptionCity':
            'Thành phố ngàn hoa, khí hậu mát mẻ, nổi tiếng với hồ Xuân Hương, chợ đêm và nhiều điểm check-in.',
        'imageCity': 'assets/images/x2/city_1.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_1.jpg',
          'assets/images/x2/city_2.jpg',
          'assets/images/x2/city_3.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_02',
        'idCity': 'city_02',
        'nameCity': 'Đà Nẵng',
        'descriptionCity':
            'Thành phố biển hiện đại, nổi tiếng với cầu Rồng, biển Mỹ Khê và Bà Nà Hills.',
        'imageCity': 'assets/images/x2/city_2.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_2.jpg',
          'assets/images/x2/city_3.jpg',
          'assets/images/x2/city_4.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_03',
        'idCity': 'city_03',
        'nameCity': 'Nha Trang',
        'descriptionCity':
            'Thành phố biển nổi tiếng với đảo đẹp, hải sản tươi ngon và nhiều hoạt động du lịch biển.',
        'imageCity': 'assets/images/x2/city_3.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_3.jpg',
          'assets/images/x2/city_4.jpg',
          'assets/images/x2/city_5.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_04',
        'idCity': 'city_04',
        'nameCity': 'Phú Quốc',
        'descriptionCity':
            'Đảo ngọc với biển xanh, cát trắng, resort nghỉ dưỡng và nhiều điểm tham quan nổi tiếng.',
        'imageCity': 'assets/images/x2/city_4.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_4.jpg',
          'assets/images/x2/city_5.jpg',
          'assets/images/x2/city_6.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_05',
        'idCity': 'city_05',
        'nameCity': 'Hội An',
        'descriptionCity':
            'Phố cổ yên bình, nổi bật với đèn lồng, kiến trúc cổ và văn hóa truyền thống.',
        'imageCity': 'assets/images/x2/city_5.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_5.jpg',
          'assets/images/x2/city_6.jpg',
          'assets/images/x2/city_7.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_06',
        'idCity': 'city_06',
        'nameCity': 'Hà Nội',
        'descriptionCity':
            'Thủ đô nghìn năm văn hiến với hồ Gươm, phố cổ, lăng Bác và nhiều món ăn đặc trưng.',
        'imageCity': 'assets/images/x2/city_6.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_6.jpg',
          'assets/images/x2/city_7.jpg',
          'assets/images/x2/city_8.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_07',
        'idCity': 'city_07',
        'nameCity': 'Huế',
        'descriptionCity':
            'Cố đô với Đại Nội, lăng tẩm, sông Hương và nét văn hóa cung đình đặc sắc.',
        'imageCity': 'assets/images/x2/city_7.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_7.jpg',
          'assets/images/x2/city_8.jpg',
          'assets/images/x2/city_1.jpg',
        ],
        'isFavourite': false,
      },
      {
        'docId': 'city_08',
        'idCity': 'city_08',
        'nameCity': 'Sapa',
        'descriptionCity':
            'Thị trấn vùng cao nổi tiếng với ruộng bậc thang, núi Fansipan và bản làng dân tộc.',
        'imageCity': 'assets/images/x2/city_8.jpg',
        'idCountry': 'VN',
        'listArt': [
          'assets/images/x2/city_8.jpg',
          'assets/images/x2/city_1.jpg',
          'assets/images/x2/city_2.jpg',
        ],
        'isFavourite': false,
      },
    ];

    for (final city in cities) {
      final docId = city['docId'] as String;
      final data = Map<String, dynamic>.from(city);
      data.remove('docId');

      batch.set(
        _db.collection('cityModel').doc(docId),
        data,
        SetOptions(merge: true),
      );
    }

    return cities.length;
  }

  static int _seedTours(WriteBatch batch) {
    final now = DateTime.now();

    final tours = [
      _tour(
        docId: 'tour_01',
        nameTour: 'Tour Đà Lạt 3 ngày 2 đêm',
        description:
            'Khám phá Đà Lạt với hồ Xuân Hương, chợ đêm, thung lũng Tình Yêu và các điểm check-in nổi tiếng.',
        idCity: 'city_01',
        price: 2500000,
        images: [
          'assets/images/x2/des1.jpg',
          'assets/images/x2/des2.png',
          'assets/images/x2/des3.jpg',
        ],
        duration: '3 ngày 2 đêm',
        accommodation: 'Khách sạn 3 sao',
        reviews: 120,
        rating: 4.8,
        status: 'sale',
        location: 'Đà Lạt, Lâm Đồng',
        imgqr: 'assets/images/x2/des1.jpg',
        start: now,
        end: now.add(const Duration(days: 3)),
      ),
      _tour(
        docId: 'tour_02',
        nameTour: 'Tour Đà Nẵng - Hội An 4 ngày 3 đêm',
        description:
            'Trải nghiệm biển Mỹ Khê, cầu Rồng, Bà Nà Hills và phố cổ Hội An về đêm.',
        idCity: 'city_02',
        price: 3200000,
        images: [
          'assets/images/x2/des4.jpg',
          'assets/images/x2/des5.jpg',
          'assets/images/x2/des6.jpg',
        ],
        duration: '4 ngày 3 đêm',
        accommodation: 'Khách sạn 4 sao',
        reviews: 95,
        rating: 4.7,
        status: 'new',
        location: 'Đà Nẵng',
        imgqr: 'assets/images/x2/des4.jpg',
        start: now,
        end: now.add(const Duration(days: 4)),
      ),
      _tour(
        docId: 'tour_03',
        nameTour: 'Tour Phú Quốc nghỉ dưỡng 3 ngày 2 đêm',
        description:
            'Nghỉ dưỡng tại đảo ngọc, tham quan biển xanh, cáp treo Hòn Thơm và thưởng thức hải sản.',
        idCity: 'city_04',
        price: 4500000,
        images: [
          'assets/images/x2/des7.jpg',
          'assets/images/x2/des8.jpg',
          'assets/images/x2/des9.png',
        ],
        duration: '3 ngày 2 đêm',
        accommodation: 'Resort 4 sao',
        reviews: 150,
        rating: 4.9,
        status: 'popular',
        location: 'Phú Quốc, Kiên Giang',
        imgqr: 'assets/images/x2/des7.jpg',
        start: now,
        end: now.add(const Duration(days: 3)),
      ),
      _tour(
        docId: 'tour_04',
        nameTour: 'Tour Nha Trang biển đảo 3 ngày 2 đêm',
        description:
            'Khám phá biển đảo Nha Trang, VinWonders, chợ đêm và các món hải sản đặc trưng.',
        idCity: 'city_03',
        price: 2900000,
        images: [
          'assets/images/x2/des2.png',
          'assets/images/x2/des3.jpg',
          'assets/images/x2/des4.jpg',
        ],
        duration: '3 ngày 2 đêm',
        accommodation: 'Khách sạn gần biển',
        reviews: 88,
        rating: 4.6,
        status: 'sale',
        location: 'Nha Trang, Khánh Hòa',
        imgqr: 'assets/images/x2/des2.png',
        start: now,
        end: now.add(const Duration(days: 3)),
      ),
      _tour(
        docId: 'tour_05',
        nameTour: 'Tour Hội An 2 ngày 1 đêm',
        description:
            'Dạo phố cổ Hội An, thả đèn hoa đăng, thưởng thức ẩm thực địa phương và tham quan làng nghề.',
        idCity: 'city_05',
        price: 1800000,
        images: [
          'assets/images/x2/des5.jpg',
          'assets/images/x2/des6.jpg',
          'assets/images/x2/des7.jpg',
        ],
        duration: '2 ngày 1 đêm',
        accommodation: 'Homestay phố cổ',
        reviews: 75,
        rating: 4.5,
        status: 'new',
        location: 'Hội An, Quảng Nam',
        imgqr: 'assets/images/x2/des5.jpg',
        start: now,
        end: now.add(const Duration(days: 2)),
      ),
      _tour(
        docId: 'tour_06',
        nameTour: 'Tour Hà Nội - Ninh Bình 3 ngày 2 đêm',
        description:
            'Tham quan phố cổ Hà Nội, hồ Gươm, Tràng An, Bái Đính và cảnh đẹp non nước Ninh Bình.',
        idCity: 'city_06',
        price: 3100000,
        images: [
          'assets/images/x2/des8.jpg',
          'assets/images/x2/des9.png',
          'assets/images/x2/des1.jpg',
        ],
        duration: '3 ngày 2 đêm',
        accommodation: 'Khách sạn 3 sao',
        reviews: 132,
        rating: 4.8,
        status: 'popular',
        location: 'Hà Nội',
        imgqr: 'assets/images/x2/des8.jpg',
        start: now,
        end: now.add(const Duration(days: 3)),
      ),
      _tour(
        docId: 'tour_07',
        nameTour: 'Tour Huế di sản 2 ngày 1 đêm',
        description:
            'Tham quan Đại Nội, lăng vua, chùa Thiên Mụ và thưởng thức ẩm thực cung đình Huế.',
        idCity: 'city_07',
        price: 1900000,
        images: [
          'assets/images/x2/des3.jpg',
          'assets/images/x2/des4.jpg',
          'assets/images/x2/des5.jpg',
        ],
        duration: '2 ngày 1 đêm',
        accommodation: 'Khách sạn trung tâm',
        reviews: 65,
        rating: 4.4,
        status: 'sale',
        location: 'Huế, Thừa Thiên Huế',
        imgqr: 'assets/images/x2/des3.jpg',
        start: now,
        end: now.add(const Duration(days: 2)),
      ),
      _tour(
        docId: 'tour_08',
        nameTour: 'Tour Sapa - Fansipan 3 ngày 2 đêm',
        description:
            'Khám phá Sapa, bản Cát Cát, núi Hàm Rồng, ruộng bậc thang và chinh phục Fansipan.',
        idCity: 'city_08',
        price: 3600000,
        images: [
          'assets/images/x2/des6.jpg',
          'assets/images/x2/des7.jpg',
          'assets/images/x2/des8.jpg',
        ],
        duration: '3 ngày 2 đêm',
        accommodation: 'Khách sạn view núi',
        reviews: 110,
        rating: 4.7,
        status: 'popular',
        location: 'Sapa, Lào Cai',
        imgqr: 'assets/images/x2/des6.jpg',
        start: now,
        end: now.add(const Duration(days: 3)),
      ),
    ];

    for (final tour in tours) {
      final docId = tour['docId'] as String;
      final data = Map<String, dynamic>.from(tour);
      data.remove('docId');

      batch.set(
        _db.collection('tourModel').doc(docId),
        data,
        SetOptions(merge: true),
      );
    }

    return tours.length;
  }

  static Map<String, dynamic> _tour({
    required String docId,
    required String nameTour,
    required String description,
    required String idCity,
    required int price,
    required List<String> images,
    required String duration,
    required String accommodation,
    required int reviews,
    required double rating,
    required String status,
    required String location,
    required String imgqr,
    required DateTime start,
    required DateTime end,
  }) {
    return {
      'docId': docId,
      'nameTour': nameTour,
      'description': description,
      'idCity': idCity,
      'startDate': Timestamp.fromDate(start),
      'endDate': Timestamp.fromDate(end),
      'price': price,
      'images': images,
      'duration': duration,
      'accommodation': accommodation,
      'itinerary': [
        'Ngày 1: Khởi hành và tham quan điểm nổi bật',
        'Ngày 2: Check-in các địa điểm nổi tiếng',
        'Ngày 3: Mua đặc sản và trở về',
      ],
      'includedServices': [
        'Xe đưa đón',
        'Khách sạn',
        'Vé tham quan',
        'Hướng dẫn viên',
      ],
      'excludedServices': [
        'Chi phí cá nhân',
        'Ăn uống ngoài chương trình',
      ],
      'reviews': reviews,
      'rating': rating,
      'active': true,
      'status': status,
      'specialOffers': [
        'Ưu đãi đặc biệt cho khách đặt tour sớm',
      ],
      'type': 1,
      'imgqr': imgqr,
      'location': location,
      'isFavourite': false,
    };
  }

  static int _seedSearchTour(WriteBatch batch) {
    final keywords = [
      {'docId': 'da_lat', 'value': 'Đà Lạt', 'count': 10},
      {'docId': 'da_nang', 'value': 'Đà Nẵng', 'count': 9},
      {'docId': 'phu_quoc', 'value': 'Phú Quốc', 'count': 8},
      {'docId': 'nha_trang', 'value': 'Nha Trang', 'count': 7},
      {'docId': 'hoi_an', 'value': 'Hội An', 'count': 6},
      {'docId': 'sapa', 'value': 'Sapa', 'count': 5},
      {'docId': 'bien', 'value': 'Biển', 'count': 4},
      {'docId': 'tour_gia_re', 'value': 'Tour giá rẻ', 'count': 3},
    ];

    for (final item in keywords) {
      final docId = item['docId'] as String;
      final data = Map<String, dynamic>.from(item);
      data.remove('docId');

      batch.set(
        _db.collection('searchTour').doc(docId),
        data,
        SetOptions(merge: true),
      );
    }

    return keywords.length;
  }

  static int _seedVideos(WriteBatch batch) {
    final videos = [
      {
        'docId': 'video_01',
        'username': 'Hoàng Quốc',
        'uid': _auth.currentUser?.uid ?? 'demo_user',
        'id': 'video_01',
        'likes': [],
        'commentCount': 0,
        'shareCount': 0,
        'songName': 'Travel Music',
        'caption': 'Khám phá Đà Lạt cùng Booking Travel App',
        'videoUrl': 'assets/videos/travel_1.mp4',
        'thumbnail': 'assets/images/x2/des1.jpg',
        'profilePhoto': 'assets/images/x2/img_user_profile_non.png',
      },
      {
        'docId': 'video_02',
        'username': 'Hoàng Quốc',
        'uid': _auth.currentUser?.uid ?? 'demo_user',
        'id': 'video_02',
        'likes': [],
        'commentCount': 0,
        'shareCount': 0,
        'songName': 'Summer Travel',
        'caption': 'Biển xanh Phú Quốc và hành trình nghỉ dưỡng',
        'videoUrl': 'assets/videos/travel_2.mp4',
        'thumbnail': 'assets/images/x2/des7.jpg',
        'profilePhoto': 'assets/images/x2/img_user_profile_non.png',
      },
    ];

    for (final video in videos) {
      final docId = video['docId'] as String;
      final data = Map<String, dynamic>.from(video);
      data.remove('docId');

      batch.set(
        _db.collection('videos').doc(docId),
        data,
        SetOptions(merge: true),
      );
    }

    return videos.length;
  }

  static int _seedHistory(WriteBatch batch) {
    final uid = _auth.currentUser?.uid ?? 'demo_user';
    final now = DateTime.now();
    final histories = [
      {
        'docId': 'history_01',
        'id': 'history_01',
        'idUser': uid,
        'idTour': 'tour_01',
        'isActive': true,
        'isCheckUserParti': false,
        'bookingDate': Timestamp.fromDate(now.add(const Duration(days: 3))),
        'status': 'waiting',
        'adult': 2,
        'children': 1,
        'totalPrice': 7500000,
      },
      {
        'docId': 'history_02',
        'id': 'history_02',
        'idUser': uid,
        'idTour': 'tour_03',
        'isActive': true,
        'isCheckUserParti': false,
        'bookingDate': Timestamp.fromDate(now.add(const Duration(days: 10))),
        'status': 'coming',
        'adult': 2,
        'children': 0,
        'totalPrice': 9000000,
      },
      {
        'docId': 'history_03',
        'id': 'history_03',
        'idUser': uid,
        'idTour': 'tour_06',
        'isActive': true,
        'isCheckUserParti': true,
        'bookingDate':
            Timestamp.fromDate(now.subtract(const Duration(days: 10))),
        'status': 'completed',
        'adult': 1,
        'children': 0,
        'totalPrice': 3100000,
      },
    ];

    for (final history in histories) {
      final docId = history['docId'] as String;
      final data = Map<String, dynamic>.from(history);
      data.remove('docId');

      batch.set(
        _db.collection('historyModel').doc(docId),
        data,
        SetOptions(merge: true),
      );
    }

    return histories.length;
  }

  static Future<void> seedCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('[SEED] Skip userModel because currentUser is null');
      return;
    }

    debugPrint('[SEED] Start userModel/${user.uid}');
    try {
      await _db.collection('userModel').doc(user.uid).set({
        'id': user.uid,
        'email': user.email ?? '',
        'firstName': 'Hoàng',
        'lastName': 'Quốc',
        'passWord': '',
        'imgAvatar': 'assets/images/x2/img_user_profile_non.png',
        'phoneNub': '0123456789',
        'location': 'Việt Nam',
        'isActive': true,
        'imgThumbnails': [
          'assets/images/x2/des1.jpg',
          'assets/images/x2/des2.png',
          'assets/images/x2/des3.jpg',
        ],
      }, SetOptions(merge: true));
      debugPrint('[SEED] Done userModel/${user.uid}: 1 doc');
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('[SEED][ERROR] userModel/${user.uid}');
      debugPrint('FirebaseException code: ${e.code}');
      debugPrint('message: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);
    } catch (e, stackTrace) {
      debugPrint('[SEED][ERROR] userModel/${user.uid}');
      debugPrint('message: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> _verifySeed() async {
    await _verifyCollection('cityModel');
    await _verifyCollection('tourModel');
    await _verifyCollection('searchTour');
    await _verifyCollection('videos');
    await _verifyCollection('historyModel');
    await _verifyCollection('userModel');
  }

  static Future<void> _verifyCollection(String collectionName) async {
    try {
      final snapshot = await _db.collection(collectionName).get();
      debugPrint('[SEED][VERIFY] $collectionName: ${snapshot.docs.length}');
    } on FirebaseException catch (e) {
      debugPrint('[SEED][VERIFY][ERROR] $collectionName');
      debugPrint('FirebaseException code: ${e.code}');
      debugPrint('message: ${e.message}');
    } catch (e) {
      debugPrint('[SEED][VERIFY][ERROR] $collectionName');
      debugPrint('message: $e');
    }
  }
}
