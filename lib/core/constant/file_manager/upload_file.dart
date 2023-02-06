import 'dart:io';

import 'package:flutter/material.dart';

import '../../widgets/snackbars_toasst/snack_bar.dart';
import 'local_file.dart';

class UploadFileManager {
  static Future<String> updateFile({
    File? image,
  }) async {
    String collection = "";
    var response;
    try {
      response = await DioService()
          .requestWithFile('/media/upload-file', image, token: "");
    } catch (e) {
      debugPrint(e.toString());
    }
    response.fold((l) {
      appSnackBar(l.toString());
      collection = "";
    }, (r) {
      collection = r["body"]["url"];
    });
    return collection;
  }
}
