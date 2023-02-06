// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import '../../../../core/constant/images.dart';
// import '../../../../core/widgets/empty_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../../../core/widgets/side_padding.dart';
// import '../../../../core/constant/colors/colors.dart';
// import '../../../../core/constant/icons.dart';
// import '../../../../core/widgets/snackbars_toasst/snack_bar.dart';
// import '../../../../core/widgets/space.dart';
// import '../cubit/static_pages/cubit/static_content_cubit.dart';
// import '../widgets/social_button.dart';

// class WhoUsScreen extends StatefulWidget {
//   const WhoUsScreen({Key? key}) : super(key: key);

//   @override
//   State<WhoUsScreen> createState() => _WhoUsScreenState();
// }

// class _WhoUsScreenState extends State<WhoUsScreen> {
//   @override
//   void initState() {
//     super.initState();

//     context.read<StaticContentCubit>().aboutUs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(title: Text(tr("who_us"))),
//       body: SidePadding(
//         sidePadding: 20,
//         child: SizedBox(
//           width: double.infinity,
//           child: BlocConsumer<StaticContentCubit, StaticContentState>(
//             listener: (context, state) {
//               if (state is StaticContentError) {
//                 ScaffoldMessenger.of(context)
//                     .showSnackBar(appSnackBar(state.message));
//               }
//             },
//             builder: (context, state) {
//               if (state is StaticContentLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is StaticContentError) {
//                 return const Expanded(
//                   child: Center(child: Text("sadsadasd")),
//                 );
//               }
//               final data = context.watch<StaticContentCubit>().socialMediaData;
//               final info = context.watch<StaticContentCubit>().aboutUs;
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Html(
//                       data: info,
//                     ),
//                     const Space(boxWidth: 20),
//                     if (data != null)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           data.twitter.isNotEmpty
//                               ? SocialButton(
//                                   image: twitter,
//                                   onTap: () {
//                                     _launchUrl(url: data.twitter.toString());
//                                   })
//                               : const SizedBox(),
//                           const Space(boxWidth: 10),
//                           data.youtube.isNotEmpty
//                               ? SocialButton(
//                                   image: youtube,
//                                   onTap: () {
//                                     _launchUrl(url: data.youtube.toString());
//                                   })
//                               : const SizedBox(),
//                           const Space(boxWidth: 10),
//                           data.linkedin.isNotEmpty
//                               ? SocialButton(
//                                   image: linkedin,
//                                   onTap: () {
//                                     _launchUrl(url: data.linkedin.toString());
//                                   })
//                               : const SizedBox(),
//                           const Space(boxWidth: 10),
//                           data.snapchat.isNotEmpty
//                               ? SocialButton(
//                                   image: sanp,
//                                   onTap: () {
//                                     _launchUrl(url: data.snapchat.toString());
//                                   })
//                               : const SizedBox(),
//                           const Space(boxWidth: 10),
//                           data.facebook.isNotEmpty
//                               ? SocialButton(
//                                   image: facebook,
//                                   onTap: () {
//                                     _launchUrl(url: data.facebook.toString());
//                                   },
//                                 )
//                               : const SizedBox(),
//                           const Space(boxWidth: 10),
//                           data.phone.isNotEmpty
//                               ? SocialButton(
//                                   image: whatsapp,
//                                   onTap: () {
//                                     launchPhoneDialer(
//                                         contactNumber: data.phone.toString());
//                                   },
//                                 )
//                               : const SizedBox(),
//                           const Space(boxWidth: 10),
//                           data.instagram.isNotEmpty
//                               ? SocialButton(
//                                   image: instagram,
//                                   onTap: () {
//                                     _launchUrl(url: data.instagram.toString());
//                                   },
//                                 )
//                               : const SizedBox(),
//                         ],
//                       )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// //final Uri _url = Uri.parse('https://flutter.dev');
// Future<void> _launchUrl({required String url}) async {
//   if (!await launchUrl(Uri.parse(url))) {
//     throw 'Could not launch $url';
//   }
// }

// Future<void> launchPhoneDialer({required String contactNumber}) async {
//   final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
//   try {
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     }
//   } catch (error) {
//     throw ("Cannot dial");
//   }
// }
