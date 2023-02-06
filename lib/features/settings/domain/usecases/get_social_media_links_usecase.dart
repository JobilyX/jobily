import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/social_media_links_model.dart';
import '../repositories/settings_repository.dart';

class GetSocialMediaLinksUsecase
    extends UseCase<GetSocialMediaLinksResponse, NoParams> {
  final SettingsRepository repository;

  GetSocialMediaLinksUsecase({required this.repository});

  @override
  Future<Either<Failure, GetSocialMediaLinksResponse>> call(
      NoParams params) async {
    return await repository.getSocialMediaLinks(params: params);
  }
}
