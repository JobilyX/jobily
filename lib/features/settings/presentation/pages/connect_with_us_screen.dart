// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../core/widgets/master_textfield.dart';
// import '../../../../../core/widgets/side_padding.dart';
// import '../../../../../core/widgets/space.dart';
// import '../../../../core/constant/colors/colors.dart';
// import '../../../../core/constant/icons.dart';
// import '../../../../core/util/navigator.dart';
// import '../../../../core/util/validator.dart';
// import '../../../../core/widgets/details_text_form_field_box.dart';
// import '../../../../core/widgets/master_button.dart';
// import '../../../../core/widgets/phone_form_feild.dart';
// import '../../../../core/widgets/snackbars_toasst/snack_bar.dart';
// import '../../../../injection_container.dart';
// import '../cubit/connect_us/connect_us_cubit.dart';

// class ContactWithUsScreen extends StatelessWidget {
//   ContactWithUsScreen({Key? key}) : super(key: key);
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(tr("contact_with_us"))),
//       backgroundColor: white,
//       body: Form(
//         key: formKey,
//         child: SidePadding(
//           sidePadding: 20,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Space(boxHeight: 65),
//                 MasterTextField(
//                     prefixIcon: emailIcon,
//                     fieldHeight: 60,
//                     borderColor: mainColor,
//                     textFieldColor: white,
//                     controller: nameController,
//                     borderRadius: 10,
//                     hintText: tr("triple_name"),
//                     keyboardType: TextInputType.text,
//                     validate: (val) => Validator.text(val)),
//                 const Space(boxHeight: 20),
//                 MasterTextField(
//                     controller: emailController,
//                     prefixIcon: emailIcon,
//                     fieldHeight: 60,
//                     borderColor: mainColor,
//                     textFieldColor: white,
//                     borderRadius: 10,
//                     hintText: tr("email"),
//                     keyboardType: TextInputType.emailAddress,
//                     validate: (val) => Validator.email(val)),
//                 const Space(boxHeight: 20),
//                 PhoneFormFeild(
//                   // prefixIcon: phoneIcon,
//                   controller: phoneController,
//                   selectedPhoneCountryFunc: (a) {},
//                   validate: (val) => Validator.phone(val),
//                 ),
//                 const Space(boxHeight: 20),
//                 TextFormFieldBox(
//                     messageController: messageController,
//                     text: tr("your_message"),
//                     validate: (val) => Validator.name(val)),
//                 const Space(boxHeight: 102),
//                 BlocConsumer<ConnectUsCubit, ConnectUsState>(
//                     listener: (context, state) {
//                   if (state is ConnectUsSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
//                       tr("your_message_has_been_sent"),
//                       color: Colors.green,
//                     ));
//                     sl<AppNavigator>().pop();
//                   } else if (state is ConnectUsError) {
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(appSnackBar(state.message));
//                   }
//                 }, builder: (context, state) {
//                   if (state is ConnectUsLoading) {
//                     return const CircularProgressIndicator();
//                   }
//                   return MasterButton(
//                     tag: "send",
//                     buttonText: tr("send"),
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         context.read<ConnectUsCubit>().fConnectUs(
//                               email: emailController.text,
//                               name: nameController.text,
//                               message: messageController.text,
//                               phone: "+966${phoneController.text}",
//                             );
//                       }
//                     },
//                     borderColor: mainColor,
//                     buttonColor: mainColor,
//                     buttonRadius: 10.r,
//                     buttonHeight: 63.h,
//                     buttonWidth: 296.w,
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
