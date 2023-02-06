import 'package:easy_localization/easy_localization.dart' as e;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant/styles/styles.dart';
import '../constant/colors/colors.dart';
import '../constant/space_between_ele.dart';
import '../util/validator.dart';

class PhoneFormFeild extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) validate;
  final Function(PhoneModel) selectedPhoneCountryFunc;
  const PhoneFormFeild({
    Key? key,
    required this.controller,
    required this.selectedPhoneCountryFunc,
    this.validate = Validator.defaultEmptyValidator,
  }) : super(key: key);

  @override
  State<PhoneFormFeild> createState() => _PhoneFormFeildState();
}

class _PhoneFormFeildState extends State<PhoneFormFeild> {
  bool secure = false;
  TextDirection? textDirection;
  String? fontFamily;
  @override
  void initState() {
    super.initState();
    widget.selectedPhoneCountryFunc(selectedPhoneModel);
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
  void didUpdateWidget(covariant PhoneFormFeild oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  List<DropdownMenuItem<PhoneModel>> items = [
    ...[
      const PhoneModel(code: "+966", lenght: 9, startWith: "5"),
      const PhoneModel(code: "+20", lenght: 10, startWith: "1")
    ]
        .map<DropdownMenuItem<PhoneModel>>((e) => DropdownMenuItem(
              value: e,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  e.code,
                  style: TextStyles.bodyText16.copyWith(color: darkTextColor),
                ),
              ),
            ))
        .toList()
  ];
  PhoneModel selectedPhoneModel =
      const PhoneModel(code: "+966", lenght: 9, startWith: "5");
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: LimitedBox(
          child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: formFieldBorder, width: 1))),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                  child: DropdownButton(
                    value: selectedPhoneModel,
                    items: items,
                    style: TextStyles.bodyText16.copyWith(color: darkTextColor),
                    underline: null,
                    onChanged: (value) {
                      if (value != null) {
                        selectedPhoneModel = value;
                        widget.selectedPhoneCountryFunc(value);
                        setState(() {});
                      }
                    },
                  ),
                ),
              )),
        ),
      ),
      const SpaceHBE(),
      Expanded(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 1,
          textDirection: TextDirection.ltr,
          validator: (value) => Validator.phone(value, selectedPhoneModel),
          onChanged: (value) {
            _checkForArabicLetter(value);
          },
          // onChanged: widget.onChanged,
          style: TextStyles.bodyText16.copyWith(color: darkTextColor),
          decoration: InputDecoration(
            hintText: e.tr("Phone"),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: formFieldBorder),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: formFieldBorder),
            ),
            hintStyle: TextStyles.bodyText16.copyWith(color: hintTextColor),
          ),
          keyboardType: TextInputType.phone,
          controller: widget.controller,
        ),
      ))
    ]);
  }
}

class PhoneModel extends Equatable {
  final String code;
  final String startWith;
  final int lenght;

  const PhoneModel(
      {required this.code, required this.lenght, required this.startWith});

  @override
  List<Object?> get props => [code, lenght];
}
