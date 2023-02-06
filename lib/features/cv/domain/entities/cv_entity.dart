// To parse this JSON data, do
//
//     final cvResponse = cvResponseFromJson(jsonString);

import 'dart:convert';

CvResponse? cvResponseFromJson(String str) =>
    CvResponse.fromJson(json.decode(str));

String cvResponseToJson(CvResponse? data) => json.encode(data!.toJson());

class CvResponse {
  CvResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.body,
    required this.info,
  });

  int code;
  bool status;
  String message;
  Body body;
  String info;

  factory CvResponse.fromJson(Map<String, dynamic> json) => CvResponse(
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
    required this.userCv,
  });

  List<UserCv> userCv;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        userCv: json["user_cv"] == null
            ? []
            : List<UserCv>.from(
                json["user_cv"]!.map((x) => UserCv.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_cv": userCv.isEmpty
            ? []
            : List<dynamic>.from(userCv.map((x) => x.toJson())),
      };
}

class UserCv {
  UserCv({
    required this.id,
    required this.section,
    required this.key,
    required this.value,
  });

  int id;
  String section;
  String key;
  String value;

  factory UserCv.fromJson(Map<String, dynamic> json) => UserCv(
        id: json["id"],
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
