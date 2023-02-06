// import 'package:easy_localization/easy_localization.dart' as e;
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../../core/constant/styles/styles.dart';
// import '../util/validator.dart';
// import 'colors/colors.dart';
// import 'icons.dart';

// class PhoneFormFeild extends StatefulWidget {
//   final TextEditingController controller;
//   final bool obSecure;
//   final bool isClickable;
//   final TextInputType keyboardType;
//   final Function(String)? onChanged;
//   final Function? validateFunction;
//   const PhoneFormFeild({
//     Key? key,
//     required this.controller,
//     this.isClickable = true,
//     this.obSecure = false,
//     this.keyboardType = TextInputType.text,
//     this.validateFunction,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   State<PhoneFormFeild> createState() => _PhoneFormFeildState();
// }

// class _PhoneFormFeildState extends State<PhoneFormFeild> {
//   bool secure = false;
//   TextDirection? textDirection;
//   String? fontFamily;
//   @override
//   void initState() {
//     super.initState();
//     if (widget.keyboardType == TextInputType.number) {
//       fontFamily = "";
//     }
//   }

//   void _checkForArabicLetter(String text) {
//     final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
//     final englishRegex = RegExp(r'[a-zA-Z ]');
//     final spi = RegExp("[\$&+,:;=?@#|'<>.^*()%!-]+");
//     final numbers = RegExp("^[0-9]*\$");
//     setState(() {
//       text.contains(arabicRegex) &&
//               !text.startsWith(englishRegex) &&
//               !text.startsWith(spi) &&
//               !text.startsWith(numbers)
//           ? textDirection = TextDirection.rtl
//           : textDirection = TextDirection.ltr;
//     });
//   }

//   @override
//   void didUpdateWidget(covariant PhoneFormFeild oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       validator: (value) => Validator.phone(value),
//       onChanged: (value) {
//         _checkForArabicLetter(value);
//         if (widget.onChanged != null) widget.onChanged!(value);
//       },
//       // onChanged: widget.onChanged,
//       style: TextStyles.bodyText16.copyWith(color: darkTextColor),
//       decoration: InputDecoration(
//         hintText: e.tr("Phone"),
//         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//         prefixIcon: SvgPicture.asset(
//           phnoeIcon,
//           fit: BoxFit.scaleDown,
//         ),
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: darkTextColor),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: darkTextColor),
//         ),
//         hintStyle: TextStyles.bodyText16.copyWith(color: hintTextColor),
//       ),
//       keyboardType: TextInputType.phone,
//       controller: widget.controller,
//     );
//   }
// }

// class PhoneModel extends Equatable {
//   final String code;
//   final String startWith;
//   final int lenght;

//   const PhoneModel(
//       {required this.code, required this.lenght, required this.startWith});

//   @override
//   List<Object?> get props => [code, lenght];
// }
