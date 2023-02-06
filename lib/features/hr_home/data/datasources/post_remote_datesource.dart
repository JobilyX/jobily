import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/api_basehelper.dart';
import '../../domain/entities/Skills_response.dart';
import '../../domain/entities/job_byid_reponse.dart';
import '../../domain/entities/jobs_repsonse.dart';
import '../../domain/usecases/accept_reject_apllicant.dart';
import '../../domain/usecases/add_job_post.dart';
import '../../domain/usecases/delete_job.dart';
import '../../domain/usecases/get_job_byid.dart';

const getSectionApi = "/hr/hr-jobs/create";
const getjobsApi = "/hr/hr-jobs";

abstract class PostRemoteDatasource {
  Future<SkillsResponse> getSkills(
      {required String token, required String getSection});
  Future<JobsResponse> getJobs({required String token});
  Future<JobByIdResponse> getJobByid(
      {required String token, required GetJobPostByIdParams params});

  Future<void> deleteJob(
      {required String token, required DeleteJobPostParams params});
  Future<void> addPost(
      {required String token, required AddJobPostParams params});
  Future<void> editPost(
      {required String token, required AddJobPostParams params});
  Future<void> acceptRejectApplicants(
      {required String token, required AcceptRejectApplicantsParams params});
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final ApiBaseHelper helper;
  PostRemoteDatasourceImpl({
    required this.helper,
  });
  @override
  Future<SkillsResponse> getSkills(
      {required String token, required String getSection}) async {
    try {
      final response = await helper.get(
          url: "$getSectionApi?getSection=$getSection", token: token);
      return SkillsResponse.fromJson(response);
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
  Future<JobsResponse> getJobs({required String token}) async {
    try {
      final response =
          await helper.get(url: "$getjobsApi?perPage=30&page=1", token: token);
      return JobsResponse.fromJson(response);
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
  Future<JobByIdResponse> getJobByid(
      {required String token, required GetJobPostByIdParams params}) async {
    try {
      final response =
          await helper.get(url: "$getjobsApi/${params.jobId}", token: token);
      return JobByIdResponse.fromJson(response);
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
  Future<void> deleteJob(
      {required String token, required DeleteJobPostParams params}) async {
    try {
      await helper.delete(url: "$getjobsApi/${params.jobid}", token: token);
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
  Future<void> addPost(
      {required String token, required AddJobPostParams params}) async {
    try {
      await helper.post(url: getjobsApi, body: params.map, token: token);
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
  Future<void> editPost(
      {required String token, required AddJobPostParams params}) async {
    try {
      await helper.put(
          url: "$getjobsApi/${params.postId}?type=activate&is_active=1",
          body: params.map,
          token: token);
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
  Future<void> acceptRejectApplicants(
      {required String token,
      required AcceptRejectApplicantsParams params}) async {
    try {
      await helper.put(
          url:
              "$getjobsApi/${params.postId}?service=acceptEmployee&is_active=1",
          token: token,
          body: {
            "job_seeker_id": params.seekrId,
            "status": params.status.name
          });
      sendPushMessage(
          status: params.status.name,
          comp: params.companyName,
          fcm: params.fcmToken);
    } catch (e) {
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  Future<void> sendPushMessage({
    required String status,
    required String comp,
    required String fcm,
  }) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAYR6eB3Y:APA91bHO76-SL-iRNq8JBYaUtbrKnnvrXVrtyS5mXHka5vPdaFEgjQkOIl7M3U_v8LwJyMggAqlPqPZkvBjMR9woqxdUn1hF3pRO4pbYJ5i9WlWvDHdDec6aLvM5J7b68VmZWi90H_yU'
          },
          body: json.encode({
            'to': fcm,
            'data': {
              'via': 'FlutterFire Cloud Messaging!!!',
              'count': 1121.toString(),
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
            },
            'notification': {
              'title': 'New from $comp',
              'body': "Your applicaton has been $status",
              "sound": "default"
            },
          }));
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
