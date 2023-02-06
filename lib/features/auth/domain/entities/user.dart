// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

import 'package:jobily/features/auth/presentation/cubit/auto_login/auto_login_cubit.dart';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
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

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
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
    required this.user,
    required this.accessToken,
  });

  User user;
  final String accessToken;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        user: User.fromJson(json["user"]),
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "access_token": accessToken,
      };
}

class User {
  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.type,
    required this.gender,
    required this.avatar,
    required this.fcm,
    required this.dateOfBirth,
    required this.info,
  });

  final int id;
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final UserType type;
  final String gender;
  final String avatar;
  final List<String> fcm;
  final DateTime dateOfBirth;
  final Info info;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        email: json["email"],
        type: json["type"] == "HR" ? UserType.hr : UserType.job_seeker,
        gender: json["gender"],
        avatar: json["avatar"],
        fcm: List<String>.from(json["device_tokens"].map((x) => x)),
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        info: Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "email": email,
        "type": type.name,
        "gender": gender,
        "avatar": avatar,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "info": info.toJson(),
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
