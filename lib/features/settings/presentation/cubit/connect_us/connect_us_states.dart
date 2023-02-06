part of 'connect_us_cubit.dart';

abstract class ConnectUsState extends Equatable {
  const ConnectUsState();

  @override
  List<Object> get props => [];
}

class ConnectUsInitial extends ConnectUsState {}

class ConnectUsError extends ConnectUsState {
  final String message;

  const ConnectUsError({required this.message});
}

class ConnectUsLoading extends ConnectUsState {}

class ConnectUsSuccess extends ConnectUsState {}

class ComplaintTypesInitial extends ConnectUsState {}

class ComplaintTypesError extends ConnectUsState {
  final String message;

  const ComplaintTypesError({required this.message});
}

class ComplaintTypesLoading extends ConnectUsState {}

class ComplaintTypesSuccess extends ConnectUsState {}
