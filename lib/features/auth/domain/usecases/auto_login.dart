import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AutoLogin extends UseCase<UserResponse, NoParams> {
  final AuthRepository repository;
  AutoLogin({required this.repository});
  @override
  Future<Either<Failure, UserResponse>> call(NoParams params) async {
    return await repository.autoLogin();
  }
}
