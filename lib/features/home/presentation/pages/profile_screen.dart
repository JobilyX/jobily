import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/app_widgets/logo_widget.dart';
import '../../../../core/widgets/get_image.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../auth/presentation/cubit/logout/logout_cubit.dart';
import '../../../cv/presentation/cubit/cv_cubit.dart';
import '../../../cv/presentation/pages/cv_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
          const SpaceHBE(),
          Center(
            child: Text("${user.firstname} ${user.lastname}",
                style: TextStyles.bodyText14.copyWith(color: blackColor)),
          ),
          Center(
            child: Text(user.email,
                style: TextStyles.bodyText10.copyWith(color: darkTextColor)),
          ),
          const SpaceV20BE(),
          if (cv[skillsIndex].sectionvalues.length <= 1) const ParseCvButton(),
          if (cv[skillsIndex].sectionvalues.length <= 1)
            TextButton(
              onPressed: () {
                sl<AppNavigator>().push(screen: const CVScreen());
              },
              child: Text(
                tr("create_cv"),
                style: TextStyles.bodyText16.copyWith(color: accentColor),
              ),
            ),
          if (cv[skillsIndex].sectionvalues.length > 1)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobilyButton(
                  height: 50,
                  onPressed: () {
                    sl<AppNavigator>().push(
                        screen: const CVScreen(
                      initStage: 0,
                    ));
                  },
                  text: tr("work_experience"),
                ),
                const SpaceV10BE(),
                JobilyButton(
                  height: 50,
                  color: mainColor.withOpacity(.99),
                  onPressed: () {
                    sl<AppNavigator>().push(
                        screen: const CVScreen(
                      initStage: 1,
                    ));
                  },
                  text: tr("education_language"),
                ),
                const SpaceV10BE(),
                JobilyButton(
                  height: 50,
                  color: mainColor.withOpacity(.8),
                  onPressed: () {
                    sl<AppNavigator>().push(
                        screen: const CVScreen(
                      initStage: 2,
                    ));
                  },
                  text: tr("documents"),
                ),
                const SpaceV10BE(),
                JobilyButton(
                  height: 50,
                  color: mainColor.withOpacity(.7),
                  onPressed: () {
                    sl<AppNavigator>().push(
                        screen: const CVScreen(
                      initStage: 3,
                    ));
                  },
                  text: tr("skills"),
                ),
                const SpaceV10BE(),
                BlocBuilder<CvCubit, CvState>(
                  builder: (context, state) {
                    if (state is CvDeleteLoading) {
                      return indicator;
                    }
                    return JobilyButton(
                      height: 50,
                      color: Colors.grey.withOpacity(.6),
                      onPressed: () {
                        context
                            .read<CvCubit>()
                            .fDeleteCv(userId: user.id.toString());
                      },
                      text: tr("reset_cv"),
                    );
                  },
                ),
              ],
            ),
          const Spacer(),
          if (cv[skillsIndex].sectionvalues.length > 1) const SpaceV20BE(),
          Center(
            child: BlocBuilder<LogoutCubit, LogoutState>(
              builder: (context, state) {
                if (state is LogoutLoading) {
                  return indicator;
                }
                return JobilyButton(
                  height: 40,
                  width: 150,
                  color: errorColor,
                  onPressed: () {
                    sl<LogoutCubit>().fLogout();
                  },
                  text: tr("log_out"),
                );
              },
            ),
          ),
          const SpaceV20BE(),
          /*
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
           */
        ],
      ),
    );
  }
}

class ParseCvButton extends StatefulWidget {
  const ParseCvButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ParseCvButton> createState() => _ParseCvButtonState();
}

class _ParseCvButtonState extends State<ParseCvButton> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CvCubit, CvState>(
      builder: (context, state) {
        if (state is CvLoading) {
          return CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 4.0,
            percent: value / 100,
            center: Text("$value %"),
            animation: true,
            animateFromLastPercent: true,
            progressColor: Colors.green,
          );
        }

        return TextButton(
          onPressed: () {
            showModalBottomSheet(
                elevation: 3,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
                context: context,
                builder: (_) {
                  return GetFile(onPickFile: (file) {
                    context.read<CvCubit>().fCreateCvWithFile(
                        file: file,
                        onSendProgress: (count, total) {
                          // emit loading with new ratio
                          setState(() {
                            value = double.parse(
                                ((count / total) * 100).toStringAsFixed(2));
                            log(value.toString());
                          });
                        });
                  });
                });
          },
          child: Text(
            tr("parse_cv"),
            style: TextStyles.bodyText16.copyWith(color: mainColor),
          ),
        );
      },
    );
  }
}
