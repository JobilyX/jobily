import 'package:equatable/equatable.dart';

import '../../../domain/entities/notifications_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationLoadingState extends NotificationsState {}

class NotificationSuccessState extends NotificationsState {
  final List<AppNotification> notifications;
  const NotificationSuccessState({required this.notifications});
}

class NotificationErrorState extends NotificationsState {
  final String message;
  const NotificationErrorState({required this.message});
}

class NotificationPaginationLoadingState extends NotificationsState {}
