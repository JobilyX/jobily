import 'package:dartz/dartz.dart';
import 'package:jobily/features/settings/domain/entities/get_complain_types.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/social_media_links_model.dart';
import '../usecases/change_app_language.dart';
import '../usecases/complaint_and_suggestion.dart';
import '../usecases/connect_us.dart';
import '../usecases/get_app_org_info.dart';
import '../usecases/get_static_pages.dart';
import '../usecases/get_terms.dart';
import '../usecases/rate_app.dart';

abstract class SettingsRepository {
  Future<Either<Failure, String>> changeAppLanguage(
      {required ChangeAppLanguageParams params});

  Future<Either<Failure, List<String>>> getStaticPage(
      {required GetStaticPagesParams params});

  Future<Either<Failure, Unit>> getAppOrgInfo(
      {required GetAppOrgInfoParams params});

  Future<Either<Failure, Unit>> connectUs({required ConnectUsParams params});

  Future<Either<Failure, Unit>> complaintAndSuggestion(
      {required ComplaintAndSuggestionParams params});

  Future<Either<Failure, Unit>> getAppTerms(
      {required GetAppTermsParams params});

  Future<Either<Failure, ComplaintTypes>> getComplaintTypes();

  Future<Either<Failure, Unit>> rateApp({required RateAppParams params});
  Future<Either<Failure, GetSocialMediaLinksResponse>> getSocialMediaLinks(
      {required NoParams params});
}
