import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/util/navigator.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecases/change_password.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({required this.changePasswordUseCase})
      : super(ChangePasswordInitial());
  final ChangePasswordUseCase changePasswordUseCase;
  static ChangePasswordCubit get(BuildContext context) =>
      BlocProvider.of<ChangePasswordCubit>(context);

  Future<void> fChangePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    emit(ChangePasswordLoading());
    final ChangePasswordParams params = ChangePasswordParams(
        newPassword: newPassword,
        confirmNewPassword: confirmPassword,
        currentPassword: currentPassword);
    final response = await changePasswordUseCase(params);
    response.fold(
      (fail) async {
        if (fail is ServerFailure) {
          String message = fail.message;

          showToast(message);
          emit(ChangePasswordError(message: message));
        }
      },
      (info) {
        emit(ChangePasswordSuccess());
        sl<AppNavigator>().pop();
      },
    );
  }
}
