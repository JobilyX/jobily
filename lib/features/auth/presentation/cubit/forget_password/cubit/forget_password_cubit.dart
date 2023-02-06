import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/util/navigator.dart';
import '../../../../../../core/widgets/toast.dart';
import '../../../../../../injection_container.dart';
import '../../../../domain/usecases/reset_password.dart';
import '../../../pages/verfiy_forget.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit({required this.resetPassword})
      : super(ForgetPasswordInitial());
  final ResetPassword resetPassword;
  ResetPasswordParams forgetPassParams = ResetPasswordParams();
  TextEditingController codeController = TextEditingController();
  int _code = 0;
  int get code => _code;

  Future<void> fGetForgetPassCode(
      {required String email, required bool resend}) async {
    emit(ForgetPasswordLoading());
    final ResetPasswordParams params = ResetPasswordParams(email: email);
    final response = await resetPassword(params);
    response.fold((fail) async {
      if (fail is ServerFailure) {
        String message = fail.message;
        showToast(message);
        emit(ForgetPasswordError(message: message));
      }
    }, (info) {
      _code = info.body.code;
      if (resend) {
        emit(ForgetPasswordResendCode(code: info.body.code.toString()));
      } else {
        emit(ForgetPasswordHasCode(code: info.body.code.toString()));
        sl<AppNavigator>().push(screen: VerfiyCodeScreen(email: email));
      }
    });
  }
}
