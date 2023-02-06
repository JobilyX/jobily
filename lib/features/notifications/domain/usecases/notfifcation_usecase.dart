import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/notifications_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUsecase
    extends UseCase<AppNotificationResponse, NotificationsParams> {
  final NotificationsRepositories repository;
  GetNotificationsUsecase({required this.repository});
  @override
  Future<Either<Failure, AppNotificationResponse>> call(
      NotificationsParams params) async {
    return await repository.getNotifications(params: params);
  }
}

class NotificationsParams {
  final int page;

  NotificationsParams({required this.page});
}
