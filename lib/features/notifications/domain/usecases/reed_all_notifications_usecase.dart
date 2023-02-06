import 'package:dartz/dartz.dart';
import 'package:jobily/core/error/failures.dart';
import 'package:jobily/core/usecases/usecases.dart';
import '../entities/read_all_notification_entity.dart';
import '../repositories/notifications_repository.dart';

class ReadAllNotificationsUsecase
    extends UseCase<ReadAllNotificationsResponse, ReadAllNotificationsParams> {
  final NotificationsRepositories repository;
  ReadAllNotificationsUsecase({required this.repository});
  @override
  Future<Either<Failure, ReadAllNotificationsResponse>> call(
      ReadAllNotificationsParams params) async {
    return await repository.readAllNotifications(params: params);
  }
}

class ReadAllNotificationsParams {
  bool? readAll;

  ReadAllNotificationsParams({this.readAll});
}
