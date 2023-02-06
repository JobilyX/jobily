import 'package:flutter/material.dart';

import '../../../../core/constant/size_config.dart';
import '../../../../core/widgets/side_padding.dart';
import '../../../../core/widgets/space.dart';

class IntroPage extends StatelessWidget {
  final String subject, image;
  final TextStyle style;

  const IntroPage({
    Key? key,
    required this.image,
    required this.subject,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: SidePadding(
        sidePadding: 20,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Space(
                  boxHeight: 25,
                ),
                Image.asset(
                  image,
                  height: 0.35 * SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(subject,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: style),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
