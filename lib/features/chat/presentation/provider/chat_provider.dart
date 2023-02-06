// import 'package:flutter/material.dart';
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/message.dart';
// import '../../domain/entities/message_over_view.dart';
// import '../../domain/entities/uploade_image_response.dart';
// import '../../domain/usecases/get_messages.dart';
// import '../../domain/usecases/get_new_messages.dart';
// import '../../domain/usecases/mark_peer_messages_as_read.dart';
// import '../../domain/usecases/send_message.dart';
// import '../../domain/usecases/set_chatting_Id_for_users.dart';
// import '../../domain/usecases/uplaod_Image_to_server.dart';

// class ChatProvider extends ChangeNotifier {
//   final SetChattingIdForUsers setChattingIdForUsers;
//   final SendMessage sendMessage;
//   final GetAllMessages getAllMessages;
//   final UplaodImageToServer uplaodImageToServer;
//   final MarkPeerMessagesAsRead markPeerMessagesAsRead;
//   final GetNewMessagesCount getNewMessagesCount;
//   ChatProvider({
//     required this.getNewMessagesCount,
//     required this.setChattingIdForUsers,
//     required this.markPeerMessagesAsRead,
//     required this.sendMessage,
//     required this.getAllMessages,
//     required this.uplaodImageToServer,
//   });

//   final ScrollController listScrollController = ScrollController();

//   Stream<List<Message>> fgetAllMessages({required String chatGroupId}) {
//     return getAllMessages(GetAllMessagesParams(chatGroupId: chatGroupId));
//   }

//   Future<void> fsetChattingIdForUsers(
//       {required SetChattingIdForUsersParams params,
//       required GlobalKey<ScaffoldState> scaffoldKey}) async {
//     final failOrUnit = await setChattingIdForUsers(params);
//     failOrUnit.fold(
//         (fail) => {
//               if (fail is FirebaseFailure)
//                 ScaffoldMessenger.of(scaffoldKey.currentState!.context)
//                     .showSnackBar(SnackBar(
//                   content: Text(fail.message),
//                 ))
//             },
//         (r) => {});
//   }

//   Future<void> fsendMessage(
//       {required SendMessageParams params, required scaffoldKey}) async {
//     final failOrUnit = await sendMessage(params);
//     failOrUnit.fold(
//         (fail) => {
//               if (fail is FirebaseFailure)
//                 ScaffoldMessenger.of(scaffoldKey.currentState!.context)
//                     .showSnackBar(SnackBar(
//                   content: Text(fail.message),
//                 ))
//             },
//         (r) => {});
//   }

//   Future<UploadedImage> fuplaodImageToServer(
//       {required UplaodImageToServerParams params, required scaffoldKey}) async {
//     UploadedImage? uploadedImage;
//     final failOrUploadedImage = await uplaodImageToServer(params);
//     failOrUploadedImage.fold(
//         (fail) => {
//               if (fail is FirebaseFailure)
//                 ScaffoldMessenger.of(scaffoldKey.currentState!.context)
//                     .showSnackBar(SnackBar(
//                   content: Text(fail.message),
//                 ))
//             }, (uI) {
//       uploadedImage = uI;
//     });
//     return uploadedImage!;
//   }

//   Future<void> fmarkPeerMessagesAsRead(
//       {required MarkPeerMessagesAsReadParams params,
//       required scaffoldKey}) async {
//     final failOrUnit = await markPeerMessagesAsRead(params);
//     failOrUnit.fold((fail) {
//       if (fail is FirebaseFailure) {
//         ScaffoldMessenger.of(scaffoldKey.currentState!.context)
//             .showSnackBar(SnackBar(
//           content: Text(fail.message),
//         ));
//       }
//     }, (unit) {});
//   }

//   Future<MessageOverView> fgetNewMessagesCount(
//       GetNewMessagesCountParams params) async {
//     late MessageOverView messageOverView;
//     final failOrCount = await getNewMessagesCount(params);
//     failOrCount.fold((fail) {}, (newCount) {
//       messageOverView = newCount;
//     });
//     return messageOverView;
//   }

//   bool isSendingImages = false;
//   toggleIsSendingImage() {
//     isSendingImages = !isSendingImages;
//     notifyListeners();
//   }
// }
