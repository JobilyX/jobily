import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'register.dart';

class Login extends UseCase<UserResponse, LoginParams> {
  final AuthRepository repository;
  Login({required this.repository});
  @override
  Future<Either<Failure, UserResponse>> call(LoginParams params) async {
    return await repository.login(params: params);
  }
}

class LoginParams {
  String? email;
  String? password;
  String? deviceToken;
  LoginParams({
    this.email,
    this.password,
    this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': email,
      'password': password,
      'device_token': deviceToken,
    };
  }

  factory LoginParams.fromMap(Map<String, dynamic> map) {
    return LoginParams(
        email: map['phone'],
        password: map['password'],
        deviceToken: map["device_token"]);
  }

  factory LoginParams.fromRegisterParams(RegisterParams params) {
    return LoginParams(
      email: params.phone,
      password: params.password,
    );
  }
}
