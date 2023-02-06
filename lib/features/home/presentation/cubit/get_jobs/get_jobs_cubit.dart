import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../hr_home/domain/entities/jobs_repsonse.dart';
import '../../../domain/usecases/get_my_jobs.dart';

part 'get_jobs_state.dart';

class GetMyJobsCubit extends Cubit<GetMyJobsState> {
  GetMyJobsCubit({required this.getMyJobs}) : super(GetJobsInitial());
  bool checkIfApplybefore(int jobId) {
    return myJobs.any((element) => element.id == jobId);
  }

  final GetMyJobs getMyJobs;
  List<Job> myJobs = [];
  Future<void> fGetMyJobs() async {
    emit(GetJobsLoading());
    final failOrRes = await getMyJobs(NoParams());
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(GetJobsError(message: l.message));
      }
    }, (r) {
      myJobs = r.body.myJobs.data;
      emit(GetJobsSuccess());
    });
  }
}
