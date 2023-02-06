import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../injection_container.dart';
import 'data/datasources/notifications_datasource.dart';
import 'data/repositories/notifications_repository_impl.dart';
import 'domain/repositories/notifications_repository.dart';
import 'domain/usecases/notfifcation_usecase.dart';
import 'domain/usecases/reed_all_notifications_usecase.dart';
import 'presentation/cubit/get_notifications_cubit/notifications_cubit.dart';
import 'presentation/cubit/read_all_notifications_cubit/read_all_notifications_cubit.dart';

Future<void> initNotificationInjection(GetIt sl) async {
  //* cubit
  sl.registerFactory(
    () => NotificationsCubit(getNotificationsUsecase: sl()),
  );
  sl.registerFactory(
      () => ReadAllNotificationsCubit(readAllNotificationUsecase: sl()));

  //* Use cases
  sl.registerLazySingleton(() => GetNotificationsUsecase(repository: sl()));
  sl.registerLazySingleton(() => ReadAllNotificationsUsecase(repository: sl()));

  //* Repository
  sl.registerLazySingleton<NotificationsRepositories>(
    () => NotificationsRepositoryImpl(remote: sl(), authLocal: sl()),
  );

  //* Data sources
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(helper: sl()),
  );
}

List<BlocProvider> notificationsBlocs(BuildContext context) => [
      BlocProvider<NotificationsCubit>(
        create: (BuildContext context) => sl<NotificationsCubit>(),
      ),
      BlocProvider<ReadAllNotificationsCubit>(
        create: (BuildContext context) => sl<ReadAllNotificationsCubit>(),
      ),
    ];
