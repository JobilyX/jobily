part of 'read_all_notifications_cubit.dart';

abstract class ReadAllNotificationsState {}

class ReadAllNotificationsInitial extends ReadAllNotificationsState {}

class ReadAllNotificationsLoadingStates extends ReadAllNotificationsState {}

class ReadAllNotificationsSuccessStates extends ReadAllNotificationsState {}

class ReadAllNotificationsErrorStates extends ReadAllNotificationsState {
  final String message;
  ReadAllNotificationsErrorStates({required this.message});
}
