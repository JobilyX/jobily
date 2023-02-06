import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import '../../../auth/presentation/widgets/auth_vector_widget.dart';

class WhichOneScreen extends StatelessWidget {
  const WhichOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: accentColor,
        body: Padding(
          padding: sidePadding,
          child: Column(
            children: [
              const SizedBox(height: 80),
              const AuthVectorArtWidget(image: whichOneImage),
              Text(tr("which_one_2"),
                  style: TextStyles.headLine1.copyWith(color: white)),
              const SpaceV5BE(),
              Text(tr("which_one_3"),
                  style: TextStyles.bodyText16.copyWith(color: white)),
              const SpaceV40BE(),
              Text(
                tr("which_one_1"),
                style: TextStyles.bodyText20.copyWith(color: white),
              ),
              const SpaceV40BE(),
              Container(
                width: SizeConfig.blockSizeHorizontal * 90,
                height: 56.0,
                decoration: BoxDecoration(
                    borderRadius: borderRadius, color: accentColor),
                child: ElevatedButton(
                  onPressed: () {
                    sl<AutoLoginCubit>().emitSeenIntro(type: UserType.hr);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1, color: white),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  ),
                  child: Text(
                    tr("hr"),
                    style: TextStyles.buttonText16,
                  ),
                ),
              ),
              const SpaceV15BE(),
              Hero(
                tag: "login",
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 90,
                  height: 56.0,
                  decoration:
                      BoxDecoration(borderRadius: borderRadius, color: white),
                  child: ElevatedButton(
                    onPressed: () {
                      sl<AutoLoginCubit>()
                          .emitSeenIntro(type: UserType.job_seeker);
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 1, color: white),
                      backgroundColor: white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    ),
                    child: Text(
                      tr("job_seeker"),
                      style:
                          TextStyles.buttonText16.copyWith(color: blackColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
