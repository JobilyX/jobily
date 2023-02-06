// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/cv_entity.dart';
import '../repositories/cv_repository.dart';

class CreateCv extends UseCase<CvResponse, CreateCvParams> {
  final CvRepository repository;

  CreateCv({required this.repository});
  @override
  Future<Either<Failure, CvResponse>> call(CreateCvParams params) async {
    return await repository.createCv(params: params);
  }
}

class CreateCvParams {
  final Map<String, dynamic> map;
  CreateCvParams({
    required this.map,
  });
}
