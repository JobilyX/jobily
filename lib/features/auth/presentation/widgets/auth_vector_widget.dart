import 'package:flutter/material.dart';

class AuthVectorArtWidget extends StatelessWidget {
  const AuthVectorArtWidget({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "auth_vector_art",
      child: Center(
        child: Image.asset(
          image,
          height: 200,
          // width: SizeConfig.blockSizeHorizontal * 60,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
