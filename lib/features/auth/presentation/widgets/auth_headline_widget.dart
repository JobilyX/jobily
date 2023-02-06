import 'package:flutter/material.dart';

import '../../../../core/constant/styles/styles.dart';

class AuthHeadlineWidget extends StatelessWidget {
  const AuthHeadlineWidget({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.headLine1,
    );
  }
}
