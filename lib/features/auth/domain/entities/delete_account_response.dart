// To parse this JSON data, do
//
//     final deleteAccountResponse = deleteAccountResponseFromJson(jsonString);
import 'dart:convert';

DeleteAccountResponse deleteAccountResponseFromJson(String str) =>
    DeleteAccountResponse.fromJson(json.decode(str));
String deleteAccountResponseToJson(DeleteAccountResponse data) =>
    json.encode(data.toJson());

class DeleteAccountResponse {
  DeleteAccountResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.info,
  });
  final int code;
  final bool status;
  final String message;
  final String info;
  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      DeleteAccountResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        info: json["info"],
      );
  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "info": info,
      };
}
