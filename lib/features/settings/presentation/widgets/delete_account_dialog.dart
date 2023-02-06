import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/delete_account/delete_account_cubit.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
  });

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
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
      title: Column(
        children: [
          Text(
            tr("are_you_sure_to_delete_account"),
            style: TextStyles.bodyText12.copyWith(color: errorColor),
          ),
          isLoading
              ? const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                        builder: (context, logoutState) {
                      return TextButton(
                          onPressed: () async {
                            toggleIsLoading();
                            await context
                                .read<DeleteAccountCubit>()
                                .fDeleteAccount();
                            toggleIsLoading();
                          },
                          child: Container(
                            width: 70,
                            height: 28,
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                tr("yes"),
                                style: TextStyles.bodyText12
                                    .copyWith(color: white),
                              ),
                            ),
                          ));
                    }),
                    TextButton(
                        onPressed: () {
                          sl<AppNavigator>().pop();
                        },
                        child: Container(
                          width: 70,
                          height: 28,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              tr("no"),
                              style: TextStyles.bodyText12
                                  .copyWith(color: errorColor),
                            ),
                          ),
                        ))
                  ],
                )
        ],
      ),
    );
  }
}
