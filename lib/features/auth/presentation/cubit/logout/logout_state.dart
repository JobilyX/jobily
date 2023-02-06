part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final String message;

  const LogoutSuccess({required this.message});
}

class LogoutError extends LogoutState {
  final String message;

  const LogoutError({required this.message});
}

class LogoutLoading extends LogoutState {}
