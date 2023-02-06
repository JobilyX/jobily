import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../injection_container.dart';
import 'data/datasources/settings_remote_datasource.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/change_app_language.dart';
import 'domain/usecases/complaint_and_suggestion.dart';
import 'domain/usecases/connect_us.dart';
import 'domain/usecases/get_complaint_types.dart';
import 'domain/usecases/get_social_media_links_usecase.dart';
import 'domain/usecases/get_static_pages.dart';
import 'presentation/cubit/change_app/cubit/change_app_cubit.dart';
import 'presentation/cubit/connect_us/connect_us_cubit.dart';
import 'presentation/cubit/static_pages/cubit/static_content_cubit.dart';

Future<void> initSettingsInjection(GetIt sl) async {
  //* provider
  sl.registerFactory(
    () => ConnectUsCubit(
        connectUs: sl(), getComplaintTypes: sl(), complaintAndSuggestion: sl()),
  );
  sl.registerFactory(
    () => ChangeApplanguageCubit(changeAppLanguage: sl()),
  );
  sl.registerFactory(
    () => StaticContentCubit(
      getStaticPages: sl(),
      getSocialMediaLinks: sl(),
    ),
  );

  //* Use cases
  sl.registerLazySingleton(() => ConnectUs(repository: sl()));
  sl.registerLazySingleton(() => GetStaticPages(repository: sl()));
  sl.registerLazySingleton(() => ChangeAppLanguage(repository: sl()));
  sl.registerLazySingleton(() => GetComplaintTypes(repository: sl()));
  sl.registerLazySingleton(() => ComplaintAndSuggestion(repository: sl()));
  sl.registerLazySingleton(() => GetSocialMediaLinksUsecase(repository: sl()));
  //* Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remote: sl(),
    ),
  );

  //* Data sources
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(
      helper: sl(),
    ),
  );
}

List<BlocProvider> settingsBlocs(BuildContext context) => [
      BlocProvider<ConnectUsCubit>(
        create: (BuildContext context) => sl<ConnectUsCubit>()..fGetComplaint(),
      ),
      BlocProvider<ChangeApplanguageCubit>(
        create: (BuildContext context) => sl<ChangeApplanguageCubit>(),
      ),
      BlocProvider<StaticContentCubit>(
          create: (BuildContext context) => sl<StaticContentCubit>()),
    ];
