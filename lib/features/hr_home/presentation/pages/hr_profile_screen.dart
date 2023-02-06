import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/app_widgets/logo_widget.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../auth/presentation/cubit/logout/logout_cubit.dart';
import '../../../cv/presentation/cubit/cv_cubit.dart';

class HrProfileScreen extends StatelessWidget {
  const HrProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginCubit>().user.body.user;
    final cv = context.watch<CvCubit>().listOfComp;
    return Container(
      width: double.infinity,
      padding: sidePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceV20BE(),
          Text(
            tr("Profile"),
            style: TextStyles.bodyText18,
          ),
          Center(
            child: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        onError: (exception, stackTrace) => const LogoWidget(),
                        image: NetworkImage(user.avatar),
                        fit: BoxFit.cover))),
          ),
          const SpaceV10BE(),
          Center(
            child: Text("${user.firstname} ${user.lastname}",
                style: TextStyles.bodyText14.copyWith(color: blackColor)),
          ),
          const SpaceV5BE(),
          Center(
            child: Text("Software house",
                style: TextStyles.bodyText10
                    .copyWith(color: darkTextColor.withOpacity(.5))),
          ),
          const SpaceV40BE(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: TextStyles.bodyText16,
              ),
              const SpaceV5BE(),
              Text(user.email,
                  style: TextStyles.bodyText10.copyWith(color: darkTextColor)),
            ],
          ),
          const SpaceV40BE(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Phone number",
                style: TextStyles.bodyText16,
              ),
              const SpaceV5BE(),
              Text(user.phone,
                  style: TextStyles.bodyText10.copyWith(color: darkTextColor)),
            ],
          ),
          const SpaceV40BE(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Company sector",
                style: TextStyles.bodyText16,
              ),
              const SpaceV5BE(),
              Text("Software house",
                  style: TextStyles.bodyText10.copyWith(color: darkTextColor)),
            ],
          ),
          const SpaceV40BE(),
          BlocBuilder<LogoutCubit, LogoutState>(
            builder: (context, state) {
              if (state is LogoutLoading) {
                return indicator;
              }
              return TextButton.icon(
                onPressed: () {
                  sl<LogoutCubit>().fLogout();
                },
                icon: const Icon(
                  Icons.logout,
                  color: errorColor,
                ),
                label: Text(
                  tr("log_out"),
                  style: TextStyles.bodyText14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
