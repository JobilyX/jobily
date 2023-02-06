import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../hr_home/domain/entities/jobs_repsonse.dart';
import '../../../hr_home/presentation/cubit/add_post/add_post_cubit.dart';
import '../cubit/get_jobs/get_jobs_cubit.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myJobs = context.watch<GetMyJobsCubit>().myJobs;
    return Padding(
      padding: sidePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceV20BE(),
          Text(
            tr("Your recent applies"),
            style: TextStyles.bodyText18,
          ),
          // const SearchWidget(),
          const SpaceV20BE(),
          if (myJobs.isEmpty)
            const Expanded(
                child: Center(
              child: Text("You have not applied for jobs yet"),
            )).animate().shake(),
          if (myJobs.isNotEmpty)
            Expanded(
                child: ListView.builder(
              itemCount: myJobs.length,
              itemBuilder: (context, index) {
                return JobItem(
                  job: myJobs[index],
                ).animate().slideX();
              },
            ))
        ],
      ),
    );
  }
}

class JobItem extends StatelessWidget {
  const JobItem({
    Key? key,
    required this.job,
  }) : super(key: key);

  final Job job;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: mainColor.withOpacity(.5),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style:
                    TextStyles.bodyText18.copyWith(fontWeight: FontWeight.bold),
              ),
              const SpaceV10BE(),
              Text(
                job.listOfComp[jobLocatonIndex].sectionvalues.first,
                style: TextStyles.bodyText10.copyWith(color: darkTextColor),
              ),
              const SpaceV10BE(),
              Text(
                job.listOfComp[jobPositionIndex].sectionvalues.first,
                style: TextStyles.bodyText10.copyWith(color: darkTextColor),
              ),
              const SpaceV10BE(),
              Row(
                children: [
                  Text(
                    "${job.salaryFrom} USD - ${job.salaryTo} USD",
                    style: TextStyles.bodyText14.copyWith(
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
