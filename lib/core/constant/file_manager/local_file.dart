import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DioService {
  static final DioService _dioService = DioService._internal();
  static dio.Dio? _dio;

  factory DioService() {
    dio.BaseOptions options = dio.BaseOptions(
        baseUrl: "https://jobilyapi.com/api",
        receiveDataWhenStatusError: true,
        connectTimeout: 90 * 1000,
        sendTimeout: 15 * 1000,
        receiveTimeout: 30 * 1000);
    _dio = dio.Dio(options);
    return _dioService;
  }

  DioService._internal();
  requestWithFile(path, File? file,
      {Map<String, dynamic>? data, String? token}) async {
    // final prefs = await SharedPreferences.getInstance();
    // final value = prefs.getString("token") ?? "0";
    try {
      String? fileName;
      if (file == null) {
        fileName = null;
      } else {
        fileName = file.path.split('/').last;
      }
      dio.FormData formData = dio.FormData.fromMap({
        "file":
            await dio.MultipartFile.fromFile(file!.path, filename: fileName),
      });
      debugPrint(formData.fields.toString());
      final response = await _dio!.post(path,
          data: formData,
          options: dio.Options(
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
          ));
      debugPrint(response.data.toString());
      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['status'] == true) {
          return Right(response.data);
        } else {
          return Left(response.data['message']);
        }
      }
    } on dio.DioError catch (e) {
      debugPrint("dio error : ${e.response}");
      if (e.error.runtimeType != SocketException) {
        return Left(e.message);
      } else if (e.type == dio.DioErrorType.connectTimeout ||
          e.type == dio.DioErrorType.receiveTimeout ||
          e.type == dio.DioErrorType.sendTimeout) {
        Left(tr("error_occurred"));
      } else {
        return Left(tr("error_occurred"));
      }
    }
  }
}
