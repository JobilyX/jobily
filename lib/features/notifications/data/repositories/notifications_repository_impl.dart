import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/local/auth_local_datasource.dart';
import '../../domain/entities/notifications_entity.dart';
import '../../domain/entities/read_all_notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/notfifcation_usecase.dart';
import '../../domain/usecases/reed_all_notifications_usecase.dart';
import '../datasources/notifications_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepositories {
  final NotificationsRemoteDataSource remote;
  final AuthLocalDataSource authLocal;
  NotificationsRepositoryImpl({required this.authLocal, required this.remote});

  @override
  Future<Either<Failure, AppNotificationResponse>> getNotifications(
      {required NotificationsParams params}) async {
    try {
      final token = authLocal.getCacheUserAccessToken();
      final notifications =
          await remote.getNotifications(params: params, token: token);
      return Right(notifications);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ReadAllNotificationsResponse>> readAllNotifications(
      {required ReadAllNotificationsParams params}) async {
    try {
      final readAllNotifications =
          await remote.readAllNotifications(params: params);
      return Right(readAllNotifications);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }
}
