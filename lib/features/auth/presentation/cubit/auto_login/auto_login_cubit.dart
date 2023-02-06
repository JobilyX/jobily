import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:jobily/core/util/navigator.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../../core/usecases/usecases.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auto_login.dart';
import '../login_cubit/login_cubit.dart';

part 'auto_login_state.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  AutoLoginCubit({required this.autoLogin}) : super(AutoLoginInitial());
  final AutoLogin autoLogin;
  UserType? selectedUserType;
  Future<void> fAutoLogin({required BuildContext context}) async {
    emit(AutoLoginLoading());
    final failOrUser = await autoLogin(NoParams());
    failOrUser.fold((fail) {
      emit(AutoLoginNoUser());
    }, (user) {
      selectedUserType = user.body.user.type;
      emit(AutoLoginHasUser(user: user));
      context.read<LoginCubit>().updateUser = user;
    });
  }

  void emitLoading() {
    emit(AutoLoginInitial());
    emit(AutoLoginLoading());
  }

  void emitHasUser({required UserResponse user}) {
    emit(AutoLoginInitial());
    emit(AutoLoginHasUser(user: user));
  }

  void emitSeenIntro({required UserType type}) {
    selectedUserType = type;
    emit(AutoLoginInitial());
    emit(AutoLoginSeenIntro(type: type));
  }

  void emitNoUser() {
    emit(AutoLoginInitial());
    emit(AutoLoginNoUser());
  }
}

// ignore: constant_identifier_names
enum UserType { job_seeker, hr }
