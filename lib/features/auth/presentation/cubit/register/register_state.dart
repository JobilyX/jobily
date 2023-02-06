part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError({required this.message});
}

class RegisterLoading extends RegisterState {}

class RegisterResendCode extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponse data;

  const RegisterSuccess({required this.data});
}
