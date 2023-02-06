import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/jobs_repsonse.dart';
import '../repositories/post_repository.dart';

class AddJobPost extends UseCase<JobsResponse, AddJobPostParams> {
  final PostRepository repository;
  AddJobPost({
    required this.repository,
  });
  @override
  Future<Either<Failure, JobsResponse>> call(AddJobPostParams params) async {
    return await repository.addPost(params: params);
  }
}

class AddJobPostParams {
  final Map<String, dynamic> map;
  final bool isEdit;
  final int? postId;
  AddJobPostParams({
    required this.map,
    required this.isEdit,
    this.postId,
  });
}
