// ignore_for_file: constant_identifier_names

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/register_response.dart';
import '../repositories/auth_repository.dart';

class Register extends UseCase<RegisterResponse, RegisterParams> {
  final AuthRepository repository;

  Register({required this.repository});

  @override
  Future<Either<Failure, RegisterResponse>> call(RegisterParams params) async {
    return await repository.register(params: params);
  }
}

class RegisterParams {
  String type;
  String first;
  String last;
  String email;
  String phone;
  String password;
  String passwordConfirmation;
  String gender;
  String date;
  int acceptTermsConditions;

  RegisterParams({
    required this.type,
    required this.first,
    required this.last,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.gender,
    required this.date,
    required this.acceptTermsConditions,
  });
}
