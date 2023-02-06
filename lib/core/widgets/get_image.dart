import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class GetImageFromCameraAndGellary extends StatelessWidget {
  final Function(File) onPickImage;
  final bool isVideo;

  GetImageFromCameraAndGellary(
      {Key? key, required this.onPickImage, this.isVideo = false})
      : super(key: key);

  final ImagePicker _picker = ImagePicker();

  Future getImagefromcamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      maxHeight: 4000,
      maxWidth: 3000,
    );
    if (pickedFile != null) {
      File compressedFile = await FlutterNativeImage.compressImage(
          pickedFile.path,
          quality: 70,
          percentage: 70);
      onPickImage(compressedFile);
    } else {}
  }

  Future getImagefromgallary() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
    );

    // setState(() {
    if (pickedFile != null) {
      File compressedFile = await FlutterNativeImage.compressImage(
          pickedFile.path,
          quality: 70,
          percentage: 70);
      onPickImage(compressedFile);
    } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.photo,
            size: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            // ignore: deprecated_member_use
            tr('gallery'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            getImagefromgallary();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.camera_alt_outlined,
            size: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            // ignore: deprecated_member_use
            tr('camera'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            getImagefromcamera();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class GetFile extends StatelessWidget {
  final Function(PlatformFile) onPickFile;
  final bool isVideo;

  const GetFile({Key? key, required this.onPickFile, this.isVideo = false})
      : super(key: key);
  void getDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );
    if (result != null) {
      onPickFile(result.files.first);
    }
  }

  void getPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      onPickFile(result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.document_scanner,
            size: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            // ignore: deprecated_member_use
            tr('Doc'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            getDoc();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.picture_as_pdf,
            size: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            // ignore: deprecated_member_use
            tr('PDF'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            getPdf();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
