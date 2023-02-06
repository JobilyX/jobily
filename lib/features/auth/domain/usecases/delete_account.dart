import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/delete_account_response.dart';
import '../repositories/auth_repository.dart';

class DeleteAccount extends UseCase<DeleteAccountResponse, NoParams> {
  final AuthRepository repository;
  DeleteAccount({required this.repository});
  @override
  Future<Either<Failure, DeleteAccountResponse>> call(NoParams params) async {
    return await repository.deleteAccount();
  }
}
