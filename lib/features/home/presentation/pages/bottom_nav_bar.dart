import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/widgets/app_widgets/logo_widget.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../hr_home/presentation/pages/add_post_screen.dart';
import '../../../notifications/presentation/pages/notification_screen.dart';
import '../cubit/bottom_bar/bottom_bar_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> listIcon = [];
  @override
  void initState() {
    super.initState();
    final User user = context.read<LoginCubit>().user.body.user;
    listIcon = user.type == UserType.hr
        ? [
            jobIcon,
            homeIcon,
          ]
        : [
            messageIcon,
            jobIcon,
            homeIcon,
          ];
  }

  @override
  Widget build(BuildContext context) {
    final User user = context.watch<LoginCubit>().user.body.user;
    final bottomNavBar = context.watch<BottomBarCubit>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: GestureDetector(
                onTap: () {
                  sl<AppNavigator>().push(screen: const NotificationScreen());
                },
                child: SvgPicture.asset(
                  notification,
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                  color: user.type == UserType.hr ? accentColor : mainColor,
                )),
          )
        ],
        // leading: GestureDetector(
        //     onTap: () {
        //       scaffoldKey.currentState!.openDrawer();
        //     },
        //     child: Image.asset(more,
        //         color: user.type == UserType.hr ? accentColor : mainColor,
        //         width: 30))
      ),
      // drawer: DrawerWidget(user: user, scaffoldKey: scaffoldKey),
      backgroundColor: white,
      body: bottomNavBar.pageList[bottomNavBar.selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: user.type == UserType.hr
          ? SizedBox(
              height: 60.0,
              width: 60.0,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: white,
                onPressed: () {
                  sl<AppNavigator>().push(screen: const AddPostScreen());
                },
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                      color: Color(0xff2FD09A), shape: BoxShape.circle),
                  child: const Icon(
                    Icons.post_add_outlined,
                    size: 30,
                  ),
                ),
              ),
            )
          : null,
      bottomNavigationBar: Container(
          height: SizeConfig.blockSizeVertical * 10.5,
          width: double.infinity,
          color: user.type == UserType.hr
              ? const Color(0xff2A3942)
              : const Color(0xff3B576F),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                    listIcon.length,
                    (i) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SpaceV10BE(),
                            GestureDetector(
                              onTap: () {
                                bottomNavBar.changeBottomBar(i);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: bottomNavBar.selectedIndex != i
                                        ? Colors.transparent
                                        : user.type == UserType.hr
                                            ? const Color(0xff2FD09A)
                                            : textButtonColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Image.asset(
                                    listIcon[i],
                                  ),
                                ),
                              ),
                            ),
                            const SpaceV5BE(),
                            Container(
                              width: 7.5,
                              height: 7.5,
                              decoration: BoxDecoration(
                                color: bottomNavBar.selectedIndex != i
                                    ? Colors.transparent
                                    : user.type == UserType.hr
                                        ? const Color(0xff2FD09A)
                                        : textButtonColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          ],
                        )).toList(),
                Column(
                  children: [
                    const SpaceV10BE(),
                    GestureDetector(
                      onTap: () {
                        bottomNavBar.changeBottomBar(listIcon.length);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: bottomNavBar.selectedIndex !=
                                  (user.type == UserType.hr ? 2 : 3)
                              ? Colors.transparent
                              : user.type == UserType.hr
                                  ? const Color(0xff2FD09A)
                                  : textButtonColor,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: Image.network(
                            user.avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const LogoWidget(),
                          ),
                        ),
                      ),
                    ),
                    const SpaceV5BE(),
                    Container(
                      width: 7.5,
                      height: 7.5,
                      decoration: BoxDecoration(
                        color: bottomNavBar.selectedIndex != 3
                            ? Colors.transparent
                            : user.type == UserType.hr
                                ? const Color(0xff2FD09A)
                                : textButtonColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
              ])),
    );
  }
}
