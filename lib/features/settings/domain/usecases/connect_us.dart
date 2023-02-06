// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';

import 'package:jobily/core/error/failures.dart';

import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class ConnectUs extends UseCase<Unit, ConnectUsParams> {
  final SettingsRepository repository;

  ConnectUs({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(ConnectUsParams params) async {
    return await repository.connectUs(params: params);
  }
}

class ConnectUsParams {
  final String email;
  final String name;
  final String message;
  final String phone;

  ConnectUsParams({
    required this.email,
    required this.name,
    required this.message,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'message': message,
      'type': "contact",
      'phone': phone,
    };
  }
}
