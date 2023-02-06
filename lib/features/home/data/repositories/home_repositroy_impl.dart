import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/local/auth_local_datasource.dart';
import '../../domain/entities/jobs_fillter_response.dart';
import '../../domain/entities/my_jobs_reposnse.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_jobs_fillter.dart';
import '../../domain/usecases/job_apply.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final AuthLocalDataSource authLocal;
  final HomeRemoteDatasource remote;
  HomeRepositoryImpl({
    required this.authLocal,
    required this.remote,
  });
  @override
  Future<Either<Failure, GetJobsFillterResponse>> getJobsFillter(
      {required GetJobsFillterParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response =
          await remote.getJobsFillter(params: params, token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, MyJobsResponse>> getMyJobs() async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.getMyJobs(token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, String>> jobApply(
      {required JobApplyParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.jobApply(params: params, token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }
}
