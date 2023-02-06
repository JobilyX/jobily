import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/api_basehelper.dart';
import '../../domain/entities/jobs_fillter_response.dart';
import '../../domain/entities/my_jobs_reposnse.dart';
import '../../domain/usecases/get_jobs_fillter.dart';
import '../../domain/usecases/job_apply.dart';

const getJobsFillterApi = "/job-seeker/hr-jobs?perPage=20&page=1";
const getMyJobsApi = "/job-seeker/my-jobs?perPage=20&page=1";
const applyJobApi = "/job-seeker/hr-jobs"; //:jobID?type=join&join=1

abstract class HomeRemoteDatasource {
  Future<GetJobsFillterResponse> getJobsFillter(
      {required GetJobsFillterParams params, required String token});
  Future<MyJobsResponse> getMyJobs({required String token});
  Future<String> jobApply(
      {required JobApplyParams params, required String token});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDatasource {
  final ApiBaseHelper helper;
  HomeRemoteDataSourceImpl({
    required this.helper,
  });
  @override
  Future<GetJobsFillterResponse> getJobsFillter(
      {required GetJobsFillterParams params, required String token}) async {
    try {
      final response =
          await helper.get(url: "$getJobsFillterApi$params", token: token);
      return GetJobsFillterResponse.fromJson(response);
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
  Future<MyJobsResponse> getMyJobs({required String token}) async {
    try {
      final response = await helper.get(url: getMyJobsApi, token: token);
      return MyJobsResponse.fromJson(response);
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
  Future<String> jobApply(
      {required JobApplyParams params, required String token}) async {
    try {
      Map<String, dynamic>? body = {};
      if (params.applyOrReport == "join") {
        body = {"join": true};
      } else {
        body = {"comment": false};
      }
      final response = await helper.put(
          url:
              "$applyJobApi/${params.jobId}?service=${params.applyOrReport}&join=${params.applyOrReport}",
          token: token,
          body: body);
      return response["message"];
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
