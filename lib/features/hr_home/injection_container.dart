import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'domain/usecases/accept_reject_apllicant.dart';
import 'presentation/cubit/accept_applicents/accept_applicents_cubit.dart';

import '../../injection_container.dart';
import 'data/datasources/post_remote_datesource.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/add_job_post.dart';
import 'domain/usecases/delete_job.dart';
import 'domain/usecases/get_job_byid.dart';
import 'domain/usecases/get_jobs.dart';
import 'domain/usecases/get_skills.dart';
import 'presentation/cubit/add_post/add_post_cubit.dart';
import 'presentation/cubit/get_post/get_post_by_id_cubit.dart';
import 'presentation/cubit/get_skills/get_skills_cubit.dart';
import 'presentation/cubit/job_posts/get_posts_cubit.dart';

Future<void> initHrHomeContainer(GetIt sl) async {
  //* cubit
  sl.registerFactory(
    () => AcceptApplicentsCubit(acceptRejectApplicants: sl()),
  );
  sl.registerFactory(
    () => AddPostCubit(addPost: sl()),
  );
  sl.registerFactory(
    () => GetPostByIdCubit(getJobPostById: sl()),
  );
  sl.registerLazySingleton(
    () => GetPostsCubit(
        getJobPosts: sl(), deleteJobPost: sl(), getJobPostById: sl()),
  );
  sl.registerLazySingleton(
    () => GetSkillsCubit(getSkills: sl()),
  );
  // //* Use cases
  sl.registerLazySingleton(() => AcceptRejectApplicants(repository: sl()));
  sl.registerLazySingleton(() => GetJobPosts(repository: sl()));
  sl.registerLazySingleton(() => GetJobPostById(repository: sl()));
  sl.registerLazySingleton(() => DeleteJobPost(repository: sl()));
  sl.registerLazySingleton(() => AddJobPost(repository: sl()));
  sl.registerLazySingleton(() => GetSkills(repository: sl()));

  // //* Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remote: sl(), authLocal: sl()),
  );

  // //* Data sources
  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(helper: sl()),
  );
}

List<BlocProvider> hrBlocs(BuildContext context) => [
      BlocProvider<AcceptApplicentsCubit>(
        create: (BuildContext context) => sl<AcceptApplicentsCubit>(),
      ),
      BlocProvider<AddPostCubit>(
        create: (BuildContext context) => sl<AddPostCubit>(),
      ),
      BlocProvider<GetPostByIdCubit>(
        create: (BuildContext context) => sl<GetPostByIdCubit>(),
      ),
      BlocProvider<GetPostsCubit>(
        create: (BuildContext context) => sl<GetPostsCubit>(),
      ),
      BlocProvider<GetSkillsCubit>(
        create: (BuildContext context) => sl<GetSkillsCubit>(),
      ),
    ];
