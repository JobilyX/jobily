import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class GetAppOrgInfo extends UseCase<Unit, GetAppOrgInfoParams> {
  final SettingsRepository repository;

  GetAppOrgInfo({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(GetAppOrgInfoParams params) async {
    return await repository.getAppOrgInfo(params: params);
  }
}

class GetAppOrgInfoParams {}
