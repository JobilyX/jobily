import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/phone_form_feild.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../injection_container.dart';
import '../cubit/auto_login/auto_login_cubit.dart';
import '../cubit/register/register_cubit.dart';
import '../widgets/auth_headline_widget.dart';
import '../widgets/auth_vector_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController first = TextEditingController();
  final TextEditingController last = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirmation = TextEditingController();
  final listOfGender = ["female", "male"];
  String? groupValue;
  String? selectedPhoneCountry;
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AuthVectorArtWidget(
                          image: userType == UserType.hr
                              ? registerImageHr
                              : registerImage),
                      AuthHeadlineWidget(text: tr("Sign")),
                      MasterTextField(
                        controller: first,
                        text: tr("First"),
                        icon: personIcon,
                        keyboardType: TextInputType.name,
                        validate: (p0) => Validator.name(p0),
                      ),
                      const SpaceV20BE(),
                      MasterTextField(
                        controller: last,
                        text: tr("Last"),
                        icon: personIcon,
                        keyboardType: TextInputType.name,
                        validate: (p0) => Validator.name(p0),
                      ),
                      const SpaceV20BE(),
                      MasterTextField(
                        controller: email,
                        text: tr("Email"),
                        icon: emailIcon,
                        keyboardType: TextInputType.emailAddress,
                        validate: (p0) => Validator.email(p0),
                      ),
                      const SpaceV20BE(),
                      PhoneFormFeild(
                        controller: phone,
                        selectedPhoneCountryFunc: (val) {
                          selectedPhoneCountry = val.code;
                        },
                      ),
                      const SpaceV20BE(),
                      DatePicker(date: date),
                      const SpaceV20BE(),
                      PasswordTextField(
                        controller: password,
                        text: tr("Password"),
                        validate: (p0) => Validator.password(p0),
                      ),
                      const SpaceV20BE(),
                      PasswordTextField(
                        controller: passwordConfirmation,
                        text: tr("Password"),
                        validate: (p0) =>
                            Validator.confirmPassword(p0, password.text),
                      ),
                      const SpaceV20BE(),
                      Row(
                        children: [
                          SvgPicture.asset(
                            genderIcon,
                            fit: BoxFit.scaleDown,
                          ),
                          const SpaceHBE(),
                          Text(tr("Gender"))
                        ],
                      ),
                      Row(
                        children: [
                          ...listOfGender
                              .map<Widget>((e) => Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: spaceHeightTitleAndBody),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: spaceHeightTitleAndBody),
                                    child: Row(
                                      children: [
                                        Radio(
                                            fillColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                              if (states.contains(
                                                  MaterialState.disabled)) {
                                                return greyBG;
                                              }
                                              return mainColor;
                                            }),
                                            value: e,
                                            groupValue: groupValue,
                                            onChanged: (value) {
                                              setState(() {
                                                groupValue = e;
                                              });
                                            }),
                                        Text(e, style: TextStyles.bodyText14),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceV15BE(),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterLoading) {
                    return const Center(child: indicator);
                  }
                  return JobilyButton(
                      tag: "login",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        if (groupValue == null) {
                          showToast(tr("gender_is_required"), bG: errorColor);
                          return;
                        }
                        context.read<RegisterCubit>().fRegister(
                              first: first.text,
                              last: last.text,
                              email: email.text,
                              phone: selectedPhoneCountry! + phone.text,
                              date: date.text,
                              acceptTermsConditions: 1,
                              gender: groupValue!,
                              password: password.text,
                              passwordConfirmation: passwordConfirmation.text,
                            );
                      },
                      text: tr("Sign"));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr("Already"), style: TextStyles.bodyText12),
                  TextButton(
                      onPressed: () {
                        sl<AppNavigator>().pop();
                      },
                      child: Text(tr("Login"),
                          style: TextStyles.bodyText12
                              .copyWith(color: textButtonColor))),
                ],
              ),
              const SpaceV15BE(),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, required this.date}) : super(key: key);
  final TextEditingController date;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: widget.date, //editing controller of this TextField
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: formFieldBorder),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: formFieldBorder),
            ),
            hintStyle: TextStyles.bodyText16.copyWith(color: hintTextColor),
            prefixIcon: SvgPicture.asset(
              dateIcon,
              fit: BoxFit.scaleDown,
            ),
            hintText: tr("Date")),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(1999),
              firstDate: DateTime(1950),
              lastDate: DateTime.now());

          if (pickedDate != null) {
            String formattedDate =
                DateFormat('yyyy-MM-dd', "en").format(pickedDate);
            setState(() {
              widget.date.text =
                  formattedDate; //set output date to TextField value.
            });
          }
        },
      ),
    );
  }
}
