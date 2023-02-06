part of 'accept_applicents_cubit.dart';

abstract class AcceptApplicentsState extends Equatable {
  const AcceptApplicentsState();

  @override
  List<Object> get props => [];
}

class AcceptApplicentsInitial extends AcceptApplicentsState {}

class AcceptApplicentsSuccess extends AcceptApplicentsState {}

class AcceptApplicentsLoading extends AcceptApplicentsState {}

class AcceptApplicentsError extends AcceptApplicentsState {
  const AcceptApplicentsError({required this.message});
  final String message;
}
