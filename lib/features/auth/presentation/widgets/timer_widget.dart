import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/snackbars_toasst/snack_bar.dart';
import '../../domain/usecases/register.dart';
import '../cubit/forget_password/cubit/forget_password_cubit.dart';
import '../cubit/register/register_cubit.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {Key? key,
      this.code,
      this.email,
      this.registerParams,
      required this.register})
      : super(key: key);

  final String? code;
  final String? email;
  final bool register;
  final RegisterParams? registerParams;
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    final seconds = twoDigits(_start.remainder(60));
    return !widget.register
        ? BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
            listener: (context, state) {
              if (state is ForgetPasswordResendCode) {
                ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
                    tr("code_resend_successflly"),
                    color: Colors.green));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("00:$seconds"),
                TextButton(
                  onPressed: _start <= 0
                      ? () {
                          {
                            context
                                .read<ForgetPasswordCubit>()
                                .fGetForgetPassCode(
                                  resend: true,
                                  email: widget.email!,
                                );
                            setState(() {
                              _start = 60;
                              startTimer();
                            });
                          }
                        }
                      : null,
                  child: Text(
                    _start <= 0 ? tr("Resend") : tr("wait_for_code"),
                    style: _start <= 0
                        ? TextStyles.bodyText14.copyWith(color: mainColor)
                        : TextStyles.bodyText14
                            .copyWith(color: const Color(0xffCFCFCF)),
                  ),
                ),
              ],
            ),
          )
        : BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterResendCode) {
                ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
                    tr("code_resend_successflly"),
                    color: Colors.green));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("00:$seconds"),
                TextButton(
                  onPressed: _start <= 0
                      ? () {
                          {
                            final data = widget.registerParams!;
                            context.read<RegisterCubit>().fRegister(
                                  reSend: true,
                                  email: data.email,
                                  first: data.first,
                                  last: data.last,
                                  phone: data.phone,
                                  acceptTermsConditions:
                                      data.acceptTermsConditions,
                                  gender: data.gender,
                                  password: data.password,
                                  passwordConfirmation:
                                      data.passwordConfirmation,
                                  date: data.date,
                                );
                            setState(() {
                              _start = 60;
                              startTimer();
                            });
                          }
                        }
                      : null,
                  child: Text(
                    _start <= 0 ? tr("Resend") : tr("wait_for_code"),
                    style: _start <= 0
                        ? TextStyles.bodyText14.copyWith(color: mainColor)
                        : TextStyles.bodyText14
                            .copyWith(color: const Color(0xffCFCFCF)),
                  ),
                ),
              ],
            ),
          );
  }
}
