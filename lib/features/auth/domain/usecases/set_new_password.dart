
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class SetNewPassword
    extends UseCase<void, SetNewPasswordParams> {
  final AuthRepository repository;
  SetNewPassword({required this.repository});
  @override
  Future<Either<Failure, void>> call(
      SetNewPasswordParams params) async {
    return await repository.setNewPassword(params: params);
  }
}

class SetNewPasswordParams {
  String? newPassword;
  String? confirmPassword;
  String? token;
  SetNewPasswordParams({ this.newPassword, this.confirmPassword, this.token});
}
