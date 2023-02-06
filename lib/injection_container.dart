import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local/fcm_remote_datasource.dart';
import 'core/util/api_basehelper.dart';
import 'core/util/navigator.dart';
import 'features/auth/auth_injection.dart';
import 'features/chat/chat_container.dart';
import 'features/cv/cv_injection.dart';
import 'features/home/home_injection.dart';
import 'features/hr_home/injection_container.dart';
import 'features/notifications/notifications_injection_contsiner.dart';
import 'features/settings/settings_injection.dart';

final sl = GetIt.instance;
final ApiBaseHelper helper = ApiBaseHelper();
Future<void> init() async {
  await initAuthInjection(sl);
  initSettingsInjection(sl);
  initChatInjection(sl);
  initNotificationInjection(sl);
  initCvInjection(sl);
  initHrHomeContainer(sl);
  initHomeContainer(sl);

  // core
  sl.registerLazySingleton<FCMRemoteDataSource>(
      () => FCMRemoteDataSourceImpl(helper: sl()));
  // sl.registerLazySingleton<AppLocation>(() => AppLocationImpl());
  sl.registerLazySingleton<AppNavigator>(() => AppNavigator());
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  sl.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
  final firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton(() => firebaseStorage);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  helper.dioInit();
  sl.registerLazySingleton(() => helper);
}
