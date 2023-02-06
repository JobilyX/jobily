import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/job_byid_reponse.dart';
import '../repositories/post_repository.dart';

class GetJobPostById extends UseCase<JobByIdResponse, GetJobPostByIdParams> {
  final PostRepository repository;

  GetJobPostById({required this.repository});
  @override
  Future<Either<Failure, JobByIdResponse>> call(
      GetJobPostByIdParams params) async {
    return await repository.getJobById(params: params);
  }
}

class GetJobPostByIdParams {
  final String jobId;
  GetJobPostByIdParams({
    required this.jobId,
  });
}
