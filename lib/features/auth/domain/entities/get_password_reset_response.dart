// To parse this JSON data, do
//
//     final getPasswordResetCodeResponse = getPasswordResetCodeResponseFromJson(jsonString);
class GetPasswordResetCodeResponse {
  GetPasswordResetCodeResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.body,
    required this.info,
  });

  final int code;
  final bool status;
  final String message;
  final ForgetPassBody body;
  final String? info;
  factory GetPasswordResetCodeResponse.fromMap(Map<String, dynamic> map) =>
      GetPasswordResetCodeResponse(
        code: map["code"],
        status: map["status"],
        message: map["message"],
        body: ForgetPassBody.fromMap(map["body"]),
        info: map["info"],
      );
}

class ForgetPassBody {
  ForgetPassBody({
    required this.request,
    required this.code,
    // required this.phone,
  });
  Request request;
  int code;
  factory ForgetPassBody.fromMap(Map<String, dynamic> json) => ForgetPassBody(
        request: Request.fromMap(json["request"]),
        code: json["code"],
      );
}

class Request {
  Request({
    this.phone,
  });

  final String? phone;

  factory Request.fromMap(Map<String, dynamic> json) => Request(
        phone: json["email"],
      );
}
