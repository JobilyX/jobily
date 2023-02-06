// To parse this JSON data, do
//
//     final getJobsFillter = getJobsFillterFromJson(jsonString);

import 'dart:convert';

import 'package:jobily/features/hr_home/domain/entities/jobs_repsonse.dart';

GetJobsFillterResponse getJobsFillterFromJson(String str) =>
    GetJobsFillterResponse.fromJson(json.decode(str));

String getJobsFillterToJson(GetJobsFillterResponse data) =>
    json.encode(data.toJson());

class GetJobsFillterResponse {
  GetJobsFillterResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.body,
    required this.info,
  });

  final int code;
  final bool status;
  final String message;
  final Body body;
  final String info;

  factory GetJobsFillterResponse.fromJson(Map<String, dynamic> json) =>
      GetJobsFillterResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        body: Body.fromJson(json["body"]),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "body": body.toJson(),
        "info": info,
      };
}

class Body {
  Body({
    required this.hrJobs,
  });

  final HrJobs hrJobs;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        hrJobs: HrJobs.fromJson(json["hr_jobs"]),
      );

  Map<String, dynamic> toJson() => {
        "hr_jobs": hrJobs.toJson(),
      };
}

class HrJobs {
  HrJobs({
    required this.data,
    required this.paginate,
  });

  final List<Job> data;
  final Paginate paginate;

  factory HrJobs.fromJson(Map<String, dynamic> json) => HrJobs(
        data: List<Job>.from(json["data"].map((x) => Job.fromJson(x))),
        paginate: Paginate.fromJson(json["paginate"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "paginate": paginate.toJson(),
      };
}
