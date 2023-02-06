import 'package:flutter/material.dart';

class CardDivider extends StatelessWidget {
  final Color color;
  final double? thikness;
  const CardDivider({Key? key, required this.color, this.thikness = 0.3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thikness,
      height: 0.3,
    );
  }
}
