import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/jobs_repsonse.dart';
import '../repositories/post_repository.dart';

class DeleteJobPost extends UseCase<JobsResponse, DeleteJobPostParams> {
  final PostRepository repository;

  DeleteJobPost({required this.repository});
  @override
  Future<Either<Failure, JobsResponse>> call(DeleteJobPostParams params) async {
    return await repository.deleteJob(params: params);
  }
}

class DeleteJobPostParams {
  final String jobid;
  DeleteJobPostParams({
    required this.jobid,
  });
}
