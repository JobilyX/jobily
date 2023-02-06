import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';

import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class ChangeAppLanguage extends UseCase<String, ChangeAppLanguageParams> {
  final SettingsRepository repository;

  ChangeAppLanguage({required this.repository});
  @override
  Future<Either<Failure, String>> call(ChangeAppLanguageParams params) async {
    return await repository.changeAppLanguage(params: params);
  }
}

class ChangeAppLanguageParams {
  final Locale locale;

  ChangeAppLanguageParams({
    required this.locale,
  });
}
