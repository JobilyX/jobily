import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/home_repository.dart';

class JobApply extends UseCase<String, JobApplyParams> {
  final HomeRepository repository;
  JobApply({
    required this.repository,
  });
  @override
  Future<Either<Failure, String>> call(JobApplyParams params) async {
    return await repository.jobApply(params: params);
  }
}

class JobApplyParams {
  final int jobId;
  final String applyOrReport;
  final String comment;
  JobApplyParams({
    required this.jobId,
    required this.comment,
    required this.applyOrReport,
  });
}
