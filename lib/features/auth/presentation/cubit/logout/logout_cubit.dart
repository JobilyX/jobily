import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecases.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecases/logout.dart';
import '../auto_login/auto_login_cubit.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({required this.logout}) : super(LogoutInitial());
  final Logout logout;

  Future<void> fLogout() async {
    emit(LogoutLoading());
    final failOrUser = await logout(NoParams());
    failOrUser.fold((fail) {
      String message = 'please try again later';
      if (fail is ServerFailure) {
        message = fail.message;
      }
      showToast(message);
      emit(LogoutError(message: message));
    }, (logout) {
      sl<AutoLoginCubit>().emitNoUser();
      emit(LogoutSuccess(message: logout));
    });
  }
}
