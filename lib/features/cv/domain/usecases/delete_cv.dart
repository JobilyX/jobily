// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/cv_entity.dart';
import '../repositories/cv_repository.dart';

class DeleteCv extends UseCase<CvResponse, DeleteCvParams> {
  final CvRepository repository;

  DeleteCv({required this.repository});
  @override
  Future<Either<Failure, CvResponse>> call(DeleteCvParams params) async {
    return await repository.deleteCv(params: params);
  }
}

class DeleteCvParams {
  final String userId;
  DeleteCvParams({
    required this.userId,
  });
}
