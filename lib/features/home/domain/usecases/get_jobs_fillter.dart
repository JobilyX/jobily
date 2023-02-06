import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/jobs_fillter_response.dart';
import '../repositories/home_repository.dart';

class GetJobsFillter
    extends UseCase<GetJobsFillterResponse, GetJobsFillterParams> {
  final HomeRepository repository;
  GetJobsFillter({
    required this.repository,
  });
  @override
  Future<Either<Failure, GetJobsFillterResponse>> call(
      GetJobsFillterParams params) async {
    return await repository.getJobsFillter(params: params);
  }
}

class GetJobsFillterParams {
  final Map<String, dynamic> map;
  GetJobsFillterParams({
    required this.map,
  });
  @override
  String toString() {
    String str = "";
    map.removeWhere((key, value) => value is String && (value).isEmpty);
    if (map.isNotEmpty) {
      map.forEach((key, value) {
        str += "&$key=$value";
      });
    }
    return str;
  }
}
