import 'dart:convert';

class LoginResponseModel {
  final String refresh;
  String access;
  final int id;
  LoginResponseModel({
    required this.refresh,
    required this.access,
    required this.id,
  });

  LoginResponseModel copyWith({
    String? refresh,
    String? access,
    int? id,
  }) {
    return LoginResponseModel(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'refresh token': refresh,
      'access token': access,
      'id': id,
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      refresh: map['refresh token'],
      access: map['access token'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) =>
      LoginResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LoginResponse(refresh: $refresh, access: $access, email: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginResponseModel &&
        other.refresh == refresh &&
        other.access == access &&
        other.id == id;
  }

  @override
  int get hashCode => refresh.hashCode ^ access.hashCode ^ id.hashCode;
}
