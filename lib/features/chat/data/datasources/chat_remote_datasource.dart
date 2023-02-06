import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/chat_user.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_over_view.dart';
import '../../domain/entities/uploade_image_response.dart';
import '../../domain/usecases/get_new_messages.dart';
import '../../domain/usecases/mark_peer_messages_as_read.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/set_chatting_Id_for_users.dart';
import '../../domain/usecases/uplaod_Image_to_server.dart';

abstract class ChatRemoteDataSource {
  Stream<List<Message>> getAllMessages({required String chatGroupId});

  Future<UploadedImage> uplaodImageToServer(
      {required UplaodImageToServerParams params});

  Future<void> sendMessage({required SendMessageParams params});

  Future<void> setChattingIdForUsers(
      {required SetChattingIdForUsersParams params});

  Future<void> markPeerMessagesAsRead(
      {required MarkPeerMessagesAsReadParams params});

  Future<MessageOverView> getNewMessagesCount(
      {required GetNewMessagesCountParams params});
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  FirebaseMessaging firebaseMessaging;
  ChatRemoteDataSourceImpl(
      {required this.firestore,
      required this.storage,
      required this.firebaseMessaging});
  @override
  Stream<List<Message>> getAllMessages({required String chatGroupId}) {
    try {
      final stream = firestore
          .collection('messages')
          .doc(chatGroupId)
          .collection(chatGroupId)
          .orderBy('timestamp', descending: true)
          .limit(60)
          .snapshots();
      return stream
          .map((e) => e.docs.map((e) => Message.fromJson(e.data())).toList());
    } catch (e) {
      throw FirebaseException;
    }
  }

  @override
  Future<UploadedImage> uplaodImageToServer(
      {required UplaodImageToServerParams params}) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final task = await storage
          .ref()
          .child('${params.chatGroupId}-$fileName')
          .putData(params.image);
      final taskSnapshot = task;
      return UploadedImage(
          url: await taskSnapshot.ref.getDownloadURL(), fileName: fileName);
    } catch (e) {
      throw FirebaseException;
    }
  }

  @override
  Future<void> sendMessage({required SendMessageParams params}) async {
    try {
      final documentReference = firestore
          .collection('messages')
          .doc(params.chatGroupId)
          .collection(params.chatGroupId)
          .doc(params.message.timestamp);
      documentReference.set(params.message.toMap());

      sendPushMessage(
          sender: params.sender,
          reciver: params.reciver,
          message: params.message);
    } catch (e) {
      throw FirebaseException;
    }
  }

  @override
  Future<void> setChattingIdForUsers(
      {required SetChattingIdForUsersParams params}) async {
    try {
      final user1Ref =
          firestore.doc('users/${params.userId1}/mychats/${params.userId2}');
      final user2Ref =
          firestore.doc('users/${params.userId2}/mychats/${params.userId1}');
      user1Ref.set(params.user2.toMap());

      user2Ref.set(params.user1.toMap());
    } catch (e) {
      log(e.toString());
      throw FirebaseException;
    }
  }

  @override
  Future<void> markPeerMessagesAsRead(
      {required MarkPeerMessagesAsReadParams params}) async {
    try {
      if (params.lastMessage.idFrom == params.userId2) {
        firestore
            .collection('messages')
            .doc(params.chatGroupId)
            .collection(params.chatGroupId)
            .where('idFrom', isEqualTo: params.userId2)
            .where('isRead', isEqualTo: false)
            .get()
            .then((documentSnapshot) {
          if (documentSnapshot.docs.isNotEmpty) {
            for (DocumentSnapshot doc in documentSnapshot.docs) {
              doc.reference.update({'isRead': true});
            }
          }
        });
      }
    } catch (e) {
      throw FirebaseException;
    }
  }

  Future<void> sendPushMessage(
      {required ChatUser sender,
      required ChatUser reciver,
      required Message message}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAYR6eB3Y:APA91bHO76-SL-iRNq8JBYaUtbrKnnvrXVrtyS5mXHka5vPdaFEgjQkOIl7M3U_v8LwJyMggAqlPqPZkvBjMR9woqxdUn1hF3pRO4pbYJ5i9WlWvDHdDec6aLvM5J7b68VmZWi90H_yU'
        },
        body: constructFCMPayload(sender, reciver, message),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  int _messageCount = 0;
  String constructFCMPayload(
      ChatUser sender, ChatUser reciver, Message message) {
    _messageCount++;
    return jsonEncode({
      'to': reciver.fcmToken,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "category": "chat",
        "sender_user": sender.toJson(),
        "reciver_user": reciver.toJson(),
      },
      'notification': {
        'title': '${message.senderName} send you a message',
        'body': message.type == MessageType.image
            ? "${message.senderName} send an image"
            : '${message.content} ',
        "sound": "default"
      },
    });
  }

  @override
  Future<MessageOverView> getNewMessagesCount(
      {required GetNewMessagesCountParams params}) async {
    try {
      final docs = await firestore
          .collection('messages')
          .doc(params.chatGroupId)
          .collection(params.chatGroupId)
          .where('idFrom', isEqualTo: params.idFrom)
          .where('isRead', isEqualTo: false)
          .get();
      if (docs.docs.isNotEmpty) {
        MessageOverView messageOverView = MessageOverView(
            newChat: false,
            newMessagesCount: docs.docs.length.toString(),
            messageContent: docs.docs.last["content"],
            messageTime: docs.docs.last["timestamp"],
            fromMe: false);
        return messageOverView;
      } else {
        final doc = await firestore
            .collection('messages')
            .doc(params.chatGroupId)
            .collection(params.chatGroupId)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        if (doc.docs.isNotEmpty) {
          MessageOverView messageOverView = MessageOverView(
              newChat: false,
              newMessagesCount: "0",
              messageContent: doc.docs.last["content"],
              messageTime: doc.docs.last["timestamp"],
              fromMe: doc.docs.last['idFrom'] != params.idFrom);
          return messageOverView;
        } else {
          MessageOverView messageOverView = MessageOverView(
              newChat: true,
              newMessagesCount: "0",
              messageContent: "",
              messageTime: "",
              fromMe: true);
          return messageOverView;
        }
      }
    } catch (e) {
      throw FirebaseException;
    }
  }
}
