part of 'regitser_submit_cubit.dart';

abstract class RegisterSubmitState extends Equatable {
  const RegisterSubmitState();

  @override
  List<Object> get props => [];
}

class RegitserSubmitInitial extends RegisterSubmitState {}

class RegisterSubmitError extends RegisterSubmitState {
  final String message;

  const RegisterSubmitError({required this.message});
}

class RegisterSubmitLoading extends RegisterSubmitState {}

class RegisterSubmitSuccess extends RegisterSubmitState {
  final UserResponse user;

  const RegisterSubmitSuccess({required this.user});
}
