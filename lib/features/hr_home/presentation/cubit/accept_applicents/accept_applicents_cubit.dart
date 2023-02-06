import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../injection_container.dart';
import '../../../../chat/domain/entities/chat_user.dart';
import '../../../../chat/domain/usecases/set_chatting_Id_for_users.dart';
import '../../../../chat/presentation/cubit/chat_cubit.dart';
import '../../../domain/usecases/accept_reject_apllicant.dart';

part 'accept_applicents_state.dart';

class AcceptApplicentsCubit extends Cubit<AcceptApplicentsState> {
  AcceptApplicentsCubit({
    required this.acceptRejectApplicants,
  }) : super(AcceptApplicentsInitial());
  final AcceptRejectApplicants acceptRejectApplicants;
  Future<void> facceptRejectApplicants(
      {required ApplicantStatus status,
      required int postId,
      required int seekrId,
      required ChatUser user1,
      required ChatUser user2,
      required Function afterSuccess}) async {
    emit(AcceptApplicentsLoading());
    final failOrRes = await acceptRejectApplicants(AcceptRejectApplicantsParams(
        companyName: user1.username,
        fcmToken: user2.fcmToken ?? "",
        status: status,
        postId: postId,
        seekrId: seekrId));
    failOrRes.fold((l) {
      if (l is ServerFailure) {
        emit(AcceptApplicentsError(message: l.message));
      }
    }, (r) {
      if (status == ApplicantStatus.accepted) {
        sl<ChatCubit>().fSetChattingIdForUsers(
            params: SetChattingIdForUsersParams(
                user1: user1,
                user2: user2,
                userId1: user1.id,
                userId2: user2.id),
            scaffoldKey: null);
      }
      afterSuccess();
      emit(AcceptApplicentsSuccess());
    });
  }
}
