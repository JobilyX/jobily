import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../../cv/presentation/cubit/cv_cubit.dart';
import '../../../domain/entities/jobs_repsonse.dart';
import '../../../domain/usecases/add_job_post.dart';
import '../job_posts/get_posts_cubit.dart';

part 'add_post_state.dart';

const jobPositionIndex = 0;
const jobLocatonIndex = 1;
const yearsOfExperienceIndex = 2;
// const genderIndex = 3;
const fieldEducationIndex = 3; //4
const skillsIndex = 4; //5

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit({
    required this.addPost,
  }) : super(AddPostInitial());
  final AddJobPost addPost;
  initJob({required Job? job}) {
    if (job != null) {
      listOfComp = job.listOfComp;
    }
  }

  void fAddSkill(String skill) {
    emit(AddPostChangeSkill());
    if (!listOfComp[skillsIndex].sectionvalues.contains(skill)) {
      listOfComp[skillsIndex].sectionvalues.add(skill);
    }
    emit(AddPostInitial());
  }

  void fRemoveSkill(String skill) {
    emit(AddPostChangeSkill());
    listOfComp[skillsIndex].sectionvalues.remove(skill);
    emit(AddPostInitial());
  }

  List<CvComponent> listOfComp = [
    CvComponent(sectionName: "job_position"),
    CvComponent(sectionName: "job_location"),
    CvComponent(sectionName: "years_of_experience"),
    // CvComponent(sectionName: "gender"),
    CvComponent(sectionName: "field_education"),
    CvComponent(sectionName: "skills"),
  ];
  Map<String, dynamic> getPostMap() {
    Map<String, dynamic> map = {};
    for (int i = 0; i < listOfComp.length - 1; i++) {
      map.addAll({
        "sections[${i + 1}][name]": listOfComp[i].sectionName,
        "sections[${i + 1}][values][]": listOfComp[i].sectionvalues.first
      });
    }
    map.addAll({
      "sections[${skillsIndex + 1}][name]": listOfComp[skillsIndex].sectionName,
      "sections[${skillsIndex + 1}][values][]":
          listOfComp[skillsIndex].sectionvalues
    });
    return map;
  }

  Future<void> fAddPost({
    required String title,
    required String description,
    required String salaryFrom,
    required String salaryTo,
    required bool isEdit,
    int? postId,
  }) async {
    emit(AddPostLoading());
    final map = getPostMap();
    map.addAll({
      "title[ar]": title,
      "description[ar]": description,
      "salary_from": salaryFrom,
      "salary_to": salaryTo,
    });
    final failOrRes = await addPost(
        AddJobPostParams(postId: postId, map: map, isEdit: isEdit));
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(AddPostError(message: l.message));
      }
    }, (r) {
      sl<GetPostsCubit>().addPostsFromOustSide(r.body.hrJobs.data);
      if (isEdit) {
        showToast("Job Post has been edited successsflly");
      } else {
        showToast("Job Post has been added successsflly");
      }

      emit(AddPostSuccess());
    });
  }
}
