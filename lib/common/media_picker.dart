import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai_demo/common/app_loader.dart';
import 'package:image_picker/image_picker.dart';

class MediaPicker {
  static Future<File?> openGallery() async {
    try {
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        AppLoader.hideLoader();
        var image = File(pickedFile.path);
        return image;
      } else {
        AppLoader.hideLoader();
      }
    } catch (e) {
      debugPrint("openGallery = == ${e.toString()}");
    }

    return null;
  }

  static Future<File?> openCamera() async {
    try {
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        AppLoader.hideLoader();
        var image = File(pickedFile.path);
        return image;
      } else {
        AppLoader.hideLoader();
      }
    } catch (e) {
      AppLoader.hideLoader();
      debugPrint("openGallery = == ${e.toString()}");
    }

    return null;
  }
}
