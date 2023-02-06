import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/jobs_fillter_response.dart';
import '../entities/my_jobs_reposnse.dart';
import '../usecases/get_jobs_fillter.dart';
import '../usecases/job_apply.dart';

abstract class HomeRepository {
  Future<Either<Failure, String>> jobApply({required JobApplyParams params});
  Future<Either<Failure, MyJobsResponse>> getMyJobs();
  Future<Either<Failure, GetJobsFillterResponse>> getJobsFillter(
      {required GetJobsFillterParams params});
}
