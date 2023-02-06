part of 'static_content_cubit.dart';

abstract class StaticContentState extends Equatable {
  const StaticContentState();

  @override
  List<Object> get props => [];
}

class StaticContentInitial extends StaticContentState {}

class StaticContentError extends StaticContentState {
  final String message;

  const StaticContentError({required this.message});
}

class StaticContentLoading extends StaticContentState {}

class StaticContentSuccess extends StaticContentState {
  const StaticContentSuccess();
}

//////
class GetSocialMediaLinksErrorState extends StaticContentState {
  final String message;

  const GetSocialMediaLinksErrorState({required this.message});
}

class GetSocialMediaLinksLoadingState extends StaticContentState {}

class GetSocialMediaLinksSuccessState extends StaticContentState {
  final SocialMediaLinksData socialMediaData;
  const GetSocialMediaLinksSuccessState({required this.socialMediaData});
}
