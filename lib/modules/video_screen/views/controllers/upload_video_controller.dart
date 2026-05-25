import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_clean_achitec/modules/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/video/video.dart';

class UploadVideoController extends GetxController {
  final HomeController homeController = Get.put(HomeController());

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    return 'assets/videos/travel_1.mp4';
  }

  Future<String> uploadImageToStorage(String id, String videoPath) async {
    return 'assets/images/x2/des1.jpg';
  }

  Future<String> getImageStorage(String nameImage) async {
    if (nameImage.startsWith('assets/') ||
        nameImage.startsWith('http://') ||
        nameImage.startsWith('https://')) {
      return nameImage;
    }

    return '';
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = homeController.userModel.value?.id ?? "";

      var uuid = const Uuid();

      String videoUrl = await _uploadVideoToStorage(uuid.v4(), videoPath);
      String? thumbnail = await uploadImageToStorage(uuid.v4(), videoPath);

      Get.snackbar(
        'Demo media',
        'Chức năng upload file đang tạm tắt vì Firebase Storage yêu cầu nâng cấp tài khoản. Bản demo dùng tài nguyên trong assets.',
      );

      Video video = Video(
        username: homeController.userModel.value?.firstName ?? "user",
        uid: uid,
        id: uuid.v4(),
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: homeController.userModel.value?.imgAvatar ??
            'assets/images/x2/img_user_profile_non.png',
        thumbnail: thumbnail,
      );

      await FirebaseFirestore.instance.collection('videos').doc(uuid.v4()).set(
            video.toJson(),
          );
      Get.back();
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
