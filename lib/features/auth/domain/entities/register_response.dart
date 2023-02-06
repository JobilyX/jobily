import 'dart:convert';

import '../usecases/register.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class RegisterResponse {
  RegisterResponse({
    required this.request,
    required this.code,
    this.registerParams,
  });

  final RegisterInfo request;
  String code;
  RegisterParams? registerParams;
  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        request: RegisterInfo.fromMap(json["request"]),
        code: json["code"].toString(),
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'request': request,
      'code': code,
    };
  }
}

class RegisterInfo {
  RegisterInfo({
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.phone,
    required this.email,
    required this.gender,
    required this.date,
    required this.password,
    required this.acceptTermsConditions,
    required this.passwordConfirmation,
  });
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String date;
  final String type;
  final String gender;
  final String password;
  final String acceptTermsConditions;
  final String passwordConfirmation;

  RegisterInfo copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? gender,
    String? password,
    String? date,
    String? acceptTermsConditions,
    String? passwordConfirmation,
    String? type,
  }) {
    return RegisterInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      type: type ?? this.type,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      acceptTermsConditions:
          acceptTermsConditions ?? this.acceptTermsConditions,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'email': email,
      'gender': gender,
      'type': type,
      "date_of_birth": date,
      'password': password,
      'accept_terms_conditions': acceptTermsConditions,
      'password_confirmation': passwordConfirmation,
    };
  }

  factory RegisterInfo.fromMap(Map<String, dynamic> map) {
    return RegisterInfo(
      date: map["date_of_birth"],
      firstName: map['firstname'],
      lastName: map['lastname'],
      type: map["type"],
      phone: map['phone'],
      email: map['email'],
      gender: map['gender'],
      password: map['password'],
      acceptTermsConditions: map['accept_terms_conditions'],
      passwordConfirmation: map['password_confirmation'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterInfo.fromJson(String source) =>
      RegisterInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant RegisterInfo other) {
    if (identical(this, other)) return true;

    return other.phone == phone &&
        other.email == email &&
        other.gender == gender &&
        other.password == password &&
        other.acceptTermsConditions == acceptTermsConditions &&
        other.passwordConfirmation == passwordConfirmation;
  }

  @override
  int get hashCode {
    return phone.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        password.hashCode ^
        acceptTermsConditions.hashCode ^
        passwordConfirmation.hashCode;
  }
}
