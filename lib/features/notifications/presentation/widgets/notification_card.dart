import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/styles/styles.dart';

class NotificationCard extends StatelessWidget {
  final String time;
  final String notification;
  final bool newNotification;
  const NotificationCard(
      {Key? key,
      required this.notification,
      required this.time,
      required this.newNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: white,
      ),
      height: 100.h,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notification,
                  style: TextStyles.bodyText16.copyWith(color: blackColor),
                ),
                newNotification
                    ? Container(
                        decoration: const BoxDecoration(
                            color: accentColor, shape: BoxShape.circle),
                        height: 14.h,
                        width: 14.w,
                      )
                    : const SizedBox()
              ],
            ),
            Text(
              time,
              style: TextStyles.bodyText14.copyWith(color: greyBG),
            )
          ],
        ),
      ),
    );
  }
}
