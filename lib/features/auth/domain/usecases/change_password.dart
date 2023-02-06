import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase extends UseCase<String, ChangePasswordParams> {
  final AuthRepository repository;
  ChangePasswordUseCase({required this.repository});
  @override
  Future<Either<Failure, String>> call(ChangePasswordParams params) async {
    return await repository.changePassword(params: params);
  }
}

class ChangePasswordParams {
  String currentPassword;
  String newPassword;
  String confirmNewPassword;
  ChangePasswordParams(
      {required this.confirmNewPassword,
      required this.currentPassword,
      required this.newPassword});
}
