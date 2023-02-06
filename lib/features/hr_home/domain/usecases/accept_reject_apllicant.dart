import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/post_repository.dart';

class AcceptRejectApplicants
    extends UseCase<Unit, AcceptRejectApplicantsParams> {
  final PostRepository repository;

  AcceptRejectApplicants({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(
      AcceptRejectApplicantsParams params) async {
    return await repository.acceptRejectApplicants(params: params);
  }
}

enum ApplicantStatus { pending, accepted, refused }

class AcceptRejectApplicantsParams {
  final ApplicantStatus status;
  final int postId;
  final int seekrId;
  final String companyName;
  final String fcmToken;
  AcceptRejectApplicantsParams({
    required this.status,
    required this.postId,
    required this.seekrId,
    required this.companyName,
    required this.fcmToken,
  });
}
