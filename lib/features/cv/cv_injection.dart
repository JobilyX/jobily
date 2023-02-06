import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../injection_container.dart';
import 'data/datasource/cv_remote_datesource.dart';
import 'data/repository/cv_repository_impl.dart';
import 'domain/repositories/cv_repository.dart';
import 'domain/usecases/create_cv.dart';
import 'domain/usecases/create_cv_with_file.dart';
import 'domain/usecases/delete_cv.dart';
import 'domain/usecases/get_cv.dart';
import 'presentation/cubit/cv_cubit.dart';

Future<void> initCvInjection(GetIt sl) async {
  //* cubit
  sl.registerLazySingleton(
    () => CvCubit(
      createCv: sl(),
      createCvWithFile: sl(),
      getCv: sl(),
      deleteCv: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => CreateCv(repository: sl()));
  sl.registerLazySingleton(() => CreateCvWithFile(repository: sl()));
  sl.registerLazySingleton(() => GetCv(repository: sl()));
  sl.registerLazySingleton(() => DeleteCv(repository: sl()));

  //* Repository
  sl.registerLazySingleton<CvRepository>(
    () => CvRepositoryImpl(remote: sl(), authLocal: sl()),
  );

  //* Data sources
  sl.registerLazySingleton<CvRemoteDataSource>(
    () => CvRemoteDataSourceImpl(helper: sl()),
  );
}

List<BlocProvider> cvBlocs(BuildContext context) => [
      BlocProvider<CvCubit>(
        create: (BuildContext context) => sl<CvCubit>(),
      ),
    ];
