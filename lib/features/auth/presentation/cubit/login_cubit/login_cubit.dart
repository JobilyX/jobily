import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/colors/colors.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../domain/usecases/login.dart';
import '../auto_login/auto_login_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Login login;
  LoginCubit({
    required this.login,
  }) : super(LoginInitial());
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);
  UserResponse? _user;
  UserResponse get user => _user!;

  set updateUser(UserResponse newUser) {
    _user = newUser;
    emit(LoginInitial());
    emit(LoginSuccess(user: user));
  }

  set updateUserFromEdit(User newUser) {
    _user!.body.user = newUser;
    emit(LoginInitial());
    emit(LoginSuccess(user: user));
  }

  Future<void> fLogin({required String email, required String password}) async {
    emit(LoginLoading());
    final failOrUser =
        await login(LoginParams(password: password, email: email));
    failOrUser.fold((fail) {
      String message = "Try again";
      if (fail is ServerFailure) message = fail.message;
      showToast(message, bG: errorColor);
      emit(LoginInitial());
    }, (newUser) {
      _user = newUser;
      log(_user.toString());
      sl<AutoLoginCubit>().emitHasUser(user: user);
      emit(LoginInitial());
    });
  }
}
