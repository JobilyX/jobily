// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jobily/features/auth/domain/usecases/set_new_password.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/local/auth_local_datasource.dart';
import '../../domain/entities/delete_account_response.dart';
import '../../domain/entities/get_password_reset_response.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_code_reset_pass.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/reset_password.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final FirebaseMessaging firebaseMessaging;
  final FirebaseFirestore firebaseFirestore;
  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    required this.firebaseMessaging,
    required this.firebaseFirestore,
  });
  @override
  Future<Either<Failure, UserResponse>> login(
      {required LoginParams params}) async {
    try {
      // we need to this to use it with notifications
      params.deviceToken = await firebaseMessaging.getToken();
      final userData = await remote.login(params: params);
      await local.cacheUserData(user: userData);
      await local.cacheUserAccessToken(token: userData.body.accessToken);
      await local.cacheUserLoginInfo(
          params: LoginParams(password: params.password, email: params.email));
      return Right(userData);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: tr("error_no_internet")));
    }
  }

  @override
  Future<Either<Failure, RegisterResponse>> register(
      {required RegisterParams params}) async {
    try {
      final response = await remote.register(params: params);

      response.registerParams = params;
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserResponse>> autoLogin() async {
    try {
      final loginInfo = await local.getCacheUserLoginInfo();
      loginInfo.deviceToken = await firebaseMessaging.getToken();
      final userData = await remote.login(params: loginInfo);
      await local.cacheUserData(user: userData);
      await local.cacheUserAccessToken(token: userData.body.accessToken);
      return Right(userData);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return Left(ServerFailure(message: ""));
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: ""));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final token = local.getCacheUserAccessToken();

      await local.clearData();
      final fcmToken = await firebaseMessaging.getToken();

      await remote.logout(token: token, fcmToken: fcmToken!);
      return const Right("result");
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, GetPasswordResetCodeResponse>> resetPassword(
      {required ResetPasswordParams params}) async {
    try {
      final GetPasswordResetCodeResponse getPasswordResetCodeResponse =
          await remote.forgetPassword(params: params);
      return Right(getPasswordResetCodeResponse);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setNewPassword(
      {required SetNewPasswordParams params}) async {
    try {
      // final GetPasswordResetCodeResponse getPasswordResetCodeResponse =
      final res = await remote.setNewPassword(params: params);

      return Right(res);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> checkCodeToResetPass(
      {required OtpCodeParams params}) async {
    try {
      final String newToken =
          await remote.optCheckCodeForgetPass(params: params);
      return Right(newToken);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserResponse>> submitRegister({
    required RegisterResponse params,
  }) async {
    try {
      final response = await remote.submitRegister(params: params);
      await local.cacheUserLoginInfo(
          params: LoginParams(
              email: params.registerParams?.phone,
              password: params.registerParams?.password));
      await local.cacheUserAccessToken(token: response.body.accessToken);
      await local.cacheUserData(user: response);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({required params}) async {
    try {
      final token = local.getCacheUserAccessToken();
      final response =
          await remote.changePassword(params: params, token: token);

      final info = await local.getCacheUserLoginInfo();
      info.password = params.newPassword;
      await local.cacheUserLoginInfo(params: info);
      return Right(response);
    } on ServerException catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DeleteAccountResponse>> deleteAccount() async {
    try {
      final token = local.getCacheUserAccessToken();
      final response = await remote.deleteAccount(token: token);
      await local.clearData();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
