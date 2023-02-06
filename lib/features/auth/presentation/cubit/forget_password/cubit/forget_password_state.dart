part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  const ForgetPasswordError({required this.message});
}

class ForgetPasswordHasCode extends ForgetPasswordState {
  final String code;

  const ForgetPasswordHasCode({required this.code});
}

class ForgetPasswordResendCode extends ForgetPasswordState {
  final String code;

  const ForgetPasswordResendCode({required this.code});
}

class ForgetPasswordLoading extends ForgetPasswordState {}
