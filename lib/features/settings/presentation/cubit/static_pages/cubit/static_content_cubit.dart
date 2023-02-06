import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../domain/entities/social_media_links_model.dart';
import '../../../../domain/usecases/get_social_media_links_usecase.dart';
import '../../../../domain/usecases/get_static_pages.dart';

part 'static_content_state.dart';

class StaticContentCubit extends Cubit<StaticContentState> {
  StaticContentCubit(
      {required this.getStaticPages, required this.getSocialMediaLinks})
      : super(StaticContentInitial());
  final GetStaticPages getStaticPages;
  String aboutUs = '';
  String privacyPolicy = '';
  String termConditions = '';
  //////
  final GetSocialMediaLinksUsecase getSocialMediaLinks;
  //SocialMediaLinksData? socialMediaData;

  SocialMediaLinksData? _socialMediaData;
  SocialMediaLinksData? get socialMediaData => _socialMediaData;

  Future<void> fGetStaticPages() async {
    emit(StaticContentLoading());
    final response = await getStaticPages(GetStaticPagesParams());
    response.fold((fail) async {
      String message = 'please try again later';
      if (fail is ServerFailure) {
        message = fail.message;
      }
      emit(StaticContentError(message: message));
    }, (newInfo) {
      aboutUs = newInfo[0];
      privacyPolicy = newInfo[1];
      termConditions = newInfo[2];

      emit(const StaticContentSuccess());
    });
  }

  String infoByFillter(
      {required StaticFilter filter, required String newInfo}) {
    switch (filter) {
      case StaticFilter.ABOUT_US:
        return aboutUs = newInfo;
      case StaticFilter.PRIVACY_AND_POLICIES:
        return privacyPolicy = newInfo;
      case StaticFilter.TERMS_AND_CONDITIONS:
        return termConditions = newInfo;
      default:
        return "";
    }
  }

  String getInfoByFillter({required StaticFilter filter}) {
    switch (filter) {
      case StaticFilter.ABOUT_US:
        return aboutUs;
      case StaticFilter.PRIVACY_AND_POLICIES:
        return privacyPolicy;
      case StaticFilter.TERMS_AND_CONDITIONS:
        return termConditions;
      default:
        return "";
    }
  }

  // Future<void> fGetSocialMediaLinks() async {
  //   emit(GetSocialMediaLinksLoadingState());
  //   final response = await getSocialMediaLinks(NoParams());
  //   response.fold((fail) async {
  //     String message = 'please try again later';
  //     if (fail is ServerFailure) {
  //       message = fail.message;
  //     }
  //     emit(GetSocialMediaLinksErrorState(message: message));
  //   }, (socialInfo) {
  //     socialMediaData = socialInfo.body;
  //     emit(GetSocialMediaLinksSuccessState(socialMediaData: socialMediaData!));
  //   });
  // }
}
