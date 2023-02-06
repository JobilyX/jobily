// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobily/core/constant/extintions.dart';
import 'package:jobily/core/error/failures.dart';
import 'package:jobily/core/util/navigator.dart';
import 'package:jobily/core/widgets/toast.dart';
import 'package:jobily/features/cv/domain/usecases/create_cv.dart';
import 'package:jobily/features/cv/domain/usecases/delete_cv.dart';
import 'package:jobily/features/cv/domain/usecases/get_cv.dart';
import 'package:jobily/features/cv/presentation/pages/cv_screen.dart';

import '../../../../core/constant/file_manager/upload_file.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/cv_entity.dart';
import '../../domain/usecases/create_cv_with_file.dart';

part 'cv_state.dart';

const jobTitleIndex = 0;
const jobPositionIndex = 1;
const jobLocatonIndex = 2;
const yearsOfExperienceIndex = 3;
const expectedSalaryIndex = 4;
const previousWorkIndex = 5;
const facultyIndex = 6;
const fieldEducationIndex = 7;
const startDateIndex = 8;
const endDateIndex = 9;
const deptFieldIndex = 10;
const gradCerIndex = 11;
const coverLetterIndex = 12;
const skillsIndex = 13;

class CvCubit extends Cubit<CvState> {
  CvCubit({
    required this.createCv,
    required this.createCvWithFile,
    required this.getCv,
    required this.deleteCv,
  }) : super(CvInitial());
  final CreateCv createCv;
  final CreateCvWithFile createCvWithFile;
  final GetCv getCv;
  final DeleteCv deleteCv;
  void reset() => listOfComp = [
        CvComponent(sectionName: "job_title"),
        CvComponent(sectionName: "job_position"),
        CvComponent(sectionName: "job_location"),
        CvComponent(sectionName: "years_of_experience"),
        CvComponent(sectionName: "expected_salary"),
        CvComponent(sectionName: "previous_work"),
        CvComponent(sectionName: "faculty"),
        CvComponent(sectionName: "field_education"),
        CvComponent(sectionName: "start_date"),
        CvComponent(sectionName: "end_date"),
        CvComponent(sectionName: "dept_field"),
        FileCvComponent(sectionName: "grad_cer"),
        FileCvComponent(sectionName: "cover_letter"),
        CvComponent(sectionName: "skills"),
      ];
  List<CvComponent> listOfComp = [];
  bool coverVaildation1 = false;
  bool coverVaildation2 = false;
  bool checkUserCompleateCv() {
    return listOfComp[skillsIndex].sectionvalues.length < 3;
  }

  bool checkCovers() {
    emit(CvChangeSkill());
    coverVaildation1 = (listOfComp[gradCerIndex] is FileCvComponent &&
            (listOfComp[gradCerIndex] as FileCvComponent).file != null) ||
        (listOfComp[gradCerIndex].sectionvalues.isNotEmpty);
    coverVaildation2 = listOfComp[coverLetterIndex] is FileCvComponent &&
            (listOfComp[coverLetterIndex] as FileCvComponent).file != null ||
        (listOfComp[coverLetterIndex].sectionvalues.isNotEmpty);
    emit(CvInitial());
    return coverVaildation1 && coverVaildation2;
  }

  bool getCoverVaildation(int index) {
    if (index == gradCerIndex) {
      return coverVaildation1;
    }
    if (index == coverLetterIndex) {
      return coverVaildation2;
    }
    return true;
  }

  Future<void> fCreateCvWithFile({
    required PlatformFile file,
    void Function(int, int)? onSendProgress,
  }) async {
    emit(CvLoading());
    final failOrCv = await createCvWithFile(
        CreateCvWithFileParams(file: file, onSendProgress: onSendProgress));
    failOrCv.fold((fail) {
      if (fail is ServerFailure) {
        emit(CvError(message: fail.message));
      }
    }, (right) {
      log(right.toJson().toString());
      listOfComp[skillsIndex].sectionvalues = right.skills!;
      if (right.education != null && right.education!.isNotEmpty) {
        listOfComp[facultyIndex].sectionvalues = [right.education!.first.name];
        if (right.education!.first.dates.isNotEmpty) {
          listOfComp[endDateIndex].sectionvalues = [
            right.education!.first.dates.first
          ];
        }
      }
      if (right.experience != null && right.experience!.isNotEmpty) {
        var element = right.experience!.first;
        listOfComp[jobTitleIndex].sectionvalues.first = element.title ?? "";
        listOfComp[previousWorkIndex].sectionvalues.first =
            ("${element.organization ?? ""}\t ${element.location ?? ""} ${element.dateStart ?? ""} ${element.dateEnd ?? ""}\t");
      }
      sl<AppNavigator>().push(screen: const CVScreen());
      emit(CvSuccess());
    });
  }

  void fAddSkill(String skill) {
    emit(CvChangeSkill());
    if (!listOfComp[skillsIndex].sectionvalues.contains(skill)) {
      listOfComp[skillsIndex].sectionvalues.add(skill);
    }
    emit(CvInitial());
  }

  void fRemoveSkill(String skill) {
    emit(CvChangeSkill());
    listOfComp[skillsIndex].sectionvalues.remove(skill);
    emit(CvInitial());
  }

  Map<String, dynamic> getRequestBody() {
    Map<String, dynamic> map = {};
    for (int i = 0; i < listOfComp.length; i++) {
      map.addAll({
        "sections[${i + 1}][name]": listOfComp[i].sectionName,
        "sections[${i + 1}][values][]": listOfComp[i].sectionvalues
      });
    }
    return map;
  }

  Future<void> updateImages(int index) async {
    final collection = await UploadFileManager.updateFile(
      image: (listOfComp[index] as FileCvComponent).file,
    );
    final temp = listOfComp[index];
    listOfComp[index] = CvComponent(sectionName: temp.sectionName);
    listOfComp[index].sectionvalues = [collection];
  }

  Future<void> fCreateCv({required String userId}) async {
    emit(CvLoading());
    if ((listOfComp[gradCerIndex] is FileCvComponent) &&
        (listOfComp[gradCerIndex] as FileCvComponent).file != null) {
      await updateImages(gradCerIndex);
    }
    if ((listOfComp[coverLetterIndex] is FileCvComponent) &&
        (listOfComp[coverLetterIndex] as FileCvComponent).file != null) {
      await updateImages(coverLetterIndex);
    }
    listOfComp[skillsIndex].sectionvalues =
        listOfComp[skillsIndex].sectionvalues.unique();
    log(listOfComp.toString());
    final map = getRequestBody();
    log(map.toString());
    final failOrCv = await createCv(CreateCvParams(map: map));
    failOrCv.fold((fail) {
      if (fail is ServerFailure) {
        emit(CvError(message: fail.message));
      }
    }, (right) {
      setDate(right);
      showToast("Your Cv created Successfly");
      sl<AppNavigator>().popToFrist();
      emit(CvSuccess());
    });
  }

  Future<void> fGetCv({required String userId}) async {
    emit(CvLoading());
    final failOrCv = await getCv(GetCvParams(userId: userId));
    failOrCv.fold((fail) {
      if (fail is ServerFailure) {
        emit(CvError(message: fail.message));
      }
    }, (right) {
      if (right.body.userCv.isNotEmpty) {
        setDate(right);
      }
      emit(CvSuccess());
    });
  }

  Future<void> fDeleteCv({required String userId}) async {
    emit(CvDeleteLoading());
    final failOrCv = await deleteCv(DeleteCvParams(userId: userId));
    failOrCv.fold((fail) {
      if (fail is ServerFailure) {
        emit(CvError(message: fail.message));
      }
    }, (right) {
      reset();

      emit(CvSuccess());
    });
  }

  void setDate(CvResponse response) {
    final cv = response.body.userCv;
    listOfComp[jobTitleIndex].sectionvalues = [cv[jobTitleIndex].value];
    listOfComp[jobPositionIndex].sectionvalues = [cv[jobPositionIndex].value];
    listOfComp[jobLocatonIndex].sectionvalues = [cv[jobLocatonIndex].value];
    listOfComp[yearsOfExperienceIndex].sectionvalues = [
      cv[yearsOfExperienceIndex].value
    ];
    listOfComp[expectedSalaryIndex].sectionvalues = [
      cv[expectedSalaryIndex].value
    ];
    listOfComp[previousWorkIndex].sectionvalues = [cv[previousWorkIndex].value];
    listOfComp[facultyIndex].sectionvalues = [cv[facultyIndex].value];
    listOfComp[fieldEducationIndex].sectionvalues = [
      cv[fieldEducationIndex].value
    ];
    listOfComp[startDateIndex].sectionvalues = [cv[startDateIndex].value];
    listOfComp[endDateIndex].sectionvalues = [cv[endDateIndex].value];
    listOfComp[deptFieldIndex].sectionvalues = [cv[deptFieldIndex].value];
    listOfComp[gradCerIndex].sectionvalues = [cv[gradCerIndex].value];
    listOfComp[coverLetterIndex].sectionvalues = [cv[coverLetterIndex].value];
    final skills = cv.sublist(skillsIndex);
    listOfComp[skillsIndex].sectionvalues.clear();
    for (UserCv s in skills) {
      listOfComp[skillsIndex].sectionvalues.add(s.value);
    }
    emit(CvSuccess());
  }
}

class CvComponent {
  final String sectionName;
  List<String> sectionvalues = [""];
  CvComponent({
    required this.sectionName,
  });
}

class FileCvComponent extends CvComponent {
  File? file;

  FileCvComponent({
    required super.sectionName,
    this.file,
  });
}
