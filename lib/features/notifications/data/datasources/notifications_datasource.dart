import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/api_basehelper.dart';
import '../../domain/entities/notifications_entity.dart';
import '../../domain/entities/read_all_notification_entity.dart';
import '../../domain/usecases/notfifcation_usecase.dart';
import '../../domain/usecases/reed_all_notifications_usecase.dart';

const notificationsApi = "/user/my-account/user-notifications";

const readAllotificationsApi =
    "/user/my-account/user-notifications?type=read-all";

///NotificationsRemoteDataSource
abstract class NotificationsRemoteDataSource {
  Future<AppNotificationResponse> getNotifications(
      {required NotificationsParams params, required String token});
  Future<ReadAllNotificationsResponse> readAllNotifications(
      {required ReadAllNotificationsParams params});
}

///NotificationsRemoteDataSourceImpl
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final ApiBaseHelper helper;
  NotificationsRemoteDataSourceImpl({required this.helper});

  @override
  Future<AppNotificationResponse> getNotifications(
      {required NotificationsParams params, required String token}) async {
    try {
      final response = await helper.get(url: notificationsApi, token: token)
          as Map<String, dynamic>;
      if (response['status']) {
        final notificationsResponse = AppNotificationResponse.fromMap(response);
        return notificationsResponse;
        //بعد ما اتاكد انه بيجي عادي اجرب دي
        /// return AppNotificationResponse(data: [], paginate: paginate)
      } else {
        throw ServerException(message: response['message']);
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
  Future<ReadAllNotificationsResponse> readAllNotifications(
      {required ReadAllNotificationsParams params}) async {
    try {
      final response = await helper.post(
        url: readAllotificationsApi,

        ///READ ALL
        body: {},
      ) as Map<String, dynamic>;

      if (response['status']) {
        final readAllnotificationsResponse = ReadAllNotificationsResponse();
        // AppNotificationResponse.fromJson(response["body"]["notifications"]);
        return readAllnotificationsResponse;
        //بعد ما اتاكد انه بيجي عادي اجرب دي
        /// return AppNotificationResponse(data: [], paginate: paginate)
      } else {
        throw ServerException(message: response['message']);
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
}
