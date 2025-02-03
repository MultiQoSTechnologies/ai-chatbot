import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai_demo/common/app_loader.dart';
import 'package:google_generative_ai_demo/common/media_picker.dart';
import 'package:image_picker/image_picker.dart';

Future openGalleryCamera({
  required BuildContext context,
  final Function? photoGallery,
  final Function? fileFromGalley,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: const Text(
        'Select Image',
        style: TextStyle(),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            'Photo Gallery',
            style: TextStyle(),
          ),
          onPressed: () async {
            AppLoader.showLoader(context);
             // var imageFile = await MediaPicker.openGallery();
            var callBack = fileFromGalley;
            if (callBack != null) {
              callBack(ImageSource.gallery);
            }
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            'Camera',
            style: TextStyle(),
          ),
          onPressed: () async {
            AppLoader.showLoader(context);

            var callBack = fileFromGalley;
            if (callBack != null) {
              callBack(ImageSource.camera);
            }
            Navigator.pop(context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
