import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/space.dart';

class EmptyScreen extends StatelessWidget {
  final String image;
  final String title;
  const EmptyScreen({Key? key, required this.image, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          const Space(
            boxHeight: 50,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.bodyText20.copyWith(color: mainColor),
          ),
        ],
      ),
    );
  }
}

class EmptyScreenSVG extends StatelessWidget {
  final String image;
  final String title;
  const EmptyScreenSVG({Key? key, required this.image, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(image),
            const Space(
              boxHeight: 50,
            ),
            Text(
              title,
              style: TextStyles.bodyText20.copyWith(color: mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
