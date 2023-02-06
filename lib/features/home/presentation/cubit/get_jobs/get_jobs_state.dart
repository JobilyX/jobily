part of 'get_jobs_cubit.dart';

abstract class GetMyJobsState extends Equatable {
  const GetMyJobsState();

  @override
  List<Object> get props => [];
}

class GetJobsInitial extends GetMyJobsState {}

class GetJobsSuccess extends GetMyJobsState {}

class GetJobsLoading extends GetMyJobsState {}

class GetJobsError extends GetMyJobsState {
  const GetJobsError({required this.message});
  final String message;
}
