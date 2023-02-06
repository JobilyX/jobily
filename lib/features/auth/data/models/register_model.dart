// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import '../../domain/entities/register_response.dart';

// class RegisterResponseModel extends RegisterResponse {
//   RegisterResponseModel({
//     required this.requestModel,
//     required super.code,
//   }) : super(request: requestModel);
//   final RegisterInfoModel requestModel;
//   factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
//       RegisterResponseModel(
//         requestModel: RegisterInfoModel.fromJson(json['body']["request"]),
//         code: json['body']["code"].toString(),
//       );
//   @override
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'request': requestModel.toMap(),
//       'code': code,
//     };
//   }
// }

// class RegisterInfoModel extends RegisterInfo {
//   RegisterInfoModel({
//     required super.date,
//     required super.type,
//     required super.firstName,
//     required super.lastName,
//     required super.phone,
//     required super.email,
//     required super.gender,
//     required super.password,
//     required super.acceptTermsConditions,
//     required super.passwordConfirmation,
//   });
//   factory RegisterInfoModel.fromJson(Map<String, dynamic> json) =>
//       RegisterInfoModel(
//         date: json["date_of_birth"],
//         type: json["type"],
//         firstName: json["firstname"],
//         lastName: json["lastname"],
//         phone: json["phone"],
//         email: json["email"],
//         gender: json["gender"],
//         password: json["password"],
//         acceptTermsConditions: json["accept_terms_conditions"],
//         passwordConfirmation: json["password_confirmation"],
//       );
//   @override
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'phone': phone,
//       'email': email,
//       'gender': gender,
//       'type': type,
//       'password': password,
//       'accept_terms_conditions': acceptTermsConditions,
//       'password_confirmation': passwordConfirmation,
//       "date_of_birth": date
//     };
//   }
// }
