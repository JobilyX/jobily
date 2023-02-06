import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/styles/styles.dart';
import '../constant/colors/colors.dart';
import '../util/validator.dart';

class MasterTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final String text;
  final String? icon;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String? Function(String?) validate;
  const MasterTextField({
    Key? key,
    this.controller,
    this.isPassword,
    this.keyboardType,
    this.onChanged,
    this.onSubmit,
    this.validate = Validator.defaultEmptyValidator,
    required this.text,
    this.icon,
    // this.inputFormatters,
  }) : super(key: key);

  @override
  State<MasterTextField> createState() => _MasterTextFieldState();
}

class _MasterTextFieldState extends State<MasterTextField> {
  bool secure = false;
  TextDirection? textDirection;
  String? fontFamily = "Inter";
  @override
  void initState() {
    super.initState();
    secure = widget.isPassword ?? false;
    if (widget.keyboardType == TextInputType.number) {
      fontFamily = "Almarai";
    }
  }

  @override
  void didUpdateWidget(covariant MasterTextField oldWidget) {
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
      keyboardType: widget.keyboardType,
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
        prefixIcon: widget.icon == null
            ? null
            : SvgPicture.asset(
                widget.icon!,
                fit: BoxFit.scaleDown,
              ),
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
