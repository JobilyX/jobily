import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/cv_entity.dart';
import '../entities/cv_file_response.dart';
import '../usecases/create_cv.dart';
import '../usecases/create_cv_with_file.dart';
import '../usecases/delete_cv.dart';
import '../usecases/get_cv.dart';

abstract class CvRepository {
  Future<Either<Failure, CvResponse>> createCv(
      {required CreateCvParams params});
  Future<Either<Failure, CvResponse>> getCv({required GetCvParams params});
  Future<Either<Failure, CvResponse>> deleteCv(
      {required DeleteCvParams params});
  Future<Either<Failure, CvFileResponse>> createCvWithFile(
      {required CreateCvWithFileParams params});
}
