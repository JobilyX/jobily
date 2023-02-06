// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../core/widgets/master_textfield.dart';
// import '../../../../../core/widgets/side_padding.dart';
// import '../../../../../core/widgets/space.dart';
// import '../../../../core/constant/colors/colors.dart';
// import '../../../../core/constant/icons.dart';
// import '../../../../core/constant/styles/styles.dart';
// import '../../../../core/util/navigator.dart';
// import '../../../../core/util/validator.dart';
// import '../../../../core/widgets/details_text_form_field_box.dart';
// import '../../../../core/widgets/loading.dart';
// import '../../../../core/widgets/master_button.dart';
// import '../../../../core/widgets/snackbars_toasst/snack_bar.dart';
// import '../../../../core/widgets/splash_language_dropdown.dart';
// import '../../../../injection_container.dart';
// import '../../domain/entities/get_complain_types.dart';
// import '../cubit/connect_us/connect_us_cubit.dart';

// class ComplaintsScreen extends StatelessWidget {
//   ComplaintsScreen({Key? key}) : super(key: key);
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tr("complaints")),
//       ),
//       backgroundColor: white,
//       body: Form(
//         key: formKey,
//         child: SidePadding(
//           sidePadding: 20,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Space(boxHeight: 10),
//                 MasterTextField(
//                   validate: (val) => Validator.name(val),
//                   controller: nameController,
//                   prefixIcon: emailIcon,
//                   fieldHeight: 60,
//                   borderColor: mainColor,
//                   textFieldColor: white,
//                   borderRadius: 10,
//                   hintText: tr("triple_name"),
//                   keyboardType: TextInputType.text,
//                 ),
//                 const Space(boxHeight: 20),
//                 MasterTextField(
//                   validate: (val) => Validator.email(val),
//                   controller: emailController,
//                   prefixIcon: emailIcon,
//                   fieldHeight: 60,
//                   borderColor: mainColor,
//                   textFieldColor: white,
//                   borderRadius: 10,
//                   hintText: tr("email"),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const Space(boxHeight: 20),
//                 /////////////////////////////

//                 BlocBuilder<ConnectUsCubit, ConnectUsState>(
//                     builder: (context, state) {
//                   if (state is ComplaintTypesLoading) {
//                     return const LinearProgressIndicator(
//                       color: mainColor,
//                     );
//                   } else if (state is ComplaintTypesError) {
//                     return const SizedBox();
//                   } else {
//                     final bloc = context.watch<ConnectUsCubit>();
//                     return bloc.types.isEmpty
//                         ? const SizedBox()
//                         : BuildDropDown<ComplaintTypesDetails>(
//                             isExpanded: true,
//                             value: bloc.selectedType!,
//                             textColor: mainColor,
//                             onChange: (value) {
//                               bloc.changeType(value);
//                             },
//                             items:
//                                 bloc.types.map((ComplaintTypesDetails value) {
//                               return DropdownMenuItem<ComplaintTypesDetails>(
//                                   value: value,
//                                   child: Center(
//                                       child: Text(value.title,
//                                           style: TextStyles.bodyText12
//                                               .copyWith(color: mainColor))));
//                             }).toList(),
//                             hint: tr("complaints_type"),
//                             image: emailIcon,
//                             icon: Image.asset(
//                               emailIcon,
//                               color: mainColor,
//                               width: 15,
//                             ),
//                           );
//                   }
//                 }),
//                 const Space(
//                   boxHeight: 20,
//                 ),
//                 TextFormFieldBox(
//                   validate: (val) => Validator.text(val),
//                   messageController: messageController,
//                   text: tr("complaint"),
//                 ),
//                 const Space(
//                   boxHeight: 50,
//                 ),
//                 BlocConsumer<ConnectUsCubit, ConnectUsState>(
//                     listener: (context, state) {
//                   if (state is ConnectUsSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
//                       tr("your_message_has_been_sent"),
//                       color: Colors.green,
//                     ));
//                     sl<AppNavigator>().pop();
//                   } else if (state is ConnectUsError) {
//                     ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
//                       state.message,
//                     ));
//                   }
//                 }, builder: (context, state) {
//                   if (state is ConnectUsLoading) {
//                     return const Loading();
//                   }
//                   return MasterButton(
//                     tag: "send",
//                     buttonText: tr("send"),
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         context.read<ConnectUsCubit>().fSendComplaint(
//                               email: emailController.text,
//                               name: nameController.text,
//                               message: messageController.text,
//                             );
//                       }
//                     },
//                     borderColor: mainColor,
//                     buttonColor: mainColor,
//                     buttonRadius: 10.r,
//                     buttonHeight: 63.h,
//                     buttonWidth: 296.w,
//                   );
//                 })
//                 //
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
