import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constant/colors/colors.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/util/navigator.dart';
import '../../../../../../core/widgets/toast.dart';
import '../../../../../../injection_container.dart';
import '../../../../domain/usecases/set_new_password.dart';

part 'set_new_password_state.dart';

class SetNewPasswordCubit extends Cubit<SetNewPasswordState> {
  SetNewPasswordCubit({required this.setNewPassword})
      : super(SetNewPasswordInitial());
  final SetNewPassword setNewPassword;
  SetNewPasswordParams setNewPassParams = SetNewPasswordParams();

  Future<void> fSetNewPassword(
      {required String newPass,
      required String confirmPass,
      required String token}) async {
    emit(SetNewPasswordLoading());
    final SetNewPasswordParams params = SetNewPasswordParams(
        newPassword: newPass, confirmPassword: confirmPass, token: token);
    final response = await setNewPassword(params);
    response.fold((fail) async {
      if (fail is ServerFailure) {
        String message = fail.message;
        showToast(message, bG: errorColor);
        emit(SetNewPasswordError(message: message));
      }
    }, (info) {
      showToast(tr("change_password"), bG: Colors.green);
      sl<AppNavigator>().popToFrist();
      emit(SetNewPasswordSuccess());
    });
  }
}
