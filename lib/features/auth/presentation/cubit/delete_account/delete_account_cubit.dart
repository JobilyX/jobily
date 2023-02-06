import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../domain/usecases/delete_account.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit({
    required this.deleteAccount,
  }) : super(DeleteAccountInitial());

  final DeleteAccount deleteAccount;

  Future<void> fDeleteAccount() async {
    emit(DeleteAcountLoadingState());
    final failOrUser = await deleteAccount(NoParams());
    failOrUser.fold((fail) {
      String message = 'please try again later';
      if (fail is ServerFailure) {
        message = fail.message;
      }

      showToast(message);
      emit(DeleteAcountErrorState(message: message));
    }, (deleteResponse) {
      emit(DeleteAcountSuccessState(message: deleteResponse.message));
    });
  }
}
