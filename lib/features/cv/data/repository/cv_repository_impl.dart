// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jobily/core/error/exceptions.dart';
import 'package:jobily/core/error/failures.dart';
import 'package:jobily/core/local/auth_local_datasource.dart';
import 'package:jobily/features/cv/data/datasource/cv_remote_datesource.dart';
import 'package:jobily/features/cv/domain/entities/cv_entity.dart';
import 'package:jobily/features/cv/domain/entities/cv_file_response.dart';
import 'package:jobily/features/cv/domain/repositories/cv_repository.dart';
import 'package:jobily/features/cv/domain/usecases/create_cv.dart';
import 'package:jobily/features/cv/domain/usecases/create_cv_with_file.dart';
import 'package:jobily/features/cv/domain/usecases/delete_cv.dart';

import '../../domain/usecases/get_cv.dart';

class CvRepositoryImpl implements CvRepository {
  final CvRemoteDataSource remote;
  final AuthLocalDataSource authLocal;
  CvRepositoryImpl({
    required this.remote,
    required this.authLocal,
  });
  @override
  Future<Either<Failure, CvResponse>> createCv(
      {required CreateCvParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.createCv(params: params, token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, CvResponse>> getCv(
      {required GetCvParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.getCv(params: params, token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, CvFileResponse>> createCvWithFile(
      {required CreateCvWithFileParams params}) async {
    try {
      final response = await remote.createCvWithCv(params: params);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, CvResponse>> deleteCv(
      {required DeleteCvParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.deleteCv(params: params, token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }
}
