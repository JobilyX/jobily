// To parse this JSON data, do
//
//     final jobsResponse = jobsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:jobily/features/cv/presentation/cubit/cv_cubit.dart';
import 'package:jobily/features/hr_home/presentation/cubit/add_post/add_post_cubit.dart'
    as e;

JobsResponse jobsResponseFromJson(String str) =>
    JobsResponse.fromJson(json.decode(str));

String jobsResponseToJson(JobsResponse data) => json.encode(data.toJson());

class JobsResponse {
  JobsResponse({
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

  factory JobsResponse.fromJson(Map<String, dynamic> json) => JobsResponse(
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

class Job {
  Job({
    required this.id,
    required this.hr,
    required this.title,
    required this.description,
    required this.salaryFrom,
    required this.salaryTo,
    required this.createdAt,
    required this.jobSections,
  });

  final int id;
  final Hr hr;
  final String title;
  final String description;
  final String salaryFrom;
  final String salaryTo;
  final DateTime createdAt;
  final List<JobSection> jobSections;
  List<CvComponent> listOfComp = [
    CvComponent(sectionName: "job_position"),
    CvComponent(sectionName: "job_location"),
    CvComponent(sectionName: "years_of_experience"),
    // CvComponent(sectionName: "gender"),
    CvComponent(sectionName: "field_education"),
    CvComponent(sectionName: "skills"),
  ];
  setData() {
    listOfComp[e.jobPositionIndex].sectionvalues = [
      jobSections[e.jobPositionIndex].value
    ];
    listOfComp[e.jobLocatonIndex].sectionvalues = [
      jobSections[e.jobLocatonIndex].value
    ];
    listOfComp[e.yearsOfExperienceIndex].sectionvalues = [
      jobSections[e.yearsOfExperienceIndex].value
    ];
    listOfComp[e.fieldEducationIndex].sectionvalues = [
      jobSections[e.fieldEducationIndex].value
    ];
    final skillsList = jobSections.sublist(4);
    for (int index = 0; index < skillsList.length; index++) {
      listOfComp[e.skillsIndex].sectionvalues.add(skillsList[index].value);
    }
  }

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        hr: Hr.fromJson(json["hr"]),
        title: json["title"],
        description: json["description"],
        salaryFrom: json["salary_from"],
        salaryTo: json["salary_to"],
        createdAt: DateTime.parse(json["created_at"]),
        jobSections: List<JobSection>.from(
            json["job_sections"].map((x) => JobSection.fromJson(x))),
      )..setData();

  Map<String, dynamic> toJson() => {
        "id": id,
        "hr": hr.toJson(),
        "title": title,
        "description": description,
        "salary_from": salaryFrom,
        "salary_to": salaryTo,
        "created_at": createdAt.toIso8601String(),
        "job_sections": List<dynamic>.from(jobSections.map((x) => x.toJson())),
      };
}

class JobSection {
  JobSection({
    required this.id,
    required this.section,
    required this.key,
    required this.value,
  });

  final int id;
  final String section;
  final String key;
  final String value;

  factory JobSection.fromJson(Map<String, dynamic> json) => JobSection(
        id: json["id"] ?? 0,
        section: json["section"] ?? "",
        key: json["key"] ?? "",
        value: json["value"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "section": section,
        "key": key,
        "value": value,
      };
}

class Paginate {
  Paginate({
    required this.total,
    required this.count,
    required this.perPage,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.currentPage,
    required this.totalPages,
  });

  final int total;
  final int count;
  final int perPage;
  final String nextPageUrl;
  final String prevPageUrl;
  final int currentPage;
  final int totalPages;

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        nextPageUrl: json["next_page_url"],
        prevPageUrl: json["prev_page_url"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "next_page_url": nextPageUrl,
        "prev_page_url": prevPageUrl,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}

class Hr {
  Hr({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.type,
    required this.gender,
    required this.avatar,
    required this.graduationCertificate,
    required this.coverLetter,
    required this.cv,
    required this.dateOfBirth,
    required this.deviceTokens,
  });

  final int id;
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String type;
  final String gender;
  final String avatar;
  final String graduationCertificate;
  final String coverLetter;
  final String cv;
  final DateTime dateOfBirth;
  final List<String> deviceTokens;

  factory Hr.fromJson(Map<String, dynamic> json) => Hr(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        email: json["email"],
        type: json["type"],
        gender: json["gender"],
        avatar: json["avatar"],
        graduationCertificate: json["graduation_certificate"],
        coverLetter: json["cover_letter"],
        cv: json["cv"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        deviceTokens: List<String>.from(json["device_tokens"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "email": email,
        "type": type,
        "gender": gender,
        "avatar": avatar,
        "graduation_certificate": graduationCertificate,
        "cover_letter": coverLetter,
        "cv": cv,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "device_tokens": List<dynamic>.from(deviceTokens.map((x) => x)),
      };
}
