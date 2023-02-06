import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant/styles/styles.dart';
import '../constant/colors/colors.dart';
import '../util/validator.dart';
import 'icons.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? isPassword;
  final String text;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String? Function(String?) validate;
  const PasswordTextField({
    Key? key,
    this.controller,
    this.isPassword,
    this.onChanged,
    this.onSubmit,
    this.validate = Validator.defaultEmptyValidator,
    required this.text,
    // this.inputFormatters,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool secure = false;
  TextDirection? textDirection;
  String? fontFamily;
  @override
  void initState() {
    super.initState();
    secure = widget.isPassword ?? false;
    if (TextInputType.visiblePassword == TextInputType.number) {
      fontFamily = "Almarai";
    }
  }

  @override
  void didUpdateWidget(covariant PasswordTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void _checkForArabicLetter(String text) {
    final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
    final englishRegex = RegExp(r'[a-zA-Z ]');
    final spi = RegExp("[\$&+,:;=?@#|'<>.^*()%!-]+");
    final numbers = RegExp("^[0-9]*\$");
    setState(() {
      text.contains(arabicRegex) &&
              !text.startsWith(englishRegex) &&
              !text.startsWith(spi) &&
              !text.startsWith(numbers)
          ? textDirection = TextDirection.rtl
          : textDirection = TextDirection.ltr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      //autocorrect: true,
      controller: widget.controller,
      onChanged: (value) {
        _checkForArabicLetter(value);
        if (widget.onChanged != null) widget.onChanged!(value);
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: secure,
      style: TextStyles.bodyText16
          .copyWith(color: darkTextColor, fontFamily: fontFamily),
      validator: widget.validate,
      onFieldSubmitted: widget.onSubmit,
      textDirection: textDirection,
      // inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: widget.text,
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Container(
            margin: const EdgeInsetsDirectional.only(start: 6),
            child: SvgPicture.asset(
              lockIcon,
              fit: BoxFit.scaleDown,
            )),
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                secure = !secure;
              });
            },
            child: SvgPicture.asset(
              eyePassIcon,
              fit: BoxFit.scaleDown,
              color: secure ? hintTextColor : mainColor,
            )),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: formFieldBorder),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: formFieldBorder),
        ),
        hintStyle: TextStyles.bodyText16.copyWith(color: hintTextColor),
      ),
    );
  }
}
