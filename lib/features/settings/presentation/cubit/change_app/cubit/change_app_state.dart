part of 'change_app_cubit.dart';

abstract class ChangeAppState extends Equatable {
  const ChangeAppState();

  @override
  List<Object> get props => [];
}

class ChangeAppInitial extends ChangeAppState {}

class ChangeAppStateError extends ChangeAppState {
  final String message;

  const ChangeAppStateError({required this.message});
}

class ChangeAppStateSuccess extends ChangeAppState {}

class ChangeAppStateLoading extends ChangeAppState {}
