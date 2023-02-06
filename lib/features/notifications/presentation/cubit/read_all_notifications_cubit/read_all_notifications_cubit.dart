import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/reed_all_notifications_usecase.dart';

part 'read_all_notifications_state.dart';

class ReadAllNotificationsCubit extends Cubit<ReadAllNotificationsState> {
  ReadAllNotificationsCubit({required this.readAllNotificationUsecase})
      : super(ReadAllNotificationsInitial());

  //usecase
  final ReadAllNotificationsUsecase readAllNotificationUsecase;

  //params
  ReadAllNotificationsParams readAllNotificationsParams =
      ReadAllNotificationsParams();

  Future<void> fReadAllNotifications() async {
    emit(ReadAllNotificationsLoadingStates());
    final failOrString =
        await readAllNotificationUsecase(readAllNotificationsParams);
    failOrString.fold((fail) {
      if (fail is ServerFailure) {
        emit(ReadAllNotificationsErrorStates(message: fail.message));
      }
    }, (successMessage) {
      readAllNotificationsParams = ReadAllNotificationsParams();

      // emit(ReadAllNotificationsSuccessStates(message: successMessage));
      emit(ReadAllNotificationsSuccessStates());
    });
  }
}
