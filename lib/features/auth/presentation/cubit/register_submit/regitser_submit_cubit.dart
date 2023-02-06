import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/util/navigator.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/register_response.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/submit_register.dart';

part 'regitser_submit_state.dart';

class RegisterSubmitCubit extends Cubit<RegisterSubmitState> {
  RegisterSubmitCubit({
    required this.submitRegister,
  }) : super(RegitserSubmitInitial());
  final SubmitRegister submitRegister;
  Future<void> fSubmitRegister(
      {required RegisterResponse registerResponse,
      required String code}) async {
    emit(RegisterSubmitLoading());
    registerResponse.code = code;
    final response = await submitRegister(registerResponse);
    response.fold((fail) async {
      String? message = fail is ServerFailure ? fail.message : "Try again";
      if (fail is ServerFailure) {
        message = fail.message;
      }

      showToast(message);
      emit(RegisterSubmitError(message: message));
    }, (info) async {
      log(info.toString());
      showToast(info.message, bG: Colors.green);
      sl<AppNavigator>().popToFrist();
      emit(RegisterSubmitSuccess(user: info));
    });
  }
}
