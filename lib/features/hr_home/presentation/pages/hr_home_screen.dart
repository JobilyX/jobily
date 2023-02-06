import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../domain/entities/jobs_repsonse.dart';
import '../cubit/add_post/add_post_cubit.dart';
import '../cubit/job_posts/get_posts_cubit.dart';
import 'post_details.dart';

class HrHomeScreen extends StatefulWidget {
  const HrHomeScreen({Key? key}) : super(key: key);

  @override
  State<HrHomeScreen> createState() => _HrHomeScreenState();
}

class _HrHomeScreenState extends State<HrHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginCubit>().user.body.user;
    return Padding(
      padding: sidePadding,
      child: BlocBuilder<GetPostsCubit, GetPostsState>(
        builder: (context, state) {
          if (state is GetPostsLoading) {
            return const Center(child: indicator);
          }
          final jobs = sl<GetPostsCubit>().jobsList;
          final jobsSubList =
              jobs.length <= 1 ? [] : sl<GetPostsCubit>().jobsList.sublist(1);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceV20BE(),
                WelcomeWidget(user: user),
                const SpaceV40BE(),
                if (jobs.isNotEmpty)
                  Text(
                    "Most Recently",
                    style: TextStyles.bodyText18,
                  ),
                if (jobs.isNotEmpty) const SpaceV20BE(),
                if (jobs.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        sl<AppNavigator>().push(
                            screen: PostDetailsScreen(
                          job: jobs.first,
                        ));
                      },
                      child: JobItem(
                        job: jobs.first,
                      )),
                if (jobs.isEmpty)
                  Center(
                      child: Text(
                    "You dont post any job yet, try add some.",
                    style: TextStyles.bodyText16,
                  )),
                const SpaceV20BE(),
                if (jobsSubList.isNotEmpty)
                  Text(
                    "All posts",
                    style: TextStyles.bodyText18,
                  ),
                if (jobsSubList.isNotEmpty) const SpaceV20BE(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobsSubList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        sl<AppNavigator>().push(
                            screen: PostDetailsScreen(
                          job: jobsSubList[index],
                        ));
                      },
                      child: JobItem(
                        job: jobsSubList[index],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class JobItem extends StatelessWidget {
  const JobItem({
    Key? key,
    required this.job,
    this.isSummary = false,
  }) : super(key: key);

  final Job job;
  final bool isSummary;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // height: SizeConfig.blockSizeVertical * 15,s
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 194, 247, 225),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.title,
                  style: TextStyles.bodyText18
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (!isSummary)
                  BlocBuilder<GetPostsCubit, GetPostsState>(
                      builder: (context, state) {
                    return GestureDetector(
                        onTap: () {
                          context
                              .read<GetPostsCubit>()
                              .fDeleteJobPost(jobid: job.id);
                        },
                        child: state is DeleteLoading && (state).id == job.id
                            ? indicator
                            : Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red[300]!,
                              ));
                  })
              ],
            ),
            const SpaceV10BE(),
            Text(
              job.listOfComp[jobPositionIndex].sectionvalues.first,
              style: TextStyles.bodyText10.copyWith(color: darkTextColor),
            ),
            const SpaceV10BE(),
            Text(
              job.listOfComp[jobLocatonIndex].sectionvalues.first,
              style: TextStyles.bodyText10.copyWith(color: darkTextColor),
            ),
            const SpaceV10BE(),
            Row(
              children: [
                Text(
                  "${job.salaryFrom} USD - ${job.salaryTo} USD",
                  style: TextStyles.bodyText14.copyWith(
                      fontWeight: FontWeight.bold, color: darkTextColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
