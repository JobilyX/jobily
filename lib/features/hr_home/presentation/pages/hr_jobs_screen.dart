import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';

class HrJobsScreen extends StatefulWidget {
  const HrJobsScreen({Key? key}) : super(key: key);

  @override
  State<HrJobsScreen> createState() => _HrJobsScreenState();
}

class _HrJobsScreenState extends State<HrJobsScreen> {
  List<String> jobs = [
    "Sr. UI/UX designer 1",
    "Sr. UI/UX designer 2",
    "Sr. UI/UX designer 4",
    "Sr. UI/UX designer 5",
    "Sr. UI/UX designer 6"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sidePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceV20BE(),
          Text(
            "Latest Applicants",
            style: TextStyles.bodyText18,
          ),
          const SpaceV80BE(),
          Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: const EdgeInsets.all(8.0),
            color: white,
            child: Center(
              child: Stack(
                children: [
                  if (jobs.isEmpty)
                    IconButton(
                        onPressed: () {
                          jobs = [
                            "Sr. UI/UX designer 1",
                            "Sr. UI/UX designer 2",
                            "Sr. UI/UX designer 4",
                            "Sr. UI/UX designer 5",
                            "Sr. UI/UX designer 6"
                          ];
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh)),
                  ...jobs
                      .map(
                        (e) => AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          child: SwipeTo(
                            offsetDx: .4,
                            animationDuration:
                                const Duration(milliseconds: 200),
                            rightSwipeWidget: Row(
                              children: [
                                const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                const SpaceHBE(),
                                Text(
                                  "Ignore",
                                  style: TextStyles.bodyText16,
                                ),
                              ],
                            ),
                            leftSwipeWidget: Row(
                              children: [
                                Text(
                                  "Apply",
                                  style: TextStyles.bodyText16,
                                ),
                                const SpaceHBE(),
                                const Icon(Icons.done, color: Colors.green),
                              ],
                            ),
                            onRightSwipe: () {
                              jobs.remove(e);
                              dev.log(jobs.toString());
                              setState(() {});
                            },
                            onLeftSwipe: () {
                              dev.log(jobs.toString());
                              setState(() {});
                            },
                            child: Opacity(
                              opacity: jobs.indexOf(e) == 0
                                  ? 1
                                  : 1 / (jobs.indexOf(e) + .5),
                              child: Transform.translate(
                                offset: jobs.indexOf(e) == 0
                                    ? const Offset(0.0, 0.0)
                                    : Offset(
                                        -40 - (jobs.indexOf(e) == 1 ? 20 : 10),
                                        (jobs.indexOf(e) == 1 ? 10 : 20),
                                      ),
                                child: Transform.rotate(
                                  angle: jobs.indexOf(e) > 1
                                      ? -pi / 6
                                      : jobs.indexOf(e) == 0
                                          ? 0
                                          : -pi / 9,
                                  child: Material(
                                    elevation: jobs.indexOf(e) > 3 ? 0 : 2,
                                    borderRadius: BorderRadius.circular(22),
                                    child: Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          color: jobs.indexOf(e) == 0
                                              ? white
                                              : jobs.indexOf(e) > 3
                                                  ? white
                                                  : accentColor
                                                      .withOpacity(.2)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22, vertical: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SpaceV20BE(),
                                            Center(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                          logoImage,
                                                        ),
                                                        fit: BoxFit.fill)),
                                              ),
                                            ),
                                            const SpaceV10BE(),
                                            Center(
                                              child: Text(
                                                e,
                                                style: TextStyles.bodyText16
                                                    .copyWith(
                                                        color: accentColor),
                                              ),
                                            ),
                                            const SpaceV10BE(),
                                            Text(
                                              "Sr.UI/UX designer",
                                              style: TextStyles.bodyText12
                                                  .copyWith(
                                                      color: darkTextColor),
                                            ),
                                            const SpaceV10BE(),
                                            Text(
                                              "Sr.UI/UX designer",
                                              style: TextStyles.bodyText12
                                                  .copyWith(
                                                      color: darkTextColor),
                                            ),
                                            const SpaceV10BE(),
                                            Text(
                                              "CIS graduated or related fields",
                                              style: TextStyles.bodyText12
                                                  .copyWith(
                                                      color: darkTextColor),
                                            ),
                                            const SpaceV10BE(),
                                            Text(
                                                '''Worked as UI/UX designer at VOIS company\nWorked as product designer at CVE company\nWorked as UI designer at UNIFI solutions''',
                                                style: TextStyles.bodyText10
                                                    .copyWith(
                                                        color: hintTextColor)),
                                            const SpaceV20BE(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Matched with required',
                                                    style: TextStyles.bodyText10
                                                        .copyWith(
                                                            color:
                                                                darkTextColor)),
                                                CircularPercentIndicator(
                                                    reverse: true,
                                                    radius: 25,
                                                    percent: .76,
                                                    lineWidth: 8,
                                                    progressColor: accentColor,
                                                    center: Text("76 %",
                                                        style: TextStyles
                                                            .bodyText8))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                      .reversed
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
