// ignore_for_file: constant_identifier_names

import 'package:dartz/dartz.dart';
import 'package:jobily/features/settings/domain/repositories/settings_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';

enum StaticFilter { ABOUT_US, PRIVACY_AND_POLICIES, TERMS_AND_CONDITIONS }

class GetStaticPages extends UseCase<List<String>, GetStaticPagesParams> {
  final SettingsRepository repository;

  GetStaticPages({required this.repository});

  @override
  Future<Either<Failure, List<String>>> call(
      GetStaticPagesParams params) async {
    return await repository.getStaticPage(params: params);
  }
}

class GetStaticPagesParams {
  final StaticFilter? filter;
  GetStaticPagesParams({this.filter});
}
