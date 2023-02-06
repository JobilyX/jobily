import 'package:dartz/dartz.dart';
import 'package:jobily/features/notifications/domain/entities/notifications_entity.dart';
import 'package:jobily/features/notifications/domain/usecases/notfifcation_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/read_all_notification_entity.dart';
import '../usecases/reed_all_notifications_usecase.dart';

abstract class NotificationsRepositories {
  Future<Either<Failure, AppNotificationResponse>> getNotifications(
      {required NotificationsParams params});
  Future<Either<Failure, ReadAllNotificationsResponse>> readAllNotifications(
      {required ReadAllNotificationsParams params});
}
