import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class Logout extends UseCase<String, NoParams> {
  final AuthRepository repository;
  Logout({required this.repository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.logout();
  }
}


