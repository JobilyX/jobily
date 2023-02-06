import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/api_basehelper.dart';
import '../../domain/entities/delete_account_response.dart';
import '../../domain/entities/get_password_reset_response.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/check_code_reset_pass.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/set_new_password.dart';

const registerApi = "/auth/register/send/code";
const submitRegisterApi = "/auth/register/submit";
const loginApi = "/auth/login/submit";
const getUserInfoApi = "/auth/profile/";
const deleteAccountApi = '/auth/delete-account';
const logoutApi = "/auth/logout";
const getPasswordResetCode = '/auth/forgot-password/send/code';
const privacyPolicyApi = '/privacy/';
const otpCheckCodeApi = '/auth/forgot-password/check';
const setNewPasswordApi = '/auth/forgot-password/set-new-password';
const changePasswordApi = '/my-account-profile/edit-password';

abstract class AuthRemoteDataSource {
  Future<UserResponse> login({required LoginParams params});
  Future<RegisterResponse> register({required RegisterParams params});
  Future<UserResponse> submitRegister({required RegisterResponse params});
  Future<GetPasswordResetCodeResponse> forgetPassword(
      {required ResetPasswordParams params});
  Future<void> setNewPassword({required SetNewPasswordParams params});
  Future<String> optCheckCodeForgetPass({required OtpCodeParams params});
  Future<String> logout({required String token, required String fcmToken});
  Future<String> changePassword(
      {required ChangePasswordParams params, required String token});

  Future<DeleteAccountResponse> deleteAccount({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiBaseHelper helper;

  AuthRemoteDataSourceImpl({
    required this.helper,
  });

  @override
  Future<UserResponse> login({
    required LoginParams params,
  }) async {
    try {
      final response = await helper.post(
        url: loginApi, //Api url
        body: {
          "email": params.email!.trim(),
          "password": params.password!.trim(),
          "device_token": params.deviceToken
        },
      ) as Map<String, dynamic>;
      return UserResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<GetPasswordResetCodeResponse> forgetPassword(
      {required ResetPasswordParams params}) async {
    try {
      final response = await helper.post(
        url: getPasswordResetCode,
        body: {"email": params.email!.trim()},
      );
      GetPasswordResetCodeResponse getPasswordResetCodeResponse =
          GetPasswordResetCodeResponse.fromMap(response);
      return getPasswordResetCodeResponse;
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<RegisterResponse> register({required RegisterParams params}) async {
    try {
      final response = await helper.post(url: registerApi, body: {
        "firstname": params.first.trim(),
        "lastname": params.last.trim(),
        "phone": params.phone,
        "email": params.email.trim(),
        "date_of_birth": params.date.trim(),
        "password": params.password.trim(),
        "password_confirmation": params.passwordConfirmation,
        "accept_terms_conditions": params.acceptTermsConditions,
        "gender": params.gender,
        "type": params.type
      });

      return RegisterResponse.fromJson(response["body"]);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<UserResponse> submitRegister(
      {required RegisterResponse params}) async {
    try {
      log(params.code);
      final response = await helper.post(
          url: "$submitRegisterApi?code=${params.code}",
          body: params.request.toMap());
      if (response["status"]) {
        return UserResponse.fromJson(response);
      } else {
        throw ServerException(message: response["message"]);
      }
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> optCheckCodeForgetPass({required OtpCodeParams params}) async {
    try {
      final response = await helper.post(
        url: "$otpCheckCodeApi?code=${params.code!.trim()}",
        body: {"email": params.email!.trim()},
      );
      return response["body"]["access_token_reset_password"];
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> setNewPassword({required SetNewPasswordParams params}) async {
    try {
      await helper.post(
          url: setNewPasswordApi,
          body: {
            "password": params.newPassword!.trim(),
            "password_confirmation": params.confirmPassword!.trim()
          },
          token: params.token);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> logout(
      {required String token, required String fcmToken}) async {
    try {
      final response = await helper.get(
          url: "$logoutApi?fcm_device_token=$fcmToken", token: token);
      if (response["status"]) {
        return response["message"];
      } else {
        throw ServerException(message: response["message"]);
      }
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> changePassword(
      {required ChangePasswordParams params, required String token}) async {
    try {
      final response =
          await helper.post(token: token, url: changePasswordApi, body: {
        "current_password": params.currentPassword.trim(),
        "new_password": params.newPassword.trim(),
        "new_password_confirmation": params.confirmNewPassword.trim()
      });
      if (response["status"]) {
        return response["message"];
      } else {
        throw ServerException(message: response["message"]);
      }
    } catch (e) {
      log(e.toString());
      log(e.toString());
      String message = tr("error_please_try_again");
      if (e is ServerException) {
        message = e.message;
      }
      throw ServerException(message: message);
    }
  }

  @override
  Future<DeleteAccountResponse> deleteAccount({required String token}) async {
    try {
      final response = await helper.get(url: deleteAccountApi, token: token);
      if (response["status"]) {
        return DeleteAccountResponse.fromJson(response);
      } else {
        throw ServerException(message: response["message"]);
      }
    } catch (e) {
      final String message = tr("error_please_try_again");
      if (e is ServerException) {
        throw ServerException(message: e.message);
      } else {
        throw ServerException(message: message);
      }
    }
  }
}
