import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/local/auth_local_datasource.dart';
import '../../injection_container.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/auto_login.dart';
import 'domain/usecases/change_password.dart';
import 'domain/usecases/check_code_reset_pass.dart';
import 'domain/usecases/delete_account.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/logout.dart';
import 'domain/usecases/register.dart';
import 'domain/usecases/reset_password.dart';
import 'domain/usecases/set_new_password.dart';
import 'domain/usecases/submit_register.dart';
import 'presentation/cubit/auto_login/auto_login_cubit.dart';
import 'presentation/cubit/change_password/change_password_cubit.dart';
import 'presentation/cubit/delete_account/delete_account_cubit.dart';
import 'presentation/cubit/forget_password/cubit/forget_password_cubit.dart';
import 'presentation/cubit/login_cubit/login_cubit.dart';
import 'presentation/cubit/logout/logout_cubit.dart';
import 'presentation/cubit/otp_cubit/otp_cubit.dart';
import 'presentation/cubit/register/register_cubit.dart';
import 'presentation/cubit/register_submit/regitser_submit_cubit.dart';
import 'presentation/cubit/set_new_password/cubit/set_new_password_cubit.dart';

Future<void> initAuthInjection(GetIt sl) async {
  //* provider

  sl.registerLazySingleton(() => AutoLoginCubit(autoLogin: sl()));
  sl.registerLazySingleton(() => LoginCubit(login: sl()));
  sl.registerLazySingleton(() => LogoutCubit(logout: sl()));
  sl.registerFactory(() => RegisterCubit(
        register: sl(),
        // appLocation: sl(),
        submitRegister: sl(),
      ));

  sl.registerFactory(() => RegisterSubmitCubit(submitRegister: sl()));
  sl.registerFactory(() => ForgetPasswordCubit(resetPassword: sl()));
  sl.registerFactory(() => OtpCubit(otpCheckCode: sl()));
  sl.registerFactory(() => SetNewPasswordCubit(setNewPassword: sl()));
  sl.registerFactory(() => ChangePasswordCubit(changePasswordUseCase: sl()));
  sl.registerFactory(() => DeleteAccountCubit(deleteAccount: sl()));
  //* Use cases
  sl.registerLazySingleton(() => Register(repository: sl()));
  sl.registerLazySingleton(() => SubmitRegister(repository: sl()));
  sl.registerLazySingleton(() => Login(repository: sl()));
  sl.registerLazySingleton(() => ResetPassword(repository: sl()));
  sl.registerLazySingleton(() => OtpCheckCode(repository: sl()));
  sl.registerLazySingleton(() => AutoLogin(repository: sl()));
  sl.registerLazySingleton(() => SetNewPassword(repository: sl()));
  sl.registerLazySingleton(() => Logout(repository: sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAccount(repository: sl()));
  //* Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        remote: sl(),
        local: sl(),
        firebaseMessaging: sl(),
        firebaseFirestore: sl()),
  );

  //* Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      helper: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreference: sl(),
    ),
  );
}

List<BlocProvider> authBlocs(BuildContext context) => [
      BlocProvider<AutoLoginCubit>(
        create: (BuildContext context) => sl<AutoLoginCubit>(),
      ),
      BlocProvider<RegisterCubit>(
        create: (BuildContext context) => sl<RegisterCubit>(),
      ),
      BlocProvider<RegisterSubmitCubit>(
        create: (BuildContext context) => sl<RegisterSubmitCubit>(),
      ),
      BlocProvider<LoginCubit>(
        create: (BuildContext context) => sl<LoginCubit>(),
      ),
      BlocProvider<ForgetPasswordCubit>(
        create: (BuildContext context) => sl<ForgetPasswordCubit>(),
      ),
      BlocProvider<OtpCubit>(
        create: (BuildContext context) => sl<OtpCubit>(),
      ),
      BlocProvider<SetNewPasswordCubit>(
        create: (BuildContext context) => sl<SetNewPasswordCubit>(),
      ),
      BlocProvider<LogoutCubit>(
        create: (BuildContext context) => sl<LogoutCubit>(),
      ),
      BlocProvider<ChangePasswordCubit>(
        create: (BuildContext context) => sl<ChangePasswordCubit>(),
      ),
      BlocProvider<DeleteAccountCubit>(
        create: (BuildContext context) => sl<DeleteAccountCubit>(),
      ),
    ];
