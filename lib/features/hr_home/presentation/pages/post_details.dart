import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../chat/domain/entities/chat_user.dart';
import '../../../cv/presentation/cubit/cv_cubit.dart';
import '../../domain/entities/jobs_repsonse.dart';
import '../../domain/usecases/accept_reject_apllicant.dart';
import '../cubit/accept_applicents/accept_applicents_cubit.dart';
import '../cubit/get_post/get_post_by_id_cubit.dart';
import 'hr_home_screen.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({
    Key? key,
    required this.job,
  }) : super(key: key);
  final Job job;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            JobItem(job: job, isSummary: true),
            BlocProvider<GetPostByIdCubit>(
              create: (context) =>
                  sl<GetPostByIdCubit>()..fGetJobPostById(jobId: job.id),
              child: BlocBuilder<AcceptApplicentsCubit, AcceptApplicentsState>(
                builder: (context, acceptApplicentsCubit) {
                  return BlocBuilder<GetPostByIdCubit, GetPostByIdState>(
                    builder: (context, state) {
                      if (state is GetPostByIdLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: indicator,
                          ),
                        );
                      } else if (state is GetPostByIdSuccess) {
                        final fillterJobs = state.response.body.jobApplicants;
                        if (fillterJobs.isEmpty) {
                          return Center(
                            child: Text(
                              "There's no applicants yet",
                              style: TextStyles.bodyText16,
                            ),
                          );
                        }
                        return Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          padding: const EdgeInsets.all(8.0),
                          // color: white,
                          child: Center(
                            child: Stack(
                              children: [
                                ...List.generate(
                                  fillterJobs.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    child: SwipeTo(
                                      offsetDx: .4,
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                      rightSwipeWidget: Row(
                                        children: [
                                          const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red),
                                          const SpaceHBE(),
                                          Text(
                                            "reject",
                                            style: TextStyles.bodyText16,
                                          ),
                                        ],
                                      ),
                                      leftSwipeWidget: Row(
                                        children: [
                                          Text(
                                            "accept",
                                            style: TextStyles.bodyText16,
                                          ),
                                          const SpaceHBE(),
                                          const Icon(Icons.done,
                                              color: Colors.green),
                                        ],
                                      ),
                                      onRightSwipe: () {
                                        if (fillterJobs[index].status ==
                                            "refused") {
                                          showToast(
                                              "This Jobseeker had been Rejected before");
                                          return;
                                        }

                                        context
                                            .read<AcceptApplicentsCubit>()
                                            .facceptRejectApplicants(
                                                user1: ChatUser.fromAppUser(
                                                    sl<LoginCubit>()
                                                        .user
                                                        .body
                                                        .user),
                                                user2: ChatUser.fromJS(
                                                    fillterJobs[index]
                                                        .jobSeeker),
                                                afterSuccess: () => context
                                                    .read<GetPostByIdCubit>()
                                                    .changeJobSeekerStatus(
                                                        r: state.response,
                                                        jobApplicant:
                                                            fillterJobs[index],
                                                        isAceepted: false),
                                                status: ApplicantStatus.refused,
                                                seekrId: fillterJobs[index]
                                                    .jobSeeker
                                                    .id,
                                                postId: job.id);
                                      },
                                      onLeftSwipe: () {
                                        if (fillterJobs[index].isAccepted) {
                                          showToast(
                                              "This Jobseeker had been acceped before");
                                          return;
                                        }

                                        context
                                            .read<AcceptApplicentsCubit>()
                                            .facceptRejectApplicants(
                                                user1: ChatUser.fromAppUser(
                                                    sl<LoginCubit>()
                                                        .user
                                                        .body
                                                        .user),
                                                user2: ChatUser.fromJS(
                                                    fillterJobs[index]
                                                        .jobSeeker),
                                                afterSuccess: () => context
                                                    .read<GetPostByIdCubit>()
                                                    .changeJobSeekerStatus(
                                                        r: state.response,
                                                        jobApplicant:
                                                            fillterJobs[index],
                                                        isAceepted: true),
                                                status:
                                                    ApplicantStatus.accepted,
                                                seekrId: fillterJobs[index]
                                                    .jobSeeker
                                                    .id,
                                                postId: job.id);
                                      },
                                      child: Opacity(
                                        opacity:
                                            index == 0 ? 1 : 1 / (index + .5),
                                        child: Transform.translate(
                                          offset: index == 0
                                              ? const Offset(0.0, 0.0)
                                              : Offset(
                                                  -40 - (index == 1 ? 20 : 10),
                                                  (index == 1 ? 10 : 20),
                                                ),
                                          child: Transform.rotate(
                                            angle: index > 1
                                                ? -pi / 6
                                                : index == 0
                                                    ? 0
                                                    : -pi / 9,
                                            child: Material(
                                              elevation: index > 3 ? 0 : 2,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                              child: Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22),
                                                    color: index == 0
                                                        ? white
                                                        : index > 3
                                                            ? white
                                                            : accentColor
                                                                .withOpacity(
                                                                    .2)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 22,
                                                      vertical: 16),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: fillterJobs[index]
                                                                              .status ==
                                                                          "pending"
                                                                      ? Colors
                                                                          .yellow
                                                                      : fillterJobs[index]
                                                                              .isAccepted
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                          child: Text(
                                                              fillterJobs[index]
                                                                  .status,
                                                              style: TextStyles
                                                                  .bodyText14
                                                                  .copyWith(
                                                                      color:
                                                                          white)),
                                                        ),
                                                      ),
                                                      const SpaceV20BE(),
                                                      Center(
                                                        child: Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    fillterJobs[
                                                                            index]
                                                                        .jobSeeker
                                                                        .avatar,
                                                                  ),
                                                                  fit: BoxFit.fill)),
                                                        ),
                                                      ),
                                                      const SpaceV10BE(),
                                                      Center(
                                                        child: Text(
                                                          "${fillterJobs[index].jobSeeker.firstname} ${fillterJobs[index].jobSeeker.lastname}",
                                                          style: TextStyles
                                                              .bodyText16
                                                              .copyWith(
                                                                  color:
                                                                      accentColor),
                                                        ),
                                                      ),
                                                      const SpaceV10BE(),
                                                      Center(
                                                        child: Text(
                                                          fillterJobs[index]
                                                              .cvData[
                                                                  jobTitleIndex]
                                                              .value,
                                                          style: TextStyles
                                                              .bodyText14
                                                              .copyWith(
                                                                  color:
                                                                      darkTextColor),
                                                        ),
                                                      ),
                                                      const SpaceV10BE(),
                                                      Center(
                                                        child: Text(
                                                          fillterJobs[index]
                                                              .cvData[
                                                                  jobPositionIndex]
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyles
                                                              .bodyText12
                                                              .copyWith(
                                                                  color:
                                                                      darkTextColor),
                                                        ),
                                                      ),
                                                      const SpaceV10BE(),
                                                      Text(
                                                        "${tr("years_of_experience")} : ${fillterJobs[index].cvData[yearsOfExperienceIndex].value}",
                                                        style: TextStyles
                                                            .bodyText12
                                                            .copyWith(
                                                                color:
                                                                    darkTextColor),
                                                      ),
                                                      const SpaceV10BE(),
                                                      Text(
                                                        fillterJobs[index]
                                                                .cvData[
                                                                    fieldEducationIndex]
                                                                .value +
                                                            fillterJobs[index]
                                                                .cvData[
                                                                    deptFieldIndex]
                                                                .value,
                                                        style: TextStyles
                                                            .bodyText12
                                                            .copyWith(
                                                                color:
                                                                    darkTextColor),
                                                      ),
                                                      const SpaceV10BE(),
                                                      Text(
                                                          fillterJobs[index]
                                                                  .cvData[
                                                                      previousWorkIndex]
                                                                  .value +
                                                              fillterJobs[index]
                                                                  .cvData[
                                                                      deptFieldIndex]
                                                                  .value,
                                                          style: TextStyles
                                                              .bodyText10
                                                              .copyWith(
                                                                  color:
                                                                      hintTextColor)),
                                                      const SpaceV20BE(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Matched with required',
                                                              style: TextStyles
                                                                  .bodyText10
                                                                  .copyWith(
                                                                      color:
                                                                          darkTextColor)),
                                                          CircularPercentIndicator(
                                                              reverse: true,
                                                              radius: 25,
                                                              percent: state
                                                                          .response
                                                                          .body
                                                                          .cvMatchesPercentage[
                                                                      index] /
                                                                  100,
                                                              lineWidth: 8,
                                                              progressColor:
                                                                  accentColor,
                                                              center: Text(
                                                                  "${state.response.body.cvMatchesPercentage[index].toStringAsFixed(1)} %",
                                                                  style: TextStyles
                                                                      .bodyText8))
                                                        ],
                                                      ),
                                                      Center(
                                                        child: TextButton(
                                                            onPressed: () {
                                                              context.read<GetPostByIdCubit>().moveBack(
                                                                  r: state
                                                                      .response,
                                                                  jobApplicant:
                                                                      fillterJobs[
                                                                          index]);
                                                            },
                                                            child: Text(
                                                              "Skip",
                                                              style: TextStyles
                                                                  .bodyText14
                                                                  .copyWith(
                                                                      color:
                                                                          blackColor),
                                                            )),
                                                      )
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
                                ).toList().reversed,
                                if (acceptApplicentsCubit
                                    is AcceptApplicentsLoading)
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color:
                                            Colors.grey[300]!.withOpacity(.5),
                                      ),
                                      child: indicator,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/**
 *  
 */
