import 'package:dartz/dartz.dart';
import 'package:jobily/features/hr_home/domain/entities/jobs_repsonse.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/post_repository.dart';

class GetJobPosts extends UseCase<JobsResponse, NoParams> {
  final PostRepository repository;

  GetJobPosts({required this.repository});
  @override
  Future<Either<Failure, JobsResponse>> call(NoParams params) async {
    return await repository.getJobs();
  }
}
