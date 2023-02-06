import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../../../../core/usecases/usecases.dart';
import '../repositories/settings_repository.dart';

class ComplaintAndSuggestion
    extends UseCase<Unit, ComplaintAndSuggestionParams> {
  final SettingsRepository repository;

  ComplaintAndSuggestion({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(
      ComplaintAndSuggestionParams params) async {
    return await repository.complaintAndSuggestion(params: params);
  }
}

class ComplaintAndSuggestionParams {
  final String email;
  final String name;
  final String message;
  // final String phone;
  final int complaintTypeId;

  ComplaintAndSuggestionParams({
    required this.email,
    required this.name,
    required this.message,
    // required this.phone,
    required this.complaintTypeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'message': message,
      "type": "complaint",
      // 'phone': phone,
      'complaint_type_id': complaintTypeId,
    };
  }
}
