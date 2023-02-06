import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecases/job_apply.dart';
import '../get_jobs/get_jobs_cubit.dart';

part 'job_apply_state.dart';

enum JobStatus { join, report }

class JobApplyCubit extends Cubit<JobApplyState> {
  JobApplyCubit({
    required this.jobApply,
  }) : super(JobApplyInitial());
  final JobApply jobApply;
  String reportMessage = "";
  Future<void> fJobApply(
      {required int jobId, required JobStatus status}) async {
    emit(JobApplyLoading());
    if (sl<GetMyJobsCubit>().checkIfApplybefore(jobId) &&
        status == JobStatus.join) {
      showToast("You have been applied for this job before");
      emit(JobApplyInitial());
      return;
    }

    final failOrRes = await jobApply(JobApplyParams(
        jobId: jobId, applyOrReport: status.name, comment: reportMessage));
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(JobApplyError(message: l.message));
      }
    }, (r) {
      if (status == JobStatus.join) {
        showToast("You have been applied successflly", bG: Colors.green);
        sl<GetMyJobsCubit>().fGetMyJobs();
      } else {
        showToast("You report is under review", bG: Colors.amber);
      }
      emit(JobApplySuccess());
    });
  }
}
