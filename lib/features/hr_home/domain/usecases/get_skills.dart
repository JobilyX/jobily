import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/Skills_response.dart';
import '../repositories/post_repository.dart';

class GetSkills extends UseCase<SkillsResponse, NoParams> {
  final PostRepository repository;

  GetSkills({required this.repository});
  @override
  Future<Either<Failure, SkillsResponse>> call(NoParams params) async {
    return await repository.getSkills();
  }
}
