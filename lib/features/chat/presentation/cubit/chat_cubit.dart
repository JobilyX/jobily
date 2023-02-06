import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_over_view.dart';
import '../../domain/entities/uploade_image_response.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/get_new_messages.dart';
import '../../domain/usecases/mark_peer_messages_as_read.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/set_chatting_Id_for_users.dart';
import '../../domain/usecases/uplaod_Image_to_server.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SetChattingIdForUsers setChattingIdForUsers;
  final SendMessage sendMessage;
  final GetAllMessages getAllMessages;
  final UplaodImageToServer uplaodImageToServer;
  final MarkPeerMessagesAsRead markPeerMessagesAsRead;
  final GetNewMessagesCount getNewMessagesCount;
  ChatCubit({
    required this.getNewMessagesCount,
    required this.setChattingIdForUsers,
    required this.markPeerMessagesAsRead,
    required this.sendMessage,
    required this.getAllMessages,
    required this.uplaodImageToServer,
  }) : super(ChatInitial());
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  Stream<List<Message>> fgetAllMessages({required String chatGroupId}) {
    return getAllMessages(GetAllMessagesParams(chatGroupId: chatGroupId));
  }

  Future<void> fSetChattingIdForUsers(
      {required SetChattingIdForUsersParams params,
      required scaffoldKey}) async {
    final failOrUnit = await setChattingIdForUsers(params);
    failOrUnit.fold(
        (fail) => {
              if (fail is FirebaseFailure)
                showToast(fail.message, bG: errorColor),
            },
        (r) => {});
  }

  Future<void> fsendMessage(
      {required SendMessageParams params, required scaffoldKey}) async {
    params.message.replayMessage = _replayMessage;
    final failOrUnit = await sendMessage(params);
    failOrUnit.fold(
        (fail) => {
              if (fail is FirebaseFailure)
                ScaffoldMessenger.of(scaffoldKey.currentState!.context)
                    .showSnackBar(SnackBar(
                  content: Text(fail.message),
                ))
            },
        (r) => {});
    cancelReplay();
  }

  Future<UploadedImage?> fuplaodImageToServer(
      {required UplaodImageToServerParams params, required scaffoldKey}) async {
    toggleIsSendingImage();
    UploadedImage? uploadedImage;
    final failOrUploadedImage = await uplaodImageToServer(params);
    failOrUploadedImage.fold((fail) {
      if (fail is FirebaseFailure) {
        ScaffoldMessenger.of(scaffoldKey.currentState!.context)
            .showSnackBar(SnackBar(content: Text(fail.message)));
      }
      toggleIsSendingImage();
      return null;
    }, (uI) {
      toggleIsSendingImage();
      uploadedImage = uI;
    });
    return uploadedImage!;
  }

  Future<void> fmarkPeerMessagesAsRead(
      {required MarkPeerMessagesAsReadParams params,
      required scaffoldKey}) async {
    final failOrUnit = await markPeerMessagesAsRead(params);
    failOrUnit.fold((fail) {
      if (fail is FirebaseFailure) {
        ScaffoldMessenger.of(scaffoldKey.currentState!.context)
            .showSnackBar(SnackBar(content: Text(fail.message)));
      }
    }, (unit) {});
  }

  Future<MessageOverView> fgetNewMessagesCount(
      GetNewMessagesCountParams params) async {
    late MessageOverView messageOverView;
    final failOrCount = await getNewMessagesCount(params);
    failOrCount.fold((fail) {}, (newCount) {
      messageOverView = newCount;
    });
    return messageOverView;
  }

  bool isSendingImages = false;
  toggleIsSendingImage() {
    emit(ChatInitial());
    isSendingImages = !isSendingImages;
    emit(ChatToggleSending());
  }

  Message? _replayMessage;
  Message? get replayMessage => _replayMessage;
  void replayToMessage(Message message) {
    emit(ChatInitial());
    _replayMessage = message;
    focusNode.requestFocus();

    emit(ChatToggleSending());
  }

  void cancelReplay() {
    _replayMessage = null;

    emit(ChatInitial());
    emit(ChatToggleSending());
  }
  // final ScrollController listScrollController = ScrollController();

  // final FocusNode focusNode = FocusNode();
  // Stream<List<Message>> fgetAllMessages({required String chatGroupId}) {
  //   return getAllMessages(GetAllMessagesParams(chatGroupId: chatGroupId));
  // }

  // Future<void> fsetChattingIdForUsers(
  //     {required SetChattingIdForUsersParams params,
  //     required GlobalKey<ScaffoldState> scaffoldKey}) async {
  //   final failOrUnit = await setChattingIdForUsers(params);
  //   failOrUnit.fold(
  //       (fail) => {
  //             if (fail is FirebaseFailure)
  //               ScaffoldMessenger.of(scaffoldKey.currentState!.context)
  //                   .showSnackBar(SnackBar(
  //                 content: Text(fail.message),
  //               ))
  //           },
  //       (r) => {});
  // }

  // Future<void> fsendMessage(
  //     {required SendMessageParams params, required scaffoldKey}) async {
  //   final failOrUnit = await sendMessage(params);
  //   failOrUnit.fold(
  //       (fail) => {
  //             if (fail is FirebaseFailure)
  //               ScaffoldMessenger.of(scaffoldKey.currentState!.context)
  //                   .showSnackBar(SnackBar(
  //                 content: Text(fail.message),
  //               ))
  //           },
  //       (r) => {});
  // }

  // Future<UploadedImage> fuplaodImageToServer(
  //     {required UplaodImageToServerParams params, required scaffoldKey}) async {
  //   UploadedImage? uploadedImage;
  //   final failOrUploadedImage = await uplaodImageToServer(params);
  //   failOrUploadedImage.fold(
  //       (fail) => {
  //             if (fail is FirebaseFailure)
  //               ScaffoldMessenger.of(scaffoldKey.currentState!.context)
  //                   .showSnackBar(SnackBar(
  //                 content: Text(fail.message),
  //               ))
  //           }, (uI) {
  //     uploadedImage = uI;
  //   });
  //   return uploadedImage!;
  // }

  // Future<void> fmarkPeerMessagesAsRead(
  //     {required MarkPeerMessagesAsReadParams params,
  //     required scaffoldKey}) async {
  //   final failOrUnit = await markPeerMessagesAsRead(params);
  //   failOrUnit.fold((fail) {
  //     if (fail is FirebaseFailure) {
  //       ScaffoldMessenger.of(scaffoldKey.currentState!.context)
  //           .showSnackBar(SnackBar(
  //         content: Text(fail.message),
  //       ));
  //     }
  //   }, (unit) {});
  // }

  // Future<MessageOverView> fgetNewMessagesCount(
  //     GetNewMessagesCountParams params) async {
  //   late MessageOverView messageOverView;
  //   final failOrCount = await getNewMessagesCount(params);
  //   failOrCount.fold((fail) {}, (newCount) {
  //     messageOverView = newCount;
  //   });
  //   return messageOverView;
  // }

  // bool isSendingImages = false;
  // void toggleIsSendingImage() {
  //   isSendingImages = !isSendingImages;
  //   emit(ChatInitial());
  //   emit(ChatToggleSending());
  // }

  // Message? _replayMessage;
  // Message? get replayMessage => _replayMessage;
  // void replayToMessage(Message message) {
  //   _replayMessage = message;
  //   focusNode.requestFocus();
  //   emit(ChatInitial());
  //   emit(ChatToggleSending());
  // }

  // void cancelReplay() {
  //   _replayMessage = null;
  //   emit(ChatInitial());
  //   emit(ChatToggleSending());
  // }
}
