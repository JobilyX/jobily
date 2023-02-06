import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class OtpCheckCode extends UseCase<String, OtpCodeParams> {
  final AuthRepository repository;
  OtpCheckCode({required this.repository});
  @override
  Future<Either<Failure, String>> call(OtpCodeParams params) async {
    return await repository.checkCodeToResetPass(params: params);
  }
}

class OtpCodeParams {
  String? code;
  String? email;
  OtpCodeParams({this.email, this.code});
}
