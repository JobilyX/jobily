// To parse this JSON data, do
//
//     final jobByIdResponse = jobByIdResponseFromJson(jsonString);

import 'dart:convert';

import 'package:jobily/features/hr_home/domain/entities/jobs_repsonse.dart';

MyJobsResponse jobByIdResponseFromJson(String str) =>
    MyJobsResponse.fromJson(json.decode(str));

String jobByIdResponseToJson(MyJobsResponse data) => json.encode(data.toJson());

class MyJobsResponse {
  MyJobsResponse({
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

  factory MyJobsResponse.fromJson(Map<String, dynamic> json) => MyJobsResponse(
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
    required this.myJobs,
  });

  final MyJobs myJobs;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        myJobs: MyJobs.fromJson(json["my_jobs"]),
      );

  Map<String, dynamic> toJson() => {
        "my_jobs": myJobs.toJson(),
      };
}

class MyJobs {
  MyJobs({
    required this.data,
    required this.paginate,
  });

  final List<Job> data;
  final Paginate paginate;

  factory MyJobs.fromJson(Map<String, dynamic> json) => MyJobs(
        data: List<Job>.from(json["data"].map((x) => Job.fromJson(x))),
        paginate: Paginate.fromJson(json["paginate"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "paginate": paginate.toJson(),
      };
}
