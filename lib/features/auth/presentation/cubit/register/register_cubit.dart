import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/util/navigator.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/register_response.dart';
import '../../../domain/usecases/register.dart';
import '../../../domain/usecases/submit_register.dart';
import '../../pages/verfiy_register.dart';
import '../auto_login/auto_login_cubit.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(
      {required this.submitRegister,
      // required this.appLocation,
      required this.register})
      : super(RegisterInitial());

  final Register register;
  final SubmitRegister submitRegister;
  String registerBody = "";
  RegisterResponse? registerResponse;
  // final AppLocation appLocation;
  RegisterParams? params;
  String code = "";
  Future<void> fRegister({
    required String first,
    required String last,
    required String email,
    required String phone,
    required String date,
    required int acceptTermsConditions,
    required String gender,
    required String password,
    required String passwordConfirmation,
    bool reSend = false,
  }) async {
    emit(RegisterLoading());
    final RegisterParams params = RegisterParams(
      type: sl<AutoLoginCubit>().selectedUserType!.name,
      first: first,
      last: last,
      email: email,
      phone: phone,
      date: date,
      gender: gender,
      password: password,
      passwordConfirmation: passwordConfirmation,
      acceptTermsConditions: 1,
    );
    final response = await register(params);
    response.fold((fail) async {
      String? message = fail is ServerFailure ? fail.message : "Try again";
      if (fail is ServerFailure) {
        message = fail.message;
      }
      showToast(message);
      emit(RegisterError(message: message));
    }, (info) async {
      registerResponse = info;
      code = info.code.toString();
      log(registerResponse.toString());
      if (reSend) {
        emit(RegisterResendCode());
      } else {
        sl<AppNavigator>()
            .push(screen: RegisterVerfiyCodeScreen(resposne: info));
        emit(RegisterSuccess(data: info));
      }
    });
  }
}
