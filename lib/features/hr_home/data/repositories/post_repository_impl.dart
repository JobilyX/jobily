import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/usecases/accept_reject_apllicant.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/local/auth_local_datasource.dart';
import '../../domain/entities/Skills_response.dart';
import '../../domain/entities/job_byid_reponse.dart';
import '../../domain/entities/jobs_repsonse.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/add_job_post.dart';
import '../../domain/usecases/delete_job.dart';
import '../../domain/usecases/get_job_byid.dart';
import '../datasources/post_remote_datesource.dart';

class PostRepositoryImpl implements PostRepository {
  final AuthLocalDataSource authLocal;
  final PostRemoteDatasource remote;

  PostRepositoryImpl({
    required this.authLocal,
    required this.remote,
  });
  @override
  Future<Either<Failure, SkillsResponse>> getSkills() async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response1 =
          await remote.getSkills(token: token, getSection: "skills");
      final response2 =
          await remote.getSkills(token: token, getSection: "job_location");
      final response3 =
          await remote.getSkills(token: token, getSection: "job_position");
      response1.body.jobLocation.addAll(response2.body.jobLocation);
      response1.body.jobPosition.addAll(response3.body.jobPosition);
      return Right(response1);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, JobsResponse>> getJobs() async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.getJobs(token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, JobByIdResponse>> getJobById(
      {required GetJobPostByIdParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final response = await remote.getJobByid(params: params, token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, JobsResponse>> deleteJob(
      {required DeleteJobPostParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      await remote.deleteJob(params: params, token: token);
      final response = await remote.getJobs(token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, JobsResponse>> addPost(
      {required AddJobPostParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      if (params.isEdit) {
        await remote.editPost(params: params, token: token);
      } else {
        await remote.addPost(params: params, token: token);
      }
      final response = await remote.getJobs(token: token);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptRejectApplicants(
      {required AcceptRejectApplicantsParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();

      await remote.acceptRejectApplicants(params: params, token: token);

      return const Right(unit);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }
}
