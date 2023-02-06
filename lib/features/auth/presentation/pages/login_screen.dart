import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/master_textfield.dart';
import '../../../../core/constant/password_textfiled.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../injection_container.dart';
import '../cubit/auto_login/auto_login_cubit.dart';
import '../cubit/login_cubit/login_cubit.dart';
import '../widgets/auth_headline_widget.dart';
import '../widgets/auth_vector_widget.dart';
import 'forget_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userType = context.watch<AutoLoginCubit>().selectedUserType;
    return Scaffold(
      backgroundColor: backgorundColor,
      body: Form(
        key: formKey,
        child: Padding(
          padding: sidePadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceV80BE(),
                AuthVectorArtWidget(
                    image: userType == UserType.hr ? loginImageHr : loginImage),
                const SpaceV40BE(),
                AuthHeadlineWidget(text: tr("Login")),
                const SpaceV20BE(),
                MasterTextField(
                  controller: email,
                  text: tr("Email"),
                  icon: emailIcon,
                  keyboardType: TextInputType.emailAddress,
                  validate: (p0) => Validator.email(p0),
                ),
                const SpaceV20BE(),
                PasswordTextField(
                  controller: password,
                  text: tr("Password"),
                  validate: (p0) => Validator.password(p0),
                ),
                const SpaceV15BE(),
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {
                      sl<AppNavigator>()
                          .push(screen: const ForgetPasswordScreen());
                    },
                    child: Text(tr("Forget"), style: TextStyles.bodyText12),
                  ),
                ),
                const SpaceV20BE(),
                const SpaceV15BE(),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: indicator);
                    }
                    return JobilyButton(
                        tag: "login",
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          context.read<LoginCubit>().fLogin(
                              password: password.text, email: email.text);
                        },
                        text: tr("Login"));
                  },
                ),
                const SpaceV15BE(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${tr(userType!.name)} ?",
                        style: TextStyles.bodyText12),
                    TextButton(
                        onPressed: () {
                          sl<AppNavigator>()
                              .push(screen: const RegisterScreen());
                        },
                        child: Text(tr("Sign"),
                            style: TextStyles.bodyText12
                                .copyWith(color: textButtonColor))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
