import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/password_textfiled.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/back_button.dart';
import '../cubit/set_new_password/cubit/set_new_password_cubit.dart';
import '../widgets/auth_headline_widget.dart';
import '../widgets/auth_vector_widget.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({Key? key, required this.token}) : super(key: key);
  final String token;
  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirmation = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              const AuthVectorArtWidget(image: newPasswordImage),
              const SpaceV40BE(),
              AuthHeadlineWidget(text: tr("Reset")),
              const SpaceV20BE(),
              PasswordTextField(
                controller: password,
                text: tr("Password"),
                validate: (p0) => Validator.password(p0),
              ),
              const SpaceV20BE(),
              PasswordTextField(
                controller: passwordConfirmation,
                text: tr("New_password"),
                validate: (p0) => Validator.confirmPassword(p0, password.text),
              ),
              const SpaceV40BE(),
              BlocBuilder<SetNewPasswordCubit, SetNewPasswordState>(
                builder: (context, state) {
                  if (state is SetNewPasswordLoading) {
                    return const Center(child: indicator);
                  }
                  return JobilyButton(
                      tag: "login",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        context.read<SetNewPasswordCubit>().fSetNewPassword(
                            newPass: password.text,
                            confirmPass: passwordConfirmation.text,
                            token: widget.token);
                      },
                      text: tr("Reset"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
