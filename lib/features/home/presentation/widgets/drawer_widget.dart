import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/widgets/app_widgets/logo_widget.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../settings/domain/usecases/get_static_pages.dart';
import '../pages/static_screen.dart';
import 'rating_bar.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    Key? key,
    required this.user,
    required this.scaffoldKey,
  }) : super(key: key);

  final User user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final listText = [
    // tr("lang"),
    tr("contact"),
    tr("privacy"),
    tr("terms "),
    tr("complaint"),
    tr("share "),
    tr("rate"),
  ];

  final listIcon = [
    // lang,
    contact,
    privacy,
    terms,
    complaint,
    share,
    rate,
  ];

  List<void Function()> listFunc = [];
  @override
  void initState() {
    super.initState();
    listFunc = [
      () {
        sl<AppNavigator>().push(
            screen: const StaticPage(staticFilter: StaticFilter.ABOUT_US));
      },
      () {
        sl<AppNavigator>().push(
            screen: const StaticPage(
                staticFilter: StaticFilter.PRIVACY_AND_POLICIES));
      },
      () {
        sl<AppNavigator>().push(
            screen: const StaticPage(
                staticFilter: StaticFilter.TERMS_AND_CONDITIONS));
      },
      () {},
      () {},
      () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Rate us to be attractive!",
                          style: TextStyles.bodyText20),
                      const SpaceV10BE(),
                      ratingBar(startRate: 2),
                      const SpaceV10BE(),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Leave feedback here..",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginCubit>().user.body.user;
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(22),
          bottomEnd: Radius.circular(22),
        ),
        child: Drawer(
          child: Container(
            decoration: const BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(22),
                  bottomEnd: Radius.circular(22),
                )),
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 15),
              decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(22),
                    bottomEnd: Radius.circular(22),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpaceV20BE(),
                        GestureDetector(
                          onTap: () {
                            widget.scaffoldKey.currentState!.closeDrawer();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.all(16),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: const Color(0xff2FD09A).withOpacity(.3),
                                borderRadius:
                                    BorderRadiusDirectional.circular(4)),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              child: const Center(
                                  child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: darkTextColor,
                              )),
                            ),
                          ),
                        ),
                        const SpaceV10BE(),
                        Row(
                          children: [
                            const SpaceHBE(),
                            Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        onError: (exception, stackTrace) =>
                                            const LogoWidget(),
                                        image: NetworkImage(user.avatar),
                                        fit: BoxFit.cover))),
                            const SpaceHBE(),
                            Text("${user.firstname} ${user.lastname}",
                                style: TextStyles.bodyText16),
                          ],
                        ),
                        const SpaceV10BE(),
                        const Divider(color: divderColor, height: 2),
                        const SpaceV10BE(),
                        ...List.generate(
                            listText.length,
                            (i) => DrawerItem(
                                  text: listText[i],
                                  image: listIcon[i],
                                  function: listFunc[i],
                                  color: listDrawerColor[i],
                                )).toList(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      widget.scaffoldKey.currentState!.closeDrawer();
                    },
                    child: Stack(
                      children: [
                        Center(
                            child: ClipPath(
                                clipper: DrawerCilp(),
                                child: Container(
                                  height: 130,
                                  width: 30,
                                  color: mainColor,
                                ))),
                        Center(
                          child: SizedBox(
                            height: 40,
                            width: 25,
                            child: Text(
                              "|",
                              textAlign: TextAlign.end,
                              style:
                                  TextStyles.bodyText20.copyWith(color: greyBG),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.text,
    required this.image,
    required this.color,
    this.isRed = false,
    this.function,
  });
  final String text;
  final String image;
  final Color color;
  final bool isRed;
  final void Function()? function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: function,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: SizeConfig.blockSizeHorizontal * 70,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SpaceHBE(),
              Container(
                padding: const EdgeInsets.all(4),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(.7),
                    borderRadius: BorderRadiusDirectional.circular(4)),
                child: Center(
                  child: SvgPicture.asset(
                    image,
                    height: 25,
                    fit: BoxFit.fill,
                    color: isRed ? errorColor : null,
                  ),
                ),
              ),
              const SpaceHBE(),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyles.bodyText16
                    .copyWith(color: isRed ? errorColor : null),
              )
            ],
          ),
        ));
  }
}

class DrawerCilp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 23;
    final double yScaling = size.height / 110;
    path.lineTo(0 * xScaling, 50.009 * yScaling);
    path.cubicTo(
      0.00000917338 * xScaling,
      30 * yScaling,
      18.525 * xScaling,
      22.573 * yScaling,
      22.4946 * xScaling,
      1.99583 * yScaling,
    );
    path.cubicTo(
      26.4643 * xScaling,
      -18.5814 * yScaling,
      25.1411 * xScaling,
      127.173 * yScaling,
      22.4946 * xScaling,
      108.311 * yScaling,
    );
    path.cubicTo(
      19.8482 * xScaling,
      89.4485 * yScaling,
      -0.00000917337 * xScaling,
      70.018 * yScaling,
      0 * xScaling,
      50.009 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      50.009 * yScaling,
      0 * xScaling,
      50.009 * yScaling,
      0 * xScaling,
      50.009 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
