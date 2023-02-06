import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/widgets/main_appbar.dart';
import '../../../../core/widgets/side_padding.dart';
import '../../../../core/widgets/snackbars_toasst/snack_bar.dart';
import '../../../../injection_container.dart' as di;
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import '../../../auth/presentation/cubit/delete_account/delete_account_cubit.dart';
import '../../../auth/presentation/cubit/logout/logout_cubit.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/more_item_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: mainAppBar(title: tr("more")),
      body: SidePadding(
        sidePadding: 20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  children: [
                    MoreItemCard(
                      text: tr("contact_with_us"),
                      image: emailIcon,
                      tap: () {
                        // sl<AppNavigator>().push(
                        //   screen: ContactWithUsScreen(),
                        // );
                      },
                    ),
                    MoreItemCard(
                      text: tr("complaints"),
                      image: emailIcon,
                      tap: () {
                        // sl<AppNavigator>().push(
                        //   screen: ComplaintsScreen(),
                        // );
                      },
                    ),
                    MoreItemCard(
                      text: tr("who_us"),
                      image: emailIcon,
                      tap: () {
                        //  sl<AppNavigator>().push(
                        //     screen: const WhoUsScreen(), );
                      },
                    ),
                    MoreItemCard(
                      text: tr("privacy_policy"),
                      image: emailIcon,
                      tap: () {
                        // sl<AppNavigator>().push(
                        //   screen: const PrivacyAndPolicyScreen(),
                        // );
                      },
                    ),
                    MoreItemCard(
                      text: tr("terms_l"),
                      image: emailIcon,
                      tap: () {
                        // sl<AppNavigator>().push(
                        //   screen: const TermsAndLowsScreen(),
                        // );
                      },
                    ),
                    MoreItemCard(
                      text: tr("share_app"),
                      image: emailIcon,
                      tap: () async {
                        await FlutterShare.share(
                            title: 'Example share',
                            text: 'Example share text',
                            linkUrl: 'https://flutter.dev/',
                            chooserTitle: 'Example Chooser Title');
                      },
                    ),
                    MoreItemCard(
                      text: EasyLocalization.of(context)!
                                  .currentLocale!
                                  .languageCode ==
                              "ar"
                          ? "English"
                          : "العربية",
                      image: emailIcon,
                      tap: () async {
                        final loacle = EasyLocalization.of(context)!
                                    .currentLocale!
                                    .languageCode ==
                                "ar"
                            ? "en"
                            : "ar";
                        di.helper.updateLocalInHeaders(loacle);
                        //  sl<AppNavigator>().popTojobily();
                        EasyLocalization.of(context)!.setLocale(Locale(loacle));
                      },
                    ),
                    BlocConsumer<LogoutCubit, LogoutState>(
                      listener: (context, logoutState) {
                        if (logoutState is LogoutError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(appSnackBar(
                            logoutState.message,
                          ));
                        } else if (logoutState is LogoutSuccess) {
                          sl<AppNavigator>().popTojobily();
                          context.read<AutoLoginCubit>().emitNoUser();
                        }
                      },
                      builder: ((context, state) {
                        return MoreItemCard(
                            text: tr("log_out"),
                            image: emailIcon,
                            tap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return LogoutDialoug(
                                      yes: () async {
                                        await context
                                            .read<LogoutCubit>()
                                            .fLogout();
                                        sl<AppNavigator>().pop();
                                      },
                                      no: () {
                                        sl<AppNavigator>().pop();
                                      },
                                    );
                                  },
                                ));
                      }),
                    ),
                    const SizedBox(height: 10),
                    BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                      listener: (context, state) {
                        if (state is DeleteAcountErrorState) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(appSnackBar(
                            state.message,
                          ));
                        } else if (state is DeleteAcountSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              appSnackBar(state.message, color: Colors.green));
                          sl<AppNavigator>().popTojobily();
                          context.read<AutoLoginCubit>().emitNoUser();
                        }
                      },
                      builder: ((context, state) {
                        return MoreItemCard(
                            text: tr("delete_account"),
                            // image: deleteAccountIcon,
                            imagecolor: errorColor,
                            textColor: errorColor,
                            imagewidth: 25,
                            tap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return const DeleteAccountDialog();
                                  },
                                ));
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer();
  }
}

class LogoutDialoug extends StatefulWidget {
  const LogoutDialoug({super.key, required this.no, required this.yes});
  final Function no;
  final Function yes;

  @override
  State<LogoutDialoug> createState() => _LogoutDialougState();
}

class _LogoutDialougState extends State<LogoutDialoug> {
  bool isLoading = false;
  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        tr("are_you_sure_to_logout?"),
        style: TextStyles.bodyText12.copyWith(color: errorColor),
      ),
      actions: [
        isLoading
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocBuilder<LogoutCubit, LogoutState>(
                    builder: (context, state) {
                      return TextButton(
                          onPressed: () async {
                            toggleIsLoading();
                            await widget.yes();
                            toggleIsLoading();
                            //   sl<AppNavigator>().pop();
                          },
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                tr("yes"),
                                style: TextStyles.bodyText12
                                    .copyWith(color: errorColor),
                              ),
                            ),
                          ));
                    },
                  ),
                  TextButton(
                      onPressed: () => widget.no(),
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            tr("no"),
                            style: TextStyles.bodyText12
                                .copyWith(color: mainColor),
                          ),
                        ),
                      ))
                ],
              )
        // The "Yes" button
      ],
    );
  }
}
