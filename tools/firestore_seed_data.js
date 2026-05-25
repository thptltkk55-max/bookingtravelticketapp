'use strict';

const A = {
  city1: 'assets/images/x2/city_1.jpg',
  city2: 'assets/images/x2/city_2.jpg',
  city3: 'assets/images/x2/city_3.jpg',
  city4: 'assets/images/x2/city_4.jpg',
  city5: 'assets/images/x2/city_5.jpg',
  city6: 'assets/images/x2/city_6.jpg',
  city7: 'assets/images/x2/city_7.jpg',
  city8: 'assets/images/x2/city_8.jpg',
  des1: 'assets/images/x2/des1.jpg',
  des2: 'assets/images/x2/des2.png',
  des3: 'assets/images/x2/des3.jpg',
  des4: 'assets/images/x2/des4.jpg',
  des5: 'assets/images/x2/des5.jpg',
  des6: 'assets/images/x2/des6.jpg',
  des7: 'assets/images/x2/des7.jpg',
  des8: 'assets/images/x2/des8.jpg',
  des9: 'assets/images/x2/des9.png',
  avatar: 'assets/images/x2/img_user_profile_non.png',
  video: 'assets/videos/travel_1.mp4',
};

function timestamp(iso) {
  return { __type: 'timestamp', value: iso };
}

function doc(path, data) {
  return { path, data };
}

const users = [
  {
    id: 'user_demo_hieu',
    email: 'hieu.demo@gmail.com',
    firstName: 'Hiếu',
    lastName: 'Nguyễn',
    passWord: '123456',
    imgAvatar: A.avatar,
    phoneNub: '+84901234567',
    location: 'Thành phố Hồ Chí Minh',
    isActive: true,
    imgThumbnails: [A.des1, A.des2, A.des3],
  },
  {
    id: 'user_demo_linh',
    email: 'linh.demo@gmail.com',
    firstName: 'Linh',
    lastName: 'Trần',
    passWord: '123456',
    imgAvatar: A.avatar,
    phoneNub: '+84987654321',
    location: 'Đà Nẵng',
    isActive: true,
    imgThumbnails: [A.des4, A.des5],
  },
];

const cities = [
  city('city_01', 'Đà Lạt', 'Thành phố ngàn hoa, khí hậu mát mẻ quanh năm, phù hợp cho nghỉ dưỡng và săn mây.', A.city1, [A.city1, A.city2, A.city3]),
  city('city_02', 'Đà Nẵng', 'Thành phố biển năng động với cầu Rồng, bán đảo Sơn Trà và nhiều bãi biển đẹp.', A.city2, [A.city2, A.des4, A.des5]),
  city('city_03', 'Hà Nội', 'Thủ đô ngàn năm văn hiến với phố cổ, hồ Hoàn Kiếm và nền ẩm thực đậm bản sắc.', A.city3, [A.city3, A.des6, A.des7]),
  city('city_04', 'Phú Quốc', 'Đảo ngọc nổi tiếng với biển xanh, cát trắng, hoàng hôn đẹp và nhiều khu nghỉ dưỡng.', A.city4, [A.city4, A.des8, A.des9]),
  city('city_05', 'Nha Trang', 'Thiên đường biển miền Trung, thích hợp cho nghỉ dưỡng, lặn ngắm san hô và vui chơi.', A.city5, [A.city5, A.des1, A.des3]),
  city('city_06', 'Sa Pa', 'Vùng núi Tây Bắc với ruộng bậc thang, bản làng, khí hậu se lạnh và cảnh mây trời.', A.city6, [A.city6, A.city7, A.city8]),
  city('city_07', 'Huế', 'Cố đô yên bình với kinh thành, lăng tẩm, sông Hương và ẩm thực cung đình.', A.city7, [A.city7, A.des2, A.des4]),
  city('city_08', 'Hạ Long', 'Di sản thiên nhiên thế giới với vịnh biển kỳ vĩ, hang động và du thuyền ngắm cảnh.', A.city8, [A.city8, A.des5, A.des6]),
];

function city(id, nameCity, descriptionCity, imageCity, listArt) {
  return {
    id,
    idCity: id,
    nameCity,
    descriptionCity,
    imageCity,
    idCountry: 'VN',
    listArt,
    isFavourite: false,
  };
}

const tours = [
  tour('tour_01', 'Tour Đà Lạt 3 ngày 2 đêm', 'Khám phá hồ Xuân Hương, chợ đêm, vườn hoa và các điểm check-in nổi tiếng của Đà Lạt.', 'city_01', '2026-06-12T01:00:00.000Z', '2026-06-14T10:00:00.000Z', 2500000, [A.des1, A.des2, A.des3], '3 ngày 2 đêm', 'Khách sạn 3 sao', ['Ngày 1: Tham quan trung tâm Đà Lạt', 'Ngày 2: Check-in ngoại ô và săn mây', 'Ngày 3: Mua đặc sản và trở về'], 120, 4.8, 'sale', ['Giảm 10% cho nhóm từ 4 khách', 'Tặng vé tham quan vườn hoa'], 1, A.des1, 'Đà Lạt, Lâm Đồng'),
  tour('tour_02', 'Tour Đà Nẵng - Hội An 4 ngày 3 đêm', 'Trải nghiệm Bà Nà Hills, cầu Rồng, biển Mỹ Khê và phố cổ Hội An lung linh về đêm.', 'city_02', '2026-06-20T01:30:00.000Z', '2026-06-23T10:30:00.000Z', 4200000, [A.des4, A.des5, A.des6], '4 ngày 3 đêm', 'Khách sạn 4 sao', ['Ngày 1: Biển Mỹ Khê và cầu Rồng', 'Ngày 2: Bà Nà Hills', 'Ngày 3: Hội An', 'Ngày 4: Mua sắm và trở về'], 98, 4.7, 'popular', ['Tặng bữa tối đặc sản Hội An'], 2, A.des4, 'Đà Nẵng'),
  tour('tour_03', 'Tour Hà Nội phố cổ 2 ngày 1 đêm', 'Dạo phố cổ, thưởng thức ẩm thực Hà Nội và tham quan các địa danh văn hóa nổi bật.', 'city_03', '2026-05-28T02:00:00.000Z', '2026-05-29T11:00:00.000Z', 1800000, [A.des6, A.des7, A.city3], '2 ngày 1 đêm', 'Khách sạn 3 sao trung tâm', ['Ngày 1: Hồ Hoàn Kiếm và phố cổ', 'Ngày 2: Văn Miếu và lăng Chủ tịch Hồ Chí Minh'], 76, 4.5, 'new', ['Tặng voucher cà phê phố cổ'], 1, A.des6, 'Hà Nội'),
  tour('tour_04', 'Tour Phú Quốc nghỉ dưỡng 3 ngày 2 đêm', 'Nghỉ dưỡng tại đảo ngọc, ngắm hoàng hôn, tham quan Nam đảo và thưởng thức hải sản.', 'city_04', '2026-07-05T01:00:00.000Z', '2026-07-07T10:00:00.000Z', 5200000, [A.des8, A.des9, A.city4], '3 ngày 2 đêm', 'Resort 4 sao', ['Ngày 1: Nhận phòng và ngắm hoàng hôn', 'Ngày 2: Tour đảo và lặn ngắm san hô', 'Ngày 3: Tự do nghỉ dưỡng'], 150, 4.9, 'sale', ['Giảm 500.000đ cho khách đặt sớm'], 3, A.des8, 'Phú Quốc, Kiên Giang'),
  tour('tour_05', 'Tour Nha Trang biển xanh 3 ngày 2 đêm', 'Tắm biển, tham quan đảo, thưởng thức hải sản và vui chơi tại các điểm nổi tiếng.', 'city_05', '2026-06-01T01:00:00.000Z', '2026-06-03T10:00:00.000Z', 3600000, [A.city5, A.des1, A.des5], '3 ngày 2 đêm', 'Khách sạn gần biển', ['Ngày 1: Biển Trần Phú', 'Ngày 2: Tour đảo', 'Ngày 3: Mua đặc sản'], 89, 4.6, 'popular', ['Tặng bữa hải sản cho nhóm từ 6 khách'], 2, A.city5, 'Nha Trang, Khánh Hòa'),
  tour('tour_06', 'Tour Sa Pa săn mây 3 ngày 2 đêm', 'Khám phá bản Cát Cát, đỉnh Fansipan, ruộng bậc thang và văn hóa vùng cao.', 'city_06', '2026-05-10T01:00:00.000Z', '2026-05-12T10:00:00.000Z', 3900000, [A.city6, A.city7, A.des7], '3 ngày 2 đêm', 'Khách sạn view núi', ['Ngày 1: Di chuyển đến Sa Pa', 'Ngày 2: Fansipan và bản Cát Cát', 'Ngày 3: Chợ Sa Pa'], 64, 4.4, 'new', ['Tặng vé tham quan bản Cát Cát'], 1, A.city6, 'Sa Pa, Lào Cai'),
  tour('tour_07', 'Tour Huế di sản 2 ngày 1 đêm', 'Tham quan Đại Nội, lăng Khải Định, chùa Thiên Mụ và thưởng thức ẩm thực Huế.', 'city_07', '2026-06-08T01:00:00.000Z', '2026-06-09T10:00:00.000Z', 2100000, [A.city7, A.des2, A.des4], '2 ngày 1 đêm', 'Khách sạn 3 sao', ['Ngày 1: Đại Nội và sông Hương', 'Ngày 2: Lăng tẩm và chùa Thiên Mụ'], 58, 4.3, 'popular', ['Tặng bữa tối món Huế'], 1, A.city7, 'Huế, Thừa Thiên Huế'),
  tour('tour_08', 'Tour Hạ Long du thuyền 2 ngày 1 đêm', 'Ngủ đêm trên du thuyền, tham quan hang động và ngắm bình minh trên vịnh Hạ Long.', 'city_08', '2026-07-15T01:00:00.000Z', '2026-07-16T10:00:00.000Z', 4800000, [A.city8, A.des5, A.des6], '2 ngày 1 đêm', 'Du thuyền 4 sao', ['Ngày 1: Lên du thuyền và tham quan hang động', 'Ngày 2: Chèo kayak và trở về bến'], 132, 4.8, 'sale', ['Tặng set trà chiều trên du thuyền'], 3, A.city8, 'Hạ Long, Quảng Ninh'),
];

function tour(idTour, nameTour, description, idCity, startDate, endDate, price, images, duration, accommodation, itinerary, reviews, rating, status, specialOffers, type, imgqr, location) {
  return {
    idTour,
    nameTour,
    description,
    idCity,
    startDate: timestamp(startDate),
    endDate: timestamp(endDate),
    price,
    images,
    duration,
    accommodation,
    itinerary,
    includedServices: ['Xe đưa đón', 'Khách sạn', 'Vé tham quan', 'Hướng dẫn viên', 'Bữa sáng'],
    excludedServices: ['Chi phí cá nhân', 'Đồ uống ngoài chương trình'],
    reviews,
    rating,
    active: true,
    status,
    specialOffers,
    type,
    imgqr,
    location,
    isFavourite: false,
  };
}

const histories = [
  history('history_01', 'user_demo_hieu', 'tour_01', '2026-06-12T01:00:00.000Z', 'coming', 2, 1, 7500000, false),
  history('history_02', 'user_demo_hieu', 'tour_06', '2026-05-10T01:00:00.000Z', 'completed', 2, 0, 7800000, true),
  history('history_03', 'user_demo_hieu', 'tour_04', '2026-07-05T01:00:00.000Z', 'waiting', 2, 0, 10400000, false),
  history('history_04', 'user_demo_linh', 'tour_02', '2026-06-20T01:30:00.000Z', 'coming', 1, 0, 4200000, false),
  history('history_05', 'user_demo_linh', 'tour_03', '2026-05-28T02:00:00.000Z', 'canceled', 1, 1, 3600000, false),
];

function history(id, idUser, idTour, bookingDate, status, adult, children, totalPrice, isCheckUserParti) {
  return {
    id,
    idUser,
    idTour,
    isActive: true,
    isCheckUserParti,
    bookingDate: timestamp(bookingDate),
    status,
    adult,
    children,
    totalPrice,
  };
}

const videos = [
  video('video_01', 'Hiếu Nguyễn', 'user_demo_hieu', [], 2, 4, 'Travel Music', 'Một ngày khám phá Đà Lạt thật nhiều kỷ niệm.', A.video, A.des1),
  video('video_02', 'Linh Trần', 'user_demo_linh', ['user_demo_hieu'], 1, 2, 'Việt Nam tươi đẹp', 'Biển Đà Nẵng buổi sáng trong xanh và yên bình.', A.video, A.des4),
  video('video_03', 'Travel Demo', 'user_demo_hieu', [], 0, 1, 'Khám phá Việt Nam', 'Gợi ý lịch trình cuối tuần cho nhóm bạn.', A.video, A.city8),
];

function video(id, username, uid, likes, commentCount, shareCount, songName, caption, videoUrl, thumbnail) {
  return {
    id,
    username,
    uid,
    likes,
    commentCount,
    shareCount,
    songName,
    caption,
    videoUrl,
    thumbnail,
    profilePhoto: A.avatar,
  };
}

const searchTours = [
  { id: 'Đà Lạt', value: 'Đà Lạt', count: 12 },
  { id: 'Đà Nẵng', value: 'Đà Nẵng', count: 10 },
  { id: 'Phú Quốc', value: 'Phú Quốc', count: 9 },
  { id: 'Nha Trang', value: 'Nha Trang', count: 8 },
  { id: 'Sa Pa', value: 'Sa Pa', count: 6 },
  { id: 'Hạ Long', value: 'Hạ Long', count: 5 },
  { id: 'tour biển', value: 'tour biển', count: 4 },
  { id: 'nghỉ dưỡng', value: 'nghỉ dưỡng', count: 3 },
];

const pushNotifications = [
  { id: 'push_demo_hieu', idUser: 'user_demo_hieu', fcmToken: 'demo_fcm_token_hieu' },
  { id: 'push_demo_linh', idUser: 'user_demo_linh', fcmToken: 'demo_fcm_token_linh' },
];

const comments = [
  comment('Comment 0', 'Hiếu', 'Tour rất đáng trải nghiệm, lịch trình vừa sức và ảnh lên rất đẹp.', '2026-05-20T08:00:00.000Z', [], 'user_demo_hieu'),
  comment('Comment 1', 'Linh', 'Mình thích nhất phần hướng dẫn viên nhiệt tình và đồ ăn địa phương.', '2026-05-21T09:30:00.000Z', ['user_demo_hieu'], 'user_demo_linh'),
];

function comment(id, username, text, datePublished, likes, uid) {
  return {
    id,
    username,
    comment: text,
    datePublished: timestamp(datePublished),
    likes,
    profilePhoto: A.avatar,
    uid,
  };
}

function buildWrites() {
  const writes = [];

  for (const item of cities) writes.push(doc(`cityModel/${item.id}`, item));
  for (const item of tours) writes.push(doc(`tourModel/${item.idTour}`, item));
  for (const item of users) writes.push(doc(`userModel/${item.id}`, item));
  for (const item of histories) writes.push(doc(`historyModel/${item.id}`, item));
  for (const item of videos) writes.push(doc(`videos/${item.id}`, item));
  for (const item of searchTours) writes.push(doc(`searchTour/${item.id}`, item));
  for (const item of pushNotifications) writes.push(doc(`pushNotification/${item.id}`, item));

  writes.push(doc('userModel/user_demo_hieu/favourite/fav_city_01', { idDes: 'city_01' }));
  writes.push(doc('userModel/user_demo_hieu/favourite/fav_city_04', { idDes: 'city_04' }));
  writes.push(doc('userModel/user_demo_hieu/favouriteTour/fav_tour_01', { idTour: 'tour_01' }));
  writes.push(doc('userModel/user_demo_hieu/favouriteTour/fav_tour_04', { idTour: 'tour_04' }));
  writes.push(doc('userModel/user_demo_linh/favourite/fav_city_02', { idDes: 'city_02' }));
  writes.push(doc('userModel/user_demo_linh/favouriteTour/fav_tour_02', { idTour: 'tour_02' }));

  for (const item of comments) {
    writes.push(doc(`tourModel/tour_01/comments/${item.id}`, item));
    writes.push(doc(`videos/video_01/comments/${item.id}`, item));
  }

  writes.push(doc('videos/video_02/comments/Comment 0', comment('Comment 0', 'Hiếu', 'Cảnh biển đẹp, video xem rất thích.', '2026-05-21T11:00:00.000Z', [], 'user_demo_hieu')));

  return writes;
}

module.exports = {
  metadata: {
    name: 'Booking Travel GetX Firestore seed',
    locale: 'vi-VN',
    mediaMode: 'assets',
    generatedAt: '2026-05-22',
  },
  collections: {
    users,
    cities,
    tours,
    histories,
    videos,
    searchTours,
    pushNotifications,
  },
  buildWrites,
};
