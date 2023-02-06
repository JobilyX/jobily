// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jobily/core/util/api_basehelper.dart';
import 'package:jobily/features/cv/domain/usecases/create_cv_with_file.dart';
import 'package:jobily/features/cv/domain/usecases/delete_cv.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/cv_entity.dart';
import '../../domain/entities/cv_file_response.dart';
import '../../domain/usecases/create_cv.dart';
import '../../domain/usecases/get_cv.dart';

// TODO : Heeeeyyyy change this after 15 try from https://apilayer.com/marketplace/resume_parser-api#
const cvAPIKey = "aGHw1nRtGcMJ5YG8RtSzTIVEsWkxhnvR";
const createCvAPI = "/job-seeker/cvs";

abstract class CvRemoteDataSource {
  Future<CvResponse> createCv(
      {required CreateCvParams params, required String token});
  Future<CvResponse> getCv(
      {required GetCvParams params, required String token});
  Future<CvResponse> deleteCv(
      {required DeleteCvParams params, required String token});
  Future<CvFileResponse> createCvWithCv(
      {required CreateCvWithFileParams params});
}

class CvRemoteDataSourceImpl implements CvRemoteDataSource {
  final ApiBaseHelper helper;
  CvRemoteDataSourceImpl({
    required this.helper,
  });
  @override
  Future<CvResponse> createCv(
      {required CreateCvParams params, required String token}) async {
    try {
      final response =
          await helper.post(url: createCvAPI, body: params.map, token: token);
      return CvResponse.fromJson(response);
    } catch (e) {
      log(e.toString());

      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<CvResponse> getCv(
      {required GetCvParams params, required String token}) async {
    try {
      final response =
          await helper.get(url: "$createCvAPI/${params.userId}", token: token);
      return CvResponse.fromJson(response);
    } catch (e) {
      log(e.toString());

      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<CvFileResponse> createCvWithCv(
      {required CreateCvWithFileParams params}) async {
    try {
      final File file = File(params.file.path!);
      final bytes = file.readAsBytesSync();
      final response = await Dio().post(
          "https://api.apilayer.com/resume_parser/upload",
          onSendProgress: params.onSendProgress,
          data: Stream.fromIterable(bytes.map((e) => [e])),
          options: Options(headers: {
            "Content-Type": "application/octet-stream",
            "apikey": cvAPIKey
          }));
      return CvFileResponse.fromJson(response.data);
    } catch (e) {
      log(e.toString());

      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<CvResponse> deleteCv(
      {required DeleteCvParams params, required String token}) async {
    try {
      final response = await helper.delete(
          url: "$createCvAPI/${params.userId}", token: token);
      return CvResponse.fromJson(response);
    } catch (e) {
      log(e.toString());

      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }
}
