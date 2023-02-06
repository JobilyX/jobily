// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/cv_entity.dart';
import '../repositories/cv_repository.dart';

class GetCv extends UseCase<CvResponse, GetCvParams> {
  final CvRepository repository;

  GetCv({required this.repository});
  @override
  Future<Either<Failure, CvResponse>> call(GetCvParams params) async {
    return await repository.getCv(params: params);
  }
}

class GetCvParams {
  final String userId;
  GetCvParams({
    required this.userId,
  });
}
