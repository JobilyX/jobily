// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/constant/styles/styles.dart';
import '../constant/colors/colors.dart';
import 'space_between_ele.dart';

class MasterBorderTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final String text;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String? Function(String?)? vaildator;
  final int maxLines;
  final int? maxlength;
  const MasterBorderTextField({
    Key? key,
    // this.inputFormatters,
    this.controller,
    this.keyboardType,
    this.isPassword,
    required this.text,
    this.onChanged,
    this.onSubmit,
    this.vaildator,
    this.maxLines = 1,
    this.maxlength,
  }) : super(key: key);

  @override
  State<MasterBorderTextField> createState() => _MasterBorderTextFieldState();
}

class _MasterBorderTextFieldState extends State<MasterBorderTextField> {
  bool secure = false;
  TextDirection? textDirection;
  String? fontFamily;
  @override
  void initState() {
    super.initState();
    secure = widget.isPassword ?? false;
    if (widget.keyboardType == TextInputType.number) {
      fontFamily = "Almarai";
    }
  }

  @override
  void didUpdateWidget(covariant MasterBorderTextField oldWidget) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.text,
            style: TextStyles.bodyText14.copyWith(color: darkTextColor)),
        const SpaceV5BE(),
        TextFormField(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          //autocorrect: true,
          controller: widget.controller,
          onChanged: (value) {
            _checkForArabicLetter(value);
            if (widget.onChanged != null) widget.onChanged!(value);
          },
          keyboardType: widget.keyboardType,
          obscureText: secure,
          style: TextStyles.bodyText14
              .copyWith(color: darkTextColor, fontFamily: fontFamily),
          validator: widget.vaildator,
          maxLines: widget.maxLines,
          onFieldSubmitted: widget.onSubmit,
          textDirection: textDirection,
          maxLength: widget.maxlength,
          // inputFormatters: inputFormatters,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            filled: false,
            errorMaxLines: 3,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: formFieldBorder,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: formFieldBorder,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: formFieldBorder,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: formFieldBorder,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: errorColor,
                  width: 1,
                  style: BorderStyle.solid,
                )),
            hintStyle: TextStyles.bodyText14.copyWith(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
