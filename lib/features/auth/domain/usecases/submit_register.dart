// ignore_for_file: constant_identifier_names

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/register_response.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SubmitRegister extends UseCase<UserResponse, RegisterResponse> {
  final AuthRepository repository;

  SubmitRegister({required this.repository});

  @override
  Future<Either<Failure, UserResponse>> call(RegisterResponse params) async {
    return await repository.submitRegister(params: params);
  }
}
