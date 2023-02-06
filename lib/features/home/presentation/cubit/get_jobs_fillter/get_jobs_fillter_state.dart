part of 'get_jobs_fillter_cubit.dart';

abstract class GetJobsFillterState extends Equatable {
  const GetJobsFillterState();

  @override
  List<Object> get props => [];
}

class GetJobsFillterInitial extends GetJobsFillterState {}

class GetJobsFillterSuccess extends GetJobsFillterState {}

class GetJobsFillterLoading extends GetJobsFillterState {}

class GetJobsFillterError extends GetJobsFillterState {
  const GetJobsFillterError({required this.message});
  final String message;
}
