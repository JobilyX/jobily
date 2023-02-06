import 'package:dartz/dartz.dart';
import 'package:jobily/features/settings/domain/entities/get_complain_types.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class GetComplaintTypes extends UseCase<ComplaintTypes, NoParams> {
  final SettingsRepository repository;

  GetComplaintTypes({required this.repository});

  @override
  Future<Either<Failure, ComplaintTypes>> call(NoParams params) async {
    return await repository.getComplaintTypes();
  }
}
