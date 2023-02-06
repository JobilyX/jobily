part of 'set_new_password_cubit.dart';

abstract class SetNewPasswordState extends Equatable {
  const SetNewPasswordState();

  @override
  List<Object> get props => [];
}

class SetNewPasswordInitial extends SetNewPasswordState {}
class SetNewPasswordSuccess extends SetNewPasswordState {}
class SetNewPasswordError extends SetNewPasswordState {
  final String message;

  const SetNewPasswordError({required this.message}); 
}
class SetNewPasswordLoading extends SetNewPasswordState {}
