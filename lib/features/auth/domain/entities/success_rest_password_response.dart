// To parse this JSON data, do
//
//     final successResetPasswordResponse = successResetPasswordResponseFromJson(jsonString);

import 'dart:convert';

SuccessResetPasswordResponse successResetPasswordResponseFromJson(String str) =>
    SuccessResetPasswordResponse.fromJson(json.decode(str));

String successResetPasswordResponseToJson(SuccessResetPasswordResponse data) =>
    json.encode(data.toJson());

class SuccessResetPasswordResponse {
  SuccessResetPasswordResponse({
    required this.message,
    required this.data,
    required this.error,
  });

  final String message;
  final String data;
  final bool error;

  factory SuccessResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      SuccessResetPasswordResponse(
        message: json["message"],
        data: json["data"],
        error: json["error"],
      );
  factory SuccessResetPasswordResponse.fromMap(Map<String, dynamic> map) =>
      SuccessResetPasswordResponse(
        message: map["message"],
        data: map["data"],
        error: map["error"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
        "error": error,
      };
}
