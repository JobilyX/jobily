import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../domain/usecases/get_skills.dart';

part 'get_skills_state.dart';

class GetSkillsCubit extends Cubit<GetSkillsState> {
  GetSkillsCubit({
    required this.getSkills,
  }) : super(GetSkillsInitial());

  final GetSkills getSkills;
  List<String> skills = [];
  List<String> jobPosition = [];
  List<String> jobLocation = [];
  Future<void> fGetSkills() async {
    emit(GetSkillsLoading());
    final failOrRes = await getSkills(NoParams());
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(GetSkillsError(message: l.message));
      }
    }, (r) {
      skills = r.body.skills;
      jobPosition = r.body.jobPosition;
      jobLocation = r.body.jobLocation;
      emit(GetSkillsSuccess());
    });
  }
}
