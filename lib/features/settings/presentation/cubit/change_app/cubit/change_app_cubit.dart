import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../domain/usecases/change_app_language.dart';

part 'change_app_state.dart';

class ChangeApplanguageCubit extends Cubit<ChangeAppState> {
  ChangeApplanguageCubit({required this.changeAppLanguage})
      : super(ChangeAppInitial());

  final ChangeAppLanguage changeAppLanguage;

  Future<void> fGetChangeAppLanguage({required Locale locale}) async {
    emit(ChangeAppStateLoading());
    final fail =
        await changeAppLanguage(ChangeAppLanguageParams(locale: locale));

    fail.fold((fail) {
      //
      if (fail is ServerFailure) {
        emit(ChangeAppStateError(message: fail.message));
      }
    }, (newStore) {
      //
      emit(ChangeAppStateSuccess());
    });
  }
}
