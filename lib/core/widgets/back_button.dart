import 'package:flutter/material.dart';

import '../constant/colors/colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: BackButton(color: mainColor),
    );
  }
}
