// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/cv_file_response.dart';
import '../repositories/cv_repository.dart';

class CreateCvWithFile extends UseCase<CvFileResponse, CreateCvWithFileParams> {
  final CvRepository repository;

  CreateCvWithFile({required this.repository});
  @override
  Future<Either<Failure, CvFileResponse>> call(
      CreateCvWithFileParams params) async {
    return await repository.createCvWithFile(params: params);
  }
}

class CreateCvWithFileParams {
  final PlatformFile file;
  final void Function(int, int)? onSendProgress;
  CreateCvWithFileParams({required this.file, required this.onSendProgress});
}
