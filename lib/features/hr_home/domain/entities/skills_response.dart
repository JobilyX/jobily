// To parse this JSON data, do
//
//     final locationInfoPlaceResponse = locationInfoPlaceResponseFromJson(jsonString);

import 'dart:convert';

SkillsResponse locationInfoPlaceResponseFromJson(String str) =>
    SkillsResponse.fromJson(json.decode(str));

String locationInfoPlaceResponseToJson(SkillsResponse data) =>
    json.encode(data.toJson());

class SkillsResponse {
  SkillsResponse({
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

  factory SkillsResponse.fromJson(Map<String, dynamic> json) => SkillsResponse(
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
    required this.skills,
    required this.jobLocation,
    required this.jobPosition,
    required this.jobSections,
  });

  final List<String> skills;
  final List<String> jobPosition;
  final List<String> jobLocation;
  final JobSections jobSections;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        skills: json["skills"] == null
            ? []
            : List<String>.from(json["skills"].map((x) => x)),
        jobLocation: json["job_location"] == null
            ? []
            : List<String>.from(json["job_location"].map((x) => x)),
        jobPosition: json["job_position"] == null
            ? []
            : List<String>.from(json["job_position"].map((x) => x)),
        jobSections: JobSections.fromJson(json["job_sections"]),
      );

  Map<String, dynamic> toJson() => {
        "skills": List<dynamic>.from(skills.map((x) => x)),
        "job_sections": jobSections.toJson(),
      };
}

class JobSections {
  JobSections({
    required this.skills,
    required this.jobLocation,
    required this.jobPosition,
    required this.jobTitle,
    required this.uploadCoverLetter,
    required this.uploadGraduationCertificate,
    required this.coverLetter,
    required this.gradCer,
    required this.deptField,
    required this.endDate,
    required this.startDate,
    required this.fieldEducation,
    required this.faculty,
    required this.previousWork,
    required this.expectedSalary,
    required this.yearsOfExperience,
  });

  final String skills;
  final String jobLocation;
  final String jobPosition;
  final String jobTitle;
  final String uploadCoverLetter;
  final String uploadGraduationCertificate;
  final String coverLetter;
  final String gradCer;
  final String deptField;
  final String endDate;
  final String startDate;
  final String fieldEducation;
  final String faculty;
  final String previousWork;
  final String expectedSalary;
  final String yearsOfExperience;

  factory JobSections.fromJson(Map<String, dynamic> json) => JobSections(
        skills: json["skills"],
        jobLocation: json["job_location"],
        jobPosition: json["job_position"],
        jobTitle: json["job_title"],
        uploadCoverLetter: json["upload_cover_letter"],
        uploadGraduationCertificate: json["upload_graduation_certificate"],
        coverLetter: json["cover_letter"],
        gradCer: json["grad_cer"],
        deptField: json["dept_field"],
        endDate: json["end_date"],
        startDate: json["start_date"],
        fieldEducation: json["field_education"],
        faculty: json["faculty"],
        previousWork: json["previous_work"],
        expectedSalary: json["expected_salary"],
        yearsOfExperience: json["years_of_experience"],
      );

  Map<String, dynamic> toJson() => {
        "skills": skills,
        "job_location": jobLocation,
        "job_position": jobPosition,
        "job_title": jobTitle,
        "upload_cover_letter": uploadCoverLetter,
        "upload_graduation_certificate": uploadGraduationCertificate,
        "cover_letter": coverLetter,
        "grad_cer": gradCer,
        "dept_field": deptField,
        "end_date": endDate,
        "start_date": startDate,
        "field_education": fieldEducation,
        "faculty": faculty,
        "previous_work": previousWork,
        "expected_salary": expectedSalary,
        "years_of_experience": yearsOfExperience,
      };
}
