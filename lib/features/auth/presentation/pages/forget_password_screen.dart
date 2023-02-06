import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/master_textfield.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/back_button.dart';
import '../cubit/auto_login/auto_login_cubit.dart';
import '../cubit/forget_password/cubit/forget_password_cubit.dart';
import '../widgets/auth_headline_widget.dart';
import '../widgets/auth_vector_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userType = context.read<AutoLoginCubit>().selectedUserType;
    return Scaffold(
      backgroundColor: backgorundColor,
      body: Form(
        key: formKey,
        child: Padding(
          padding: sidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              AuthVectorArtWidget(
                  image: userType == UserType.hr ? forgetImageHr : forgetImage),
              const SpaceV40BE(),
              AuthHeadlineWidget(text: tr("Forget_password")),
              const SpaceV20BE(),
              Text(
                tr("Don’t_worry"),
                style: TextStyles.bodyText14,
              ),
              const SpaceV20BE(),
              MasterTextField(
                text: tr("Email"),
                icon: emailIcon,
                keyboardType: TextInputType.emailAddress,
                controller: email,
                validate: (p0) => Validator.email(p0),
              ),
              const SpaceV20BE(),
              const SpaceV40BE(),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                builder: (context, state) {
                  if (state is ForgetPasswordLoading) {
                    return const Center(child: indicator);
                  }
                  return JobilyButton(
                      tag: "login",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        context.read<ForgetPasswordCubit>().fGetForgetPassCode(
                            email: email.text, resend: false);
                      },
                      text: tr("Send"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
