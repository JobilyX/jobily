// To parse this JSON data, do
//
//     final jobByIdResponse = jobByIdResponseFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jobily/features/cv/presentation/cubit/cv_cubit.dart' as cv;
import 'package:jobily/features/hr_home/presentation/cubit/add_post/add_post_cubit.dart';

JobByIdResponse jobByIdResponseFromJson(String str) =>
    JobByIdResponse.fromJson(json.decode(str));

String jobByIdResponseToJson(JobByIdResponse data) =>
    json.encode(data.toJson());

class JobByIdResponse {
  JobByIdResponse({
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
  factory JobByIdResponse.fromJson(Map<String, dynamic> json) =>
      JobByIdResponse(
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
    required this.job,
    required this.jobApplicants,
  });

  List<double> cvMatchesPercentage = [];
  void calcMatch() {
    double percantage = 0.0;
    for (var element in jobApplicants) {
      log(element.jobSeeker.firstname);
      if (element.cvData[cv.jobPositionIndex].value ==
          job.jobSections[jobPositionIndex].value) {
        percantage += 20;

        log("jobPosition" "+= 20;");
      }
      if (element.cvData[cv.jobLocatonIndex].value ==
          job.jobSections[jobLocatonIndex].value) {
        percantage += 15;
        log("jobLocatonIndex" "+= 15;");
      }
      if ((int.tryParse(element.cvData[cv.yearsOfExperienceIndex].value) ??
              0) >=
          (int.tryParse(job.jobSections[yearsOfExperienceIndex].value) ?? 1)) {
        percantage += 15;
        log("yearsOfExperienceIndex" "+= 15;");
      }
      final cvCom = job.jobSections.sublist(skillsIndex);
      final jobSeekerCom = element.cvData.sublist(cv.skillsIndex);
      log("cvCom.length" "+=  ${cvCom.length};");
      for (var cvComItem in cvCom) {
        if (jobSeekerCom.any((element) => element.value == cvComItem.value)) {
          percantage += 50 / cvCom.length;
          log("${cvComItem.value} " "+=  ${60 / cvCom.length};");
          log("percantage $percantage " "+=  60 / cvCom.length;");
        }
      }
      log("percantage total $percantage ");
      cvMatchesPercentage.add(percantage);
      percantage = 0.0;
    }
  }

  final Job job;
  final List<JobApplicant> jobApplicants;
  factory Body.fromJson(Map<String, dynamic> json) => Body(
        job: Job.fromJson(json["job"]),
        jobApplicants: List<JobApplicant>.from(json["job_applicants"].map(
          (x) => JobApplicant.fromJson(x),
        )),
      )..calcMatch();

  Map<String, dynamic> toJson() => {
        "job": job.toJson(),
        "job_applicants":
            List<dynamic>.from(jobApplicants.map((x) => x.toJson())),
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
  final JobSeeker hr;
  final String title;
  final String description;
  final String salaryFrom;
  final String salaryTo;
  final DateTime createdAt;
  final List<JobSection> jobSections;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        hr: JobSeeker.fromJson(json["hr"]),
        title: json["title"],
        description: json["description"],
        salaryFrom: json["salary_from"],
        salaryTo: json["salary_to"],
        createdAt: DateTime.parse(json["created_at"]),
        jobSections: List<JobSection>.from(
            json["job_sections"].map((x) => JobSection.fromJson(x))),
      );

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

class JobSeeker {
  JobSeeker({
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
    required this.info,
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
  final Info info;
  final List<String> deviceTokens;

  factory JobSeeker.fromJson(Map<String, dynamic> json) => JobSeeker(
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
        info: Info.fromJson(json["info"]),
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
        "info": info.toJson(),
        "device_tokens": List<dynamic>.from(deviceTokens.map((x) => x)),
      };
}

class Info {
  Info({
    required this.languageCode,
  });

  final String languageCode;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        languageCode: json["language_code"],
      );

  Map<String, dynamic> toJson() => {
        "language_code": languageCode,
      };
}

class JobSection {
  JobSection({
    required this.id,
    required this.section,
    required this.value,
  });

  final int id;
  final String section;
  final String value;

  factory JobSection.fromJson(Map<String, dynamic> json) => JobSection(
        id: json["id"],
        section: json["section"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "section": section,
        "value": value,
      };
}

class JobApplicant {
  JobApplicant({
    required this.jobSeeker,
    required this.cvData,
    required this.status,
    required this.isAccepted,
  });

  final JobSeeker jobSeeker;
  final List<JobSection> cvData;
  String status;
  bool isAccepted;

  factory JobApplicant.fromJson(Map<String, dynamic> json) => JobApplicant(
        jobSeeker: JobSeeker.fromJson(json["job_seeker"]),
        cvData: List<JobSection>.from(
            json["cv_data"].map((x) => JobSection.fromJson(x))),
        status: json["status"],
        isAccepted: json["is_accepted"],
      );

  Map<String, dynamic> toJson() => {
        "job_seeker": jobSeeker.toJson(),
        "cv_data": List<dynamic>.from(cvData.map((x) => x.toJson())),
        "status": status,
        "is_accepted": isAccepted,
      };
}
