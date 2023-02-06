import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/delete_account_response.dart';
import '../entities/get_password_reset_response.dart';
import '../entities/register_response.dart';
import '../entities/user.dart';
import '../usecases/change_password.dart';
import '../usecases/check_code_reset_pass.dart';
import '../usecases/login.dart';
import '../usecases/register.dart';
import '../usecases/reset_password.dart';
import '../usecases/set_new_password.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserResponse>> login({required LoginParams params});

  Future<Either<Failure, RegisterResponse>> register(
      {required RegisterParams params});

  Future<Either<Failure, UserResponse>> autoLogin();

  Future<Either<Failure, GetPasswordResetCodeResponse>> resetPassword(
      {required ResetPasswordParams params});
  Future<Either<Failure, void>> setNewPassword(
      {required SetNewPasswordParams params});

  Future<Either<Failure, String>> logout();

  Future<Either<Failure, String>> checkCodeToResetPass(
      {required OtpCodeParams params});

  Future<Either<Failure, UserResponse>> submitRegister(
      {required RegisterResponse params});

  Future<Either<Failure, String>> changePassword(
      {required ChangePasswordParams params});

  Future<Either<Failure, DeleteAccountResponse>> deleteAccount();
}
