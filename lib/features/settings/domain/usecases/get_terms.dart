import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class GetAppTerms extends UseCase<Unit, GetAppTermsParams> {
  final SettingsRepository repository;

  GetAppTerms({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(GetAppTermsParams params) async {
    return await repository.getAppTerms(params: params);
  }
}

class GetAppTermsParams {}
