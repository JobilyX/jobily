import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/Skills_response.dart';
import '../entities/job_byid_reponse.dart';
import '../entities/jobs_repsonse.dart';
import '../usecases/accept_reject_apllicant.dart';
import '../usecases/add_job_post.dart';
import '../usecases/delete_job.dart';
import '../usecases/get_job_byid.dart';

abstract class PostRepository {
  Future<Either<Failure, SkillsResponse>> getSkills();
  Future<Either<Failure, JobsResponse>> getJobs();
  Future<Either<Failure, Unit>> acceptRejectApplicants(
      {required AcceptRejectApplicantsParams params});
  Future<Either<Failure, JobsResponse>> deleteJob(
      {required DeleteJobPostParams params});
  Future<Either<Failure, JobByIdResponse>> getJobById(
      {required GetJobPostByIdParams params});
  Future<Either<Failure, JobsResponse>> addPost(
      {required AddJobPostParams params});
}
