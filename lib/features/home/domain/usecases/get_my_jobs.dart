import 'package:dartz/dartz.dart';

import 'package:jobily/features/home/domain/repositories/home_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/my_jobs_reposnse.dart';

class GetMyJobs extends UseCase<MyJobsResponse, NoParams> {
  final HomeRepository repository;
  GetMyJobs({
    required this.repository,
  });
  @override
  Future<Either<Failure, MyJobsResponse>> call(NoParams params) async {
    return await repository.getMyJobs();
  }
}
