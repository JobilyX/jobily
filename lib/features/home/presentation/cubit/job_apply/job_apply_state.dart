part of 'job_apply_cubit.dart';

abstract class JobApplyState extends Equatable {
  const JobApplyState();

  @override
  List<Object> get props => [];
}

class JobApplyInitial extends JobApplyState {}

class JobApplySuccess extends JobApplyState {}

class JobApplyLoading extends JobApplyState {}

class JobApplyError extends JobApplyState {
  const JobApplyError({required this.message});
  final String message;
}
