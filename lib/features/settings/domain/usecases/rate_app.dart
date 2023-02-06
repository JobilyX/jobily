import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class RateApp extends UseCase<Unit, RateAppParams> {
  final SettingsRepository repository;

  RateApp({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(RateAppParams params) async {
    return await repository.rateApp(params: params);
  }
}

class RateAppParams {}
