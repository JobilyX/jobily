import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/get_password_reset_response.dart';
import '../repositories/auth_repository.dart';

class ResetPassword
    extends UseCase<GetPasswordResetCodeResponse, ResetPasswordParams> {
  final AuthRepository repository;
  ResetPassword({required this.repository});
  @override
  Future<Either<Failure, GetPasswordResetCodeResponse>> call(
      ResetPasswordParams params) async {
    return await repository.resetPassword(params: params);
  }
}

class ResetPasswordParams {
  // String? email;
  String? email;
  ResetPasswordParams({
    this.email,
  });
}
