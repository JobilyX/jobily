import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/util/api_basehelper.dart';
import '../../domain/entities/get_complain_types.dart';
import '../../domain/entities/social_media_links_model.dart';
import '../../domain/usecases/change_app_language.dart';
import '../../domain/usecases/complaint_and_suggestion.dart';
import '../../domain/usecases/connect_us.dart';
import '../../domain/usecases/get_static_pages.dart';

const connectUsAPI = "/general/contact-complaints";
const getPrivacyPolicyAPI = "/general/static-pages";
const changeAppAPI = "/languages/change/";
const getComplaintTypesAPI = "/general/contact-complaints";
const cancelOrderReasonsAPI = "/order/cancel-order-reasons";
const getSocialMediaLinksAPI = "/general/socials";

abstract class SettingsRemoteDataSource {
  Future<void> connectUs({required ConnectUsParams params});
  Future<void> sendComplaint({required ComplaintAndSuggestionParams params});
  Future<ComplaintTypes> complaintTypes();
  Future<String> changeAppLanguage({required ChangeAppLanguageParams params});
  Future<List<String>> getStaticPage({required GetStaticPagesParams params});
  Future<GetSocialMediaLinksResponse> getSocialMediaLinks(
      {required NoParams params});
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiBaseHelper helper;

  SettingsRemoteDataSourceImpl({required this.helper});

  @override
  Future<void> connectUs({required ConnectUsParams params}) async {
    try {
      await helper.post(url: connectUsAPI, body: params.toMap());
    } catch (e) {
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<String>> getStaticPage(
      {required GetStaticPagesParams params}) async {
    try {
      final response = await helper.get(url: getPrivacyPolicyAPI);
      List<String> values = [];
      for (var e in (response["body"]["pages"] as List)) {
        log(e["body"].toString());
        values.add(e["body"]);
      }
      return values;
    } catch (e) {
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> changeAppLanguage(
      {required ChangeAppLanguageParams params}) async {
    try {
      final response =
          await helper.get(url: "$changeAppAPI/${params.locale.languageCode}");
      if (response["status"]) {
        return response["body"]["language"]["code"];
      } else {
        throw throw ServerException(message: response["message"]);
      }
    } catch (e) {
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<ComplaintTypes> complaintTypes() async {
    try {
      final response = await helper.get(url: getComplaintTypesAPI);
      if (response["status"]) {
        return ComplaintTypes.fromMap(response["body"]);
      } else {
        throw throw ServerException(message: response["message"]);
      }
    } catch (e) {
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> sendComplaint(
      {required ComplaintAndSuggestionParams params}) async {
    try {
      await helper.post(url: connectUsAPI, body: params.toMap());
    } catch (e) {
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<GetSocialMediaLinksResponse> getSocialMediaLinks(
      {required NoParams params}) async {
    try {
      final response = await helper.get(url: getSocialMediaLinksAPI);
      if (response['status'] == true) {
        final getSocialLinks = GetSocialMediaLinksResponse.fromJson(response);
        return getSocialLinks;
      } else {
        throw ServerException(message: response['message']);
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
