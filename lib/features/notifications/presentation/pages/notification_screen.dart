import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/empty_screen.dart';
import '../../../../core/widgets/side_padding.dart';
import '../../../../core/widgets/snackbars_toasst/snack_bar.dart';
import '../cubit/get_notifications_cubit/notifications_cubit.dart';
import '../cubit/get_notifications_cubit/notifications_state.dart';
import '../cubit/read_all_notifications_cubit/read_all_notifications_cubit.dart';
import '../widgets/divider.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final bool noNotifications = false;
  late final ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    // context.read<NotificationsCubit>().fGetNotifications();
    // controller.addListener(() {
    //   if (controller.position.pixels == controller.position.maxScrollExtent) {
    //     context.read<NotificationsCubit>().fGetNotifications();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(),
      body: SidePadding(
        sidePadding: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("notifications"),
              style: TextStyles.bodyText24.copyWith(color: darkTextColor),
            ),
            const SpaceV20BE(),
            BlocConsumer<NotificationsCubit, NotificationsState>(
                listener: (context, state) {
              if (state is NotificationErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    appSnackBar(state.message, color: Colors.red));
              } else if (state is NotificationSuccessState) {
                context
                    .read<ReadAllNotificationsCubit>()
                    .fReadAllNotifications();
              }
            }, builder: (context, state) {
              if (state is NotificationLoadingState) {
                return const Center(
                  child: indicator,
                );
              } else if (state is NotificationSuccessState) {
                return state.notifications.isEmpty
                    ? Center(
                        child: EmptyScreen(
                        title: tr("there_are_no_notifications"),
                        image: noNotificationImage,
                      ))
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          if (state.notifications.length == index) {
                            if (state is NotificationPaginationLoadingState) {
                              return const Center(
                                child: indicator,
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                          return NotificationCard(
                            notification: state.notifications[index].title,
                            time: state.notifications[index].createdAt,
                            newNotification:
                                state.notifications[index].readAt == 0,
                          );
                        },
                        separatorBuilder: (context, index) => const CardDivider(
                          color: mainColor,
                        ),
                        itemCount: state.notifications.length,
                      );
              } else if (state is NotificationErrorState) {
                return Center(
                  child: EmptyScreen(
                    image: noNotificationImage,
                    title: tr("there_are_no_notifications"),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}
