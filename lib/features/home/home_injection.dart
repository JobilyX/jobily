import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../injection_container.dart';
import 'data/datasources/home_remote_datasource.dart';
import 'data/repositories/home_repositroy_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_jobs_fillter.dart';
import 'domain/usecases/get_my_jobs.dart';
import 'domain/usecases/job_apply.dart';
import 'presentation/cubit/get_jobs/get_jobs_cubit.dart';
import 'presentation/cubit/get_jobs_fillter/get_jobs_fillter_cubit.dart';
import 'presentation/cubit/job_apply/job_apply_cubit.dart';

Future<void> initHomeContainer(GetIt sl) async {
  //* cubit
  sl.registerFactory(
    () => JobApplyCubit(jobApply: sl()),
  );
  sl.registerLazySingleton(
    () => GetMyJobsCubit(getMyJobs: sl()),
  );
  sl.registerLazySingleton(
    () => GetJobsFillterCubit(getJobsFillter: sl()),
  );
  // //* Use cases

  sl.registerLazySingleton(() => GetMyJobs(repository: sl()));
  sl.registerLazySingleton(() => JobApply(repository: sl()));
  sl.registerLazySingleton(() => GetJobsFillter(repository: sl()));

  // //* Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remote: sl(), authLocal: sl()),
  );

  // //* Data sources
  sl.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDataSourceImpl(helper: sl()),
  );
}

List<BlocProvider> homeBlocs(BuildContext context) => [
      BlocProvider<JobApplyCubit>(
        create: (BuildContext context) => sl<JobApplyCubit>(),
      ),
      BlocProvider<GetMyJobsCubit>(
        create: (BuildContext context) => sl<GetMyJobsCubit>(),
      ),
      BlocProvider<GetJobsFillterCubit>(
        create: (BuildContext context) => sl<GetJobsFillterCubit>(),
      ),
    ];
