import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../core/util/navigator.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecases/check_code_reset_pass.dart';
import '../../pages/set_new_password.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({required this.otpCheckCode}) : super(OtpInitial());
  final OtpCheckCode otpCheckCode;
  // TextEditingController codeController = TextEditingController();
  String resetToken = '';
  static OtpCubit get(BuildContext context) => BlocProvider.of(context);
  bool timerVisibility = true;
  var oneSec = const Duration(seconds: 1);
  int start = 0;
  String twoDigits(int number) => number.toString().padLeft(2, '0');
  var counter = 3;

  void startTimer() {
    start = 59;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      counter--;
      if (counter == 0) {
        timer.cancel();
      }
    });
  }

  fcheckForgetPasswordCode(
      {required String email,
      required String code,
      required TextEditingController codeController}) async {
    emit(OtpLoading());
    final OtpCodeParams params = OtpCodeParams(email: email, code: code);
    final response = await otpCheckCode(params);
    response.fold((fail) async {
      if (fail is ServerFailure) {
        String message = fail.message;
        log(fail.message);

        showToast(message);
        emit(OtpError(message: message));
        emit(OtpInitial());
      }
    }, (newToken) {
      log(newToken);
      emit(OtpSuccess(newToken: newToken));
      sl<AppNavigator>().pop();
      sl<AppNavigator>().push(screen: SetNewPasswordScreen(token: newToken));
    });
  }
}
