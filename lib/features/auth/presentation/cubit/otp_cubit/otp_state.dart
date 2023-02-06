part of 'otp_cubit.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final String newToken;

  const OtpSuccess({required this.newToken});
}

class OtpError extends OtpState {
  final String message;

  const OtpError({required this.message});
}
