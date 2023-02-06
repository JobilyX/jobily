import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../domain/entities/jobs_repsonse.dart';
import '../../../domain/usecases/delete_job.dart';
import '../../../domain/usecases/get_job_byid.dart';
import '../../../domain/usecases/get_jobs.dart';

part 'get_posts_state.dart';

class GetPostsCubit extends Cubit<GetPostsState> {
  GetPostsCubit({
    required this.getJobPosts,
    required this.deleteJobPost,
    required this.getJobPostById,
  }) : super(GetPostsInitial());

  final GetJobPosts getJobPosts;
  final DeleteJobPost deleteJobPost;
  final GetJobPostById getJobPostById;
  List<Job> jobsList = [];
  addPostsFromOustSide(List<Job> newjobsList) {
    emit(GetPostsLoading());
    jobsList = newjobsList.reversed.toList();
    emit(GetPostsSuccess());
  }

  Future<void> fGetPosts() async {
    emit(GetPostsLoading());
    final failOrRes = await getJobPosts(NoParams());
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(GetPostsError(message: l.message));
      }
    }, (r) {
      jobsList = r.body.hrJobs.data.reversed.toList();
      emit(GetPostsSuccess());
    });
  }

  Future<void> fDeleteJobPost({required int jobid}) async {
    emit(DeleteLoading(id: jobid));
    final failOrRes =
        await deleteJobPost(DeleteJobPostParams(jobid: jobid.toString()));
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(GetPostsError(message: l.message));
      }
    }, (r) {
      jobsList = r.body.hrJobs.data.reversed.toList();
      emit(GetPostsSuccess());
    });
  }
}
