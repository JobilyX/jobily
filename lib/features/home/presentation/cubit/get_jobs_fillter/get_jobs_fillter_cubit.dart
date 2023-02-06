import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../injection_container.dart';
import '../../../../cv/presentation/cubit/cv_cubit.dart' as cv;
import '../../../../hr_home/domain/entities/jobs_repsonse.dart';
import '../../../../hr_home/presentation/cubit/add_post/add_post_cubit.dart';
import '../../../domain/usecases/get_jobs_fillter.dart';

part 'get_jobs_fillter_state.dart';

class GetJobsFillterCubit extends Cubit<GetJobsFillterState> {
  GetJobsFillterCubit({
    required this.getJobsFillter,
  }) : super(GetJobsFillterInitial());

  final GetJobsFillter getJobsFillter;
  int selctedTap = 0;
  toggleSelctedTap(int newTap) {
    emit(GetJobsFillterInitial());
    selctedTap = newTap;
    emit(GetJobsFillterSuccess());
  }

  fEmitChangeFillter() {
    emit(GetJobsFillterInitial());
    emit(GetJobsFillterSuccess());
  }

  List<cv.CvComponent> listOfComp = [
    cv.CvComponent(sectionName: "job_position"),
    cv.CvComponent(sectionName: "job_location"),
    cv.CvComponent(sectionName: "years_of_experience"),
    cv.CvComponent(sectionName: "field_education"),
    cv.CvComponent(sectionName: "skills"),
  ];
  String salaryFrom = "";
  String salaryTo = "";
  String jobTitle = "";
  void reset() {
    listOfComp = [
      cv.CvComponent(sectionName: "job_position"),
      cv.CvComponent(sectionName: "job_location"),
      cv.CvComponent(sectionName: "years_of_experience"),
      cv.CvComponent(sectionName: "field_education"),
      cv.CvComponent(sectionName: "skills"),
    ];
    salaryFrom = "";
    salaryTo = "";
    jobTitle = "";
    selctedTap = 0;
  }

  Map<String, dynamic> getRequestBody() {
    Map<String, dynamic> sendedMap = {};
    int mapKeyCounter = 1;
    for (int i = 0; i < listOfComp.length; i++) {
      if (listOfComp[i].sectionvalues.isNotEmpty &&
          listOfComp[i].sectionvalues.first.isNotEmpty) {
        sendedMap["sections[$mapKeyCounter][name]"] = listOfComp[i].sectionName;
        sendedMap["sections[$mapKeyCounter][values][]"] =
            listOfComp[i].sectionvalues.first;
      }
    }
    if (salaryFrom.isNotEmpty) {
      sendedMap.addAll({"salary_from": salaryFrom});
    }
    if (salaryTo.isNotEmpty) {
      sendedMap.addAll({"salary_to": salaryTo});
    }
    if (jobTitle.isNotEmpty) {
      sendedMap.addAll({"jobTitle": jobTitle});
    }
    return sendedMap;
  }

  bool ifThereFillters() {
    return listOfComp.any((element) =>
            element.sectionvalues.isNotEmpty &&
            element.sectionvalues.first.isNotEmpty) ||
        salaryFrom.isNotEmpty ||
        salaryTo.isNotEmpty;
  }

  List<Job> fillterJobs = [];
  List<Job> listaAfterMatch = [];
  List<Job> getJobs({required bool withMatch}) {
    emit(GetJobsFillterLoading());
    final cvCubit = sl<cv.CvCubit>();
    if (withMatch) {
      listaAfterMatch = fillterJobs
          .where((element) =>
              element.listOfComp[jobPositionIndex].sectionvalues.first ==
              cvCubit.listOfComp[cv.jobPositionIndex].sectionvalues.first)
          .where((element) =>
              element.listOfComp[jobLocatonIndex].sectionvalues.first ==
              cvCubit.listOfComp[cv.jobLocatonIndex].sectionvalues.first)
          .where((element) =>
              int.parse(element
                  .listOfComp[yearsOfExperienceIndex].sectionvalues.first) <=
              int.parse(cvCubit
                  .listOfComp[cv.yearsOfExperienceIndex].sectionvalues.first))
          .toList();
      emit(GetJobsFillterSuccess());
      return listaAfterMatch;
    } else {
      emit(GetJobsFillterSuccess());
      return fillterJobs;
    }
  }

  moveBack(Job job, bool withMatch) {
    emit(GetJobsFillterInitial());
    if (withMatch) {
      listaAfterMatch.add(job);
      listaAfterMatch.remove(job);
    } else {
      fillterJobs.add(job);
      fillterJobs.remove(job);
    }
    emit(GetJobsFillterSuccess());
  }

  Future<void> fGetJobsFillter() async {
    emit(GetJobsFillterLoading());
    final failOrRes =
        await getJobsFillter(GetJobsFillterParams(map: getRequestBody()));
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(GetJobsFillterError(message: l.message));
      }
    }, (r) {
      fillterJobs = r.body.hrJobs.data;
      getJobs(withMatch: true);
      emit(GetJobsFillterSuccess());
    });
  }

  Timer? _debounce;

  Future<void> fGetJobsFillterByTitle() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(GetJobsFillterLoading());
      final failOrRes =
          await getJobsFillter(GetJobsFillterParams(map: getRequestBody()));
      failOrRes.fold((l) {
        if (l is ServerFailure) {
          emit(GetJobsFillterError(message: l.message));
        }
      }, (r) {
        fillterJobs = r.body.hrJobs.data;
        getJobs(withMatch: true);
        emit(GetJobsFillterSuccess());
      });
    });
  }
}
