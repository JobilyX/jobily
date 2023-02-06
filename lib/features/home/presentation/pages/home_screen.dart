import 'dart:developer' as dev;
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/toast.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../cv/presentation/cubit/cv_cubit.dart' as cv;
import '../../../hr_home/presentation/cubit/add_post/add_post_cubit.dart';
import '../../../hr_home/presentation/pages/add_post_screen.dart';
import '../cubit/get_jobs_fillter/get_jobs_fillter_cubit.dart';
import '../cubit/job_apply/job_apply_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<GetJobsFillterCubit>().fGetJobsFillter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginCubit>().user.body.user;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: sidePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeWidget(user: user),
                const SpaceV20BE(),
                const SelectedChips(),
                const SpaceV20BE(),
              ],
            ),
          ),
          const SpaceV20BE(),
          BlocBuilder<GetJobsFillterCubit, GetJobsFillterState>(
              builder: (context, state) {
            if (context.read<GetJobsFillterCubit>().selctedTap.isEven) {
              return const LatestJobsWidget(withMatch: true);
            } else {
              return const SearchWidget();
            }
          })
        ],
      ),
    );
  }
}

class LatestJobsWidget extends StatelessWidget {
  const LatestJobsWidget({
    Key? key,
    this.withMatch = false,
  }) : super(key: key);
  final bool withMatch;
  @override
  Widget build(BuildContext context) {
    final cvCubit = context.watch<cv.CvCubit>();

    return BlocBuilder<GetJobsFillterCubit, GetJobsFillterState>(
      builder: (context, state) {
        if (state is GetJobsFillterLoading) {
          return const Center(child: indicator);
        }
        return BlocBuilder<JobApplyCubit, JobApplyState>(
          builder: (context, jobApplyState) {
            final fillterJobs = withMatch
                ? context.watch<GetJobsFillterCubit>().listaAfterMatch
                : context.watch<GetJobsFillterCubit>().fillterJobs;
            if (fillterJobs.isEmpty) {
              return Center(
                child:
                    Text("There are no jobs yet", style: TextStyles.bodyText16)
                        .animate()
                        .shake(),
              );
            }
            return Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              padding: const EdgeInsets.all(8.0),
              color: white,
              child: Center(
                child: Stack(
                  children: [
                    ...List.generate(
                      fillterJobs.length,
                      (index) => SwipeTo(
                        offsetDx: .4,
                        animationDuration: const Duration(milliseconds: 200),
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
                        onRightSwipe: jobApplyState is JobApplyLoading
                            ? null
                            : () {
                                if (cvCubit.checkUserCompleateCv()) {
                                  showToast("please compleate your cv first");
                                  return;
                                }
                                context
                                    .read<GetJobsFillterCubit>()
                                    .moveBack(fillterJobs[index], withMatch);
                                dev.log("jobs =>>>>> $fillterJobs");
                                dev.log("jobsReserved=>>>> ");
                              },
                        onLeftSwipe: jobApplyState is JobApplyLoading
                            ? null
                            : () {
                                if (cvCubit.checkUserCompleateCv()) {
                                  showToast("please compleate your cv first");
                                  return;
                                }
                                context.read<JobApplyCubit>().fJobApply(
                                    jobId: fillterJobs[index].id,
                                    status: JobStatus.join);
                                context
                                    .read<GetJobsFillterCubit>()
                                    .moveBack(fillterJobs[index], withMatch);
                              },
                        child: Opacity(
                          opacity: fillterJobs.indexOf(fillterJobs[index]) == 0
                              ? 1
                              : 1 /
                                  (fillterJobs.indexOf(fillterJobs[index]) +
                                      .5),
                          child: Transform.translate(
                            offset: fillterJobs.indexOf(fillterJobs[index]) == 0
                                ? const Offset(0.0, 0.0)
                                : Offset(
                                    -40 -
                                        (fillterJobs.indexOf(
                                                    fillterJobs[index]) ==
                                                1
                                            ? 20
                                            : 10),
                                    (fillterJobs.indexOf(fillterJobs[index]) ==
                                            1
                                        ? 10
                                        : 20),
                                  ),
                            child: Transform.rotate(
                              angle: fillterJobs.indexOf(fillterJobs[index]) > 1
                                  ? -pi / 6
                                  : fillterJobs.indexOf(fillterJobs[index]) == 0
                                      ? 0
                                      : -pi / 9,
                              child: Material(
                                elevation:
                                    fillterJobs.indexOf(fillterJobs[index]) > 3
                                        ? 0
                                        : 2,
                                borderRadius: BorderRadius.circular(22),
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal * 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: fillterJobs.indexOf(
                                                  fillterJobs[index]) ==
                                              0
                                          ? white
                                          : fillterJobs.indexOf(
                                                      fillterJobs[index]) >
                                                  3
                                              ? white
                                              : Colors.grey[100 *
                                                  fillterJobs.indexOf(
                                                      fillterJobs[index])]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 16),
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType
                                                          .confirm,
                                                      title: "Reporting",
                                                      text:
                                                          'you want to report ${fillterJobs[index].hr.firstname} ${fillterJobs[index].hr.lastname}',
                                                      onConfirmBtnTap: () {
                                                        context
                                                            .read<
                                                                JobApplyCubit>()
                                                            .fJobApply(
                                                                jobId:
                                                                    fillterJobs[
                                                                            index]
                                                                        .id,
                                                                status: JobStatus
                                                                    .report);
                                                        Navigator.pop(context);
                                                      },
                                                      confirmBtnText: "Report");
                                                },
                                                child: Icon(
                                                  Icons.report,
                                                  color: Colors.yellow[700],
                                                )),
                                            Center(
                                                child: Image.asset(logoImage)),
                                            const SpaceV20BE(),
                                            Center(
                                              child: Text(
                                                fillterJobs[index].title,
                                                style: TextStyles.bodyText16
                                                    .copyWith(color: mainColor),
                                              ),
                                            ),
                                            const SpaceV20BE(),
                                            Text(
                                              fillterJobs[index]
                                                  .jobSections[jobLocatonIndex]
                                                  .value,
                                              style: TextStyles.bodyText12
                                                  .copyWith(
                                                      color: darkTextColor),
                                            ),
                                            const SpaceV20BE(),
                                            Text(
                                              "${fillterJobs[index].jobSections[yearsOfExperienceIndex].value} Years of experience",
                                              style: TextStyles.bodyText12
                                                  .copyWith(
                                                      color: darkTextColor),
                                            ),
                                            const SpaceV20BE(),
                                            Text(
                                              fillterJobs[index]
                                                  .jobSections[
                                                      fieldEducationIndex]
                                                  .value,
                                              style: TextStyles.bodyText12
                                                  .copyWith(
                                                      color: darkTextColor),
                                            ),
                                            const SpaceV20BE(),
                                            Text(fillterJobs[index].description,
                                                style: TextStyles.bodyText10
                                                    .copyWith(
                                                        color: hintTextColor)),
                                            const SpaceV20BE(),
                                            Center(
                                              child: Text(
                                                  "${fillterJobs[index].salaryFrom} USD - ${fillterJobs[index].salaryTo} USD",
                                                  style: TextStyles.bodyText14
                                                      .copyWith(
                                                          color: blackColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                            const SpaceV20BE(),
                                          ],
                                        ),
                                        if (jobApplyState is JobApplyLoading)
                                          Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                color: Colors.grey[300]!
                                                    .withOpacity(.5)),
                                            child:
                                                const Center(child: indicator),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).animate().fade().scale(),
                    ).toList().reversed,
                    // if (jobApplyState is JobApplyLoading)
                    //   Positioned.fill(
                    //       child: Container(
                    //     color: mainColor.withOpacity(.2),
                    //     child: indicator,
                    //   )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          tr("welcome"),
          style: TextStyles.bodyText24.copyWith(color: darkTextColor),
        ).animate().shake(delay: 50.ms, duration: 200.ms),
        Text(
          user.firstname,
          style: TextStyles.bodyText24.copyWith(
              color: user.type == UserType.hr ? accentColor : mainColor),
        ).animate().shimmer(delay: 50.ms, duration: 600.ms),
        const SpaceHBE(),
        Image.asset(welcomeIcon)
            .animate(
              onPlay: (controller) => controller.loop(count: 2, reverse: true),
            )
            .shake(delay: 50.ms, duration: 600.ms)
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool isShowFillter = false;
  @override
  Widget build(BuildContext context) {
    final ifThereFillters =
        context.watch<GetJobsFillterCubit>().ifThereFillters();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    onChanged: (value) {
                      if (isShowFillter) {
                        setState(() {
                          isShowFillter = !isShowFillter;
                        });
                      }
                      context.read<GetJobsFillterCubit>().jobTitle = value;
                      if (value.length > 3) {
                        context
                            .read<GetJobsFillterCubit>()
                            .fGetJobsFillterByTitle();
                      }
                      if (value.isEmpty) {
                        context.read<GetJobsFillterCubit>().reset();
                        context.read<GetJobsFillterCubit>().fGetJobsFillter();
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: tr("search_job"),
                        prefixIcon: SvgPicture.asset(
                          searchIcon,
                          fit: BoxFit.scaleDown,
                        )),
                  ),
                ),
              ),
              const SpaceHBE(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isShowFillter = !isShowFillter;
                  });
                },
                child: Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(10)),
                  child: Badge(
                    badgeStyle: const BadgeStyle(badgeColor: accentColor),
                    showBadge: ifThereFillters,
                    position: BadgePosition.topEnd(top: 6, end: 10),
                    child: Transform.rotate(
                      angle: isShowFillter ? pi / 2 : 0,
                      child: Image.asset(
                        filterIcon,
                        width: 60,
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SpaceV20BE(),
          if (isShowFillter)
            FilterWidget(toogleFiltter: () {
              setState(() {
                isShowFillter = !isShowFillter;
              });
            }),
          const SpaceV20BE(),
          const LatestJobsWidget()
        ],
      ),
    );
  }
}

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    Key? key,
    required this.toogleFiltter,
  }) : super(key: key);
  final Function toogleFiltter;
  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  RangeValues salaryRange = const RangeValues(0, 100000);
  RangeLabels salaryRangelabels = const RangeLabels("0", "100000");
  @override
  void initState() {
    super.initState();
    final cubit = context.read<GetJobsFillterCubit>();
    if (cubit.salaryFrom.isNotEmpty && cubit.salaryTo.isNotEmpty) {
      salaryRange = RangeValues(
          double.parse(cubit.salaryFrom), double.parse(cubit.salaryTo));
    }
    salaryRangelabels = RangeLabels(cubit.salaryFrom, cubit.salaryTo);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GetJobsFillterCubit>();
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          MasterDropdown(
            text: "Job Position",
            onPick: (val) {
              if (val != null) {
                cubit.listOfComp[jobPositionIndex].sectionvalues.first = val;
              }
            },
            initValue: cubit.listOfComp[jobPositionIndex].sectionvalues[0],
            items: const [
              "CTO",
              "CIO/Chief Digital Officer/Chief Innovation Officer",
              'VP of Product Management/Head of Product',
              'Product Manager',
              'VP of Marketing',
              'VP of Engineering/Director of Engineering',
              'Chief Architect',
              'Software Architect',
              'Engineering Project Manager/Engineering Manager',
              'Technical Lead/Engineering Lead/Team Lead',
              'Principal Software Engineer',
              'Senior Software Engineer/Senior Software Developer',
              'Software Engineer',
              'Software Developer',
              'Junior Software Developer',
              'Intern Software Developer'
            ].reversed.toList(),
          ),
          const SpaceV20BE(),
          MasterDropdown(
            text: "Job Location",
            onPick: (val) {
              if (val != null) {
                cubit.listOfComp[jobLocatonIndex].sectionvalues.first = val;
              }
            },
            initValue: cubit.listOfComp[jobLocatonIndex].sectionvalues.first,
            items: const [
              "Full time remote",
              "Full time on-site",
              "Part time remote",
              "Part time on-site"
            ],
          ),
          const SpaceV20BE(),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text("Salary Range",
                style: TextStyles.bodyText14.copyWith(color: darkTextColor)),
          ),
          const SpaceV5BE(),
          RangeSlider(
            min: 0.0,
            max: 100000,
            values: salaryRange,
            divisions: 100,
            activeColor: accentColor,
            labels: RangeLabels(
              salaryRange.start.round().toString(),
              salaryRange.end.round().toString(),
            ),
            onChangeEnd: (value) {
              context.read<GetJobsFillterCubit>().salaryFrom =
                  value.start.toStringAsFixed(1);
              context.read<GetJobsFillterCubit>().salaryTo =
                  value.end.toStringAsFixed(1);
              context.read<GetJobsFillterCubit>().fEmitChangeFillter();
            },
            onChanged: (RangeValues values) {
              setState(() {
                salaryRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JobilyButton(
                width: 150,
                height: 40,
                onPressed: () {
                  widget.toogleFiltter();
                  context.read<GetJobsFillterCubit>().fGetJobsFillter();
                },
                text: "Search",
              ),
              JobilyButton(
                width: 150,
                height: 40,
                onPressed: () {
                  final cubit = context.read<GetJobsFillterCubit>();
                  cubit.salaryTo = "";
                  cubit.salaryFrom = "";
                  cubit.listOfComp[jobLocatonIndex].sectionvalues.first = "";
                  cubit.listOfComp[jobPositionIndex].sectionvalues.first = "";
                  widget.toogleFiltter();
                  cubit.fEmitChangeFillter();
                },
                text: "Reset",
                color: accentColor,
              )
            ],
          )
        ],
      ),
    );
  }
}

class SelectedChips extends StatefulWidget {
  const SelectedChips({Key? key}) : super(key: key);

  @override
  State<SelectedChips> createState() => _SelectedChipsState();
}

class _SelectedChipsState extends State<SelectedChips> {
  int selectedChip = 0;
  @override
  void initState() {
    super.initState();
    selectedChip = 0;
    context.read<GetJobsFillterCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    final cvCubit = context.watch<cv.CvCubit>();
    return Row(
      children: [
        if (!cvCubit.checkUserCompleateCv())
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (selectedChip != 0) {
                  context.read<GetJobsFillterCubit>().toggleSelctedTap(0);
                  context.read<GetJobsFillterCubit>().reset();
                  context.read<GetJobsFillterCubit>().fGetJobsFillter();
                  setState(() => selectedChip = 0);
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: selectedChip == 0
                        ? mainColor
                        : mainColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(22)),
                child: Center(
                  child: Text(
                    "Jobs matches your cv",
                    style: TextStyles.bodyText14.copyWith(
                        color: selectedChip == 0 ? white : blackColor),
                  ),
                ),
              ).animate().slideX(begin: -4),
            ),
          ),
        const SpaceHBE(),
        GestureDetector(
          onTap: () {
            if (selectedChip != 1) {
              context.read<GetJobsFillterCubit>().toggleSelctedTap(1);
              setState(() => selectedChip = 1);
            }
          },
          child: Container(
            width: 50,
            height: 40,
            decoration: BoxDecoration(
                color:
                    selectedChip == 1 ? mainColor : mainColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(22)),
            child: Center(
              child: Text(
                "All",
                style: TextStyles.bodyText14
                    .copyWith(color: selectedChip == 1 ? white : blackColor),
              ),
            ),
          ).animate().slideX(begin: 4),
        ),
      ],
    );
  }
}
