import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import '../../../../hr_home/presentation/pages/hr_home_screen.dart';
import '../../../../hr_home/presentation/pages/hr_profile_screen.dart';
import '../../pages/home_screen.dart';
import '../../pages/messages_screen.dart';
import '../../pages/my_jobs_screen.dart';
import '../../pages/profile_screen.dart';
import 'bottom_bar_states.dart';

class BottomBarCubit extends Cubit<BottomBarStates> {
  BottomBarCubit() : super(BottomBarInitState());

  static BottomBarCubit get(BuildContext context) => BlocProvider.of(context);

  int selectedIndex = 0;
  List<Widget> pageList = [];
  initPages({required UserType type}) {
    if (type == UserType.hr) {
      pageList = pageListHr;
    } else {
      pageList = pageListJobSeeker;
    }
  }

  List<Widget> pageListJobSeeker = [
    const HomeScreen(),
    const MyJobsScreen(),
    const MesagesScreen(),
    const ProfileScreen(),
  ];

  List<Widget> pageListHr = [
    const HrHomeScreen(),
    const MesagesScreen(),
    const HrProfileScreen(),
  ];

  void changeBottomBar(index) {
    selectedIndex = index;
    emit(ChangeBottomBarState());
  }

  void persistBottomBar(index) {
    selectedIndex = index;
    emit(ChangeBottomBarState());
    // Get.to(() => const MainScreen());
  }
}
