import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../domain/entities/get_complain_types.dart';
import '../../domain/entities/social_media_links_model.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/change_app_language.dart';
import '../../domain/usecases/complaint_and_suggestion.dart';
import '../../domain/usecases/connect_us.dart';
import '../../domain/usecases/get_app_org_info.dart';
import '../../domain/usecases/get_static_pages.dart';
import '../../domain/usecases/get_terms.dart';
import '../../domain/usecases/rate_app.dart';
import '../datasources/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remote;

  SettingsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, Unit>> connectUs(
      {required ConnectUsParams params}) async {
    try {
      await remote.connectUs(params: params);
      return const Right(unit);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> changeAppLanguage(
      {required ChangeAppLanguageParams params}) async {
    try {
      final response = await remote.changeAppLanguage(params: params);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> complaintAndSuggestion(
      {required ComplaintAndSuggestionParams params}) async {
    try {
      await remote.sendComplaint(params: params);
      return const Right(unit);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  // @override
  // Future<Either<Failure, Unit>> (
  //     {required ComplaintAndSuggestionParams params}) {
  //   throw UnimplementedError();
  // }

  @override
  Future<Either<Failure, Unit>> getAppOrgInfo(
      {required GetAppOrgInfoParams params}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> getAppTerms(
      {required GetAppTermsParams params}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> rateApp({required RateAppParams params}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<String>>> getStaticPage(
      {required GetStaticPagesParams params}) async {
    try {
      final response = await remote.getStaticPage(params: params);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ComplaintTypes>> getComplaintTypes() async {
    try {
      final response = await remote.complaintTypes();
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, GetSocialMediaLinksResponse>> getSocialMediaLinks(
      {required NoParams params}) async {
    try {
      final response = await remote.getSocialMediaLinks(params: params);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }
}
