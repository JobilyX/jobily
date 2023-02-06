part of 'auto_login_cubit.dart';

abstract class AutoLoginState extends Equatable {
  const AutoLoginState();

  @override
  List<Object> get props => [];
}

class AutoLoginInitial extends AutoLoginState {}

class AutoLoginError extends AutoLoginState {
  final String message;
  const AutoLoginError({required this.message});
}

class AutoLoginHasUser extends AutoLoginState {
  final UserResponse user;

  const AutoLoginHasUser({required this.user});
}

class AutoLoginNoUser extends AutoLoginState {}

class AutoLoginLoading extends AutoLoginState {}

class AutoLoginSeenIntro extends AutoLoginState {
  final UserType type;
  const AutoLoginSeenIntro({
    required this.type,
  });
}
