// To parse this JSON data, do
//
//     final cvFileResponse = cvFileResponseFromJson(jsonString);

import 'dart:convert';

CvFileResponse? cvFileResponseFromJson(String str) =>
    CvFileResponse.fromJson(json.decode(str));

String cvFileResponseToJson(CvFileResponse? data) =>
    json.encode(data!.toJson());

class CvFileResponse {
  CvFileResponse({
    this.name,
    this.email,
    this.skills,
    this.education,
    this.experience,
  });

  String? name;
  String? email;
  List<String>? skills;
  List<Education>? education;
  List<Experience>? experience;

  factory CvFileResponse.fromJson(Map<String, dynamic> json) => CvFileResponse(
        name: json["name"],
        email: json["email"],
        skills: json["skills"] == null
            ? []
            : List<String>.from(json["skills"]!.map((x) => x)),
        education: json["education"] == null
            ? []
            : List<Education>.from(
                json["education"]!.map((x) => Education.fromJson(x))),
        experience: json["experience"] == null
            ? []
            : List<Experience>.from(
                json["experience"]!.map((x) => Experience.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "education": education == null
            ? []
            : List<dynamic>.from(education!.map((x) => x.toJson())),
        "experience": experience == null
            ? []
            : List<dynamic>.from(experience!.map((x) => x.toJson())),
      };
}

class Education {
  Education({
    required this.name,
    required this.dates,
  });

  String name;
  List<String> dates;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        name: json["name"] ?? "",
        dates: json["dates"] == null
            ? []
            : List<String>.from(json["dates"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "dates": List<dynamic>.from(dates.map((x) => x)),
      };
}

class Experience {
  Experience({
    this.title,
    this.dates,
    this.dateStart,
    this.dateEnd,
    this.location,
    this.organization,
  });

  String? title;
  List<String?>? dates;
  String? dateStart;
  String? dateEnd;
  String? location;
  String? organization;

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        title: json["title"],
        dates: json["dates"] == null
            ? []
            : List<String?>.from(json["dates"]!.map((x) => x)),
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        location: json["location"],
        organization: json["organization"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => x)),
        "date_start": dateStart,
        "date_end": dateEnd,
        "location": location,
        "organization": organization,
      };
}
