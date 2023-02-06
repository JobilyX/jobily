part of 'get_skills_cubit.dart';

abstract class GetSkillsState extends Equatable {
  const GetSkillsState();

  @override
  List<Object> get props => [];
}

class GetSkillsInitial extends GetSkillsState {}

class GetSkillsSuccess extends GetSkillsState {}

class GetSkillsLoading extends GetSkillsState {}

class GetSkillsError extends GetSkillsState {
  const GetSkillsError({required this.message});
  final String message;
}
