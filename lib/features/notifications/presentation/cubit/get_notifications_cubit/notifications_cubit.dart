import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/notfifcation_usecase.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/notifications_entity.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required this.getNotificationsUsecase})
      : super(NotificationsInitial());

  //usecase
  final GetNotificationsUsecase getNotificationsUsecase;

  List<AppNotification> notifications = [];

  int currentPage = 1;
  bool isMore = true;
  Future<void> fGetNotifications({bool? isFrist}) async {
    isMore = isFrist ?? isMore;
    if (isFrist ?? false) {
      currentPage = 1;
      notifications = [];
    }
    if (isMore) {
      if (currentPage == 1) {
        notifications = [];
        emit(NotificationLoadingState());
      } else {
        emit(NotificationPaginationLoadingState());
      }
      final failOrString =
          await getNotificationsUsecase(NotificationsParams(page: currentPage));
      failOrString.fold((fail) {
        if (fail is ServerFailure) {
          emit(NotificationErrorState(message: fail.message));
        }
      }, (newNotifications) {
        if (currentPage <
            newNotifications.body.userNotifications.paginate.totalPages) {
          currentPage += 1;
        } else {
          isMore = false;
        }
        notifications += newNotifications.body.userNotifications.data
            .where((element) => element.title.isNotEmpty)
            .toList();
        emit(NotificationSuccessState(notifications: notifications));
      });
    }
  }
}
