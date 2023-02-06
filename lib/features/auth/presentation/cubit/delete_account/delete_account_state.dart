part of 'delete_account_cubit.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAcountLoadingState extends DeleteAccountState {}

class DeleteAcountErrorState extends DeleteAccountState {
  final String message;
  const DeleteAcountErrorState({required this.message});
}

class DeleteAcountSuccessState extends DeleteAccountState {
  final String message;
  const DeleteAcountSuccessState({required this.message});
}
