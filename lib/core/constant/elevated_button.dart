import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import 'colors/colors.dart';
import 'size_config.dart';
import 'styles/styles.dart';

class JobilyButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double height;
  final double? width;
  final bool isDisabled;
  final Color? color;
  final VoidCallback? onPressed;
  final String text;
  final String? tag;

  const JobilyButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.borderRadius,
      this.tag,
      this.isDisabled = false,
      this.height = 56.0,
      this.width,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<AutoLoginCubit>().selectedUserType;
    final borderRadius = this.borderRadius ?? BorderRadius.circular(10);
    return Hero(
      tag: tag ?? UniqueKey().toString(),
      child: Container(
        width: width ?? SizeConfig.blockSizeHorizontal * 90,
        height: height,
        decoration: BoxDecoration(
            borderRadius: borderRadius, color: isDisabled ? greyBG : white),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ??
                (userType! == UserType.job_seeker ? mainColor : accentColor),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Text(
            text,
            style: TextStyles.buttonText16,
          ),
        ),
      ),
    );
  }
}
