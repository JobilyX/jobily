import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constant/colors/colors.dart';
import 'core/constant/size_config.dart';
import 'core/util/navigator.dart';
import 'core/widgets/toast.dart';
import 'features/auth/auth_injection.dart';
import 'features/auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/cv/cv_injection.dart';
import 'features/cv/presentation/cubit/cv_cubit.dart';
import 'features/home/home_injection.dart';
import 'features/home/presentation/cubit/bottom_bar/bottom_bar_cubit.dart';
import 'features/home/presentation/cubit/get_jobs/get_jobs_cubit.dart';
import 'features/home/presentation/pages/bottom_nav_bar.dart';
import 'features/hr_home/injection_container.dart';
import 'features/hr_home/presentation/cubit/get_skills/get_skills_cubit.dart';
import 'features/hr_home/presentation/cubit/job_posts/get_posts_cubit.dart';
import 'features/notifications/notifications_injection_contsiner.dart';
import 'features/settings/presentation/cubit/static_pages/cubit/static_content_cubit.dart';
import 'features/settings/presentation/pages/splash_screen.dart';
import 'features/settings/presentation/pages/which_one_screen.dart';
import 'features/settings/settings_injection.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomBarCubit>(create: (context) => BottomBarCubit()),
        BlocProvider<ChatCubit>(create: (context) => sl<ChatCubit>()),
        ...authBlocs(context),
        ...settingsBlocs(context),
        ...notificationsBlocs(context),
        ...cvBlocs(context),
        ...hrBlocs(context),
        ...homeBlocs(context),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: sl<AppNavigator>().navigatorKey,
        title: 'Jobily',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: white,
                elevation: 0,
                iconTheme: IconThemeData(color: accentColor))),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: WillPopScope(
          onWillPop: () {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) {
              currentBackPressTime = now;
              showToast(
                tr('click_again_to_exit'),
              );
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: const NotificationsHandler(),
        ),
      ),
    );
  }
}

class NotificationsHandler extends StatefulWidget {
  const NotificationsHandler({super.key});

  @override
  State<NotificationsHandler> createState() => _NotificationsHandlerState();
}

class _NotificationsHandlerState extends State<NotificationsHandler> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var initialzationSettingsAndroid =
          const AndroidInitializationSettings('logo');
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initialzationSettingsAndroid,
          iOS: initializationSettingsIOS);
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                priority: Priority.max,
                enableLights: true,
                playSound: true,
              ),
            ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const JobilyApp();
  }
}

class JobilyApp extends StatefulWidget {
  const JobilyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<JobilyApp> createState() => _JobilyAppState();
}

class _JobilyAppState extends State<JobilyApp> {
  @override
  void initState() {
    super.initState();
    context.read<StaticContentCubit>().fGetStaticPages();
    context.read<AutoLoginCubit>().fAutoLogin(context: context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ScreenUtil.init(context);
    return BlocConsumer<AutoLoginCubit, AutoLoginState>(
      listener: (context, state) async {
        if (state is AutoLoginHasUser) {
          context.read<CvCubit>().reset();
          context
              .read<BottomBarCubit>()
              .initPages(type: state.user.body.user.type);
          if (state.user.body.user.type == UserType.job_seeker) {
            await context
                .read<CvCubit>()
                .fGetCv(userId: state.user.body.user.id.toString());
            sl<GetMyJobsCubit>().fGetMyJobs();
          } else {
            sl<GetSkillsCubit>().fGetSkills();
            sl<GetPostsCubit>().fGetPosts();
          }
        }
      },
      builder: (context, state) {
        if (state is AutoLoginNoUser) {
          return const WhichOneScreen();
        } else if (state is AutoLoginSeenIntro) {
          return const LoginScreen();
        } else if (state is AutoLoginHasUser) {
          return const MainScreen();
        }
        return const SplashScreen();
      },
    );
  }
}
