import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage {
  static const String noData = 'assets/icons/ic_nodata.png';
  static const String defaultAvatar =
      'assets/images/x2/img_user_profile_non.png';

  static bool isAsset(String? path) {
    if (path == null) return false;
    return path.trim().startsWith('assets/');
  }

  static bool isNetwork(String? path) {
    if (path == null) return false;
    final value = path.trim();
    return value.startsWith('http://') || value.startsWith('https://');
  }

  static ImageProvider provider(
    String? path, {
    String fallback = noData,
  }) {
    final value = path?.trim() ?? '';

    if (value.isEmpty) {
      return AssetImage(fallback);
    }

    if (isAsset(value)) {
      return AssetImage(value);
    }

    if (isNetwork(value)) {
      return CachedNetworkImageProvider(value);
    }

    return AssetImage(fallback);
  }

  static Widget widget(
    String? path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    String fallback = noData,
  }) {
    final value = path?.trim() ?? '';
    Widget image;

    if (value.isEmpty) {
      image = Image.asset(
        fallback,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (isAsset(value)) {
      image = Image.asset(
        value,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (isNetwork(value)) {
      image = CachedNetworkImage(
        imageUrl: value,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color: Colors.grey.shade200,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          fallback,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else {
      image = Image.asset(
        fallback,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }

    return image;
  }
}
