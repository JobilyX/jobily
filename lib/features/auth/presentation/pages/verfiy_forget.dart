import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/pincode.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../injection_container.dart';
import '../cubit/auto_login/auto_login_cubit.dart';
import '../cubit/forget_password/cubit/forget_password_cubit.dart';
import '../cubit/otp_cubit/otp_cubit.dart';
import '../widgets/auth_headline_widget.dart';
import '../widgets/auth_vector_widget.dart';
import '../widgets/timer_widget.dart';

class VerfiyCodeScreen extends StatefulWidget {
  const VerfiyCodeScreen({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<VerfiyCodeScreen> createState() => _VerfiyCodeScreenState();
}

class _VerfiyCodeScreenState extends State<VerfiyCodeScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final code = context.watch<ForgetPasswordCubit>().code;
    final userType = context.read<AutoLoginCubit>().selectedUserType;
    return Scaffold(
      backgroundColor: backgorundColor,
      body: Padding(
        padding: sidePadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              AuthVectorArtWidget(
                  image: userType == UserType.hr ? codeImageHr : codeImage),
              const SpaceV40BE(),
              AuthHeadlineWidget(text: tr("OTP")),
              const SpaceV20BE(),
              Text(
                tr("verified") + widget.email,
                style: TextStyles.bodyText14,
              ),
              const SpaceV20BE(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {
                      sl<AppNavigator>().pop();
                    },
                    child:
                        Text(tr("Change_email"), style: TextStyles.bodyText12),
                  ),
                ),
              ]),
              PinCode(codeController: codeController),
              TimerWidget(
                register: false,
                email: widget.email,
              ),
              const SpaceV20BE(),
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  if (state is OtpLoading) {
                    return const Center(child: indicator);
                  }
                  return JobilyButton(
                      tag: "login",
                      text: tr("Submit"),
                      onPressed: () {
                        if (codeController.text.isEmpty ||
                            code.toString() != codeController.text.trim()) {
                          showToast(tr("enter_valid_code"), bG: errorColor);
                        } else {
                          FocusScope.of(context).unfocus();
                          context.read<OtpCubit>().fcheckForgetPasswordCode(
                              email: widget.email,
                              code: code.toString(),
                              codeController: codeController);
                        }
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
