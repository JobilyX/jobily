import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/job_byid_reponse.dart';
import '../../../domain/usecases/get_job_byid.dart';

part 'get_post_by_id_state.dart';

class GetPostByIdCubit extends Cubit<GetPostByIdState> {
  GetPostByIdCubit({
    required this.getJobPostById,
  }) : super(GetPostByIdInitial());
  final GetJobPostById getJobPostById;
  moveBack({required JobByIdResponse r, required JobApplicant jobApplicant}) {
    emit(GetPostByIdChangeStatusLoading(id: jobApplicant.jobSeeker.id));
    r.body.jobApplicants.add(jobApplicant);
    r.body.jobApplicants.remove(jobApplicant);
    r.body.cvMatchesPercentage.add(r.body.cvMatchesPercentage.first);
    r.body.cvMatchesPercentage.remove(r.body.cvMatchesPercentage.first);
    emit(GetPostByIdSuccess(response: r));
  }

  changeJobSeekerStatus(
      {required JobByIdResponse r,
      required JobApplicant jobApplicant,
      required bool isAceepted}) {
    emit(GetPostByIdChangeStatusLoading(id: jobApplicant.jobSeeker.id));
    jobApplicant.isAccepted = isAceepted;
    jobApplicant.status = isAceepted ? "accepted" : "refused";
    r.body.jobApplicants[r.body.jobApplicants.indexWhere(
            (element) => element.jobSeeker.id == jobApplicant.jobSeeker.id)] =
        jobApplicant;
    r.body.cvMatchesPercentage.add(r.body.cvMatchesPercentage.first);
    r.body.cvMatchesPercentage.remove(r.body.cvMatchesPercentage.first);
    r.body.jobApplicants.add(jobApplicant);
    r.body.jobApplicants.remove(jobApplicant);
    emit(GetPostByIdSuccess(response: r));
  }

  Future<void> fGetJobPostById({required int jobId}) async {
    emit(GetPostByIdLoading());
    final failOrRes =
        await getJobPostById(GetJobPostByIdParams(jobId: jobId.toString()));
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(GetPostByIdError(message: l.message));
      }
    }, (r) {
      emit(GetPostByIdSuccess(response: r));
    });
  }
}
