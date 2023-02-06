import 'dart:convert';

import '../../../auth/domain/entities/user.dart';
import '../../../hr_home/domain/entities/job_byid_reponse.dart';
import '../../../hr_home/domain/entities/jobs_repsonse.dart';

class ChatUser {
  final String id;
  final String username;
  final String phone;
  final String image;
  final String userType;
  final String? fcmToken;
  ChatUser({
    required this.fcmToken,
    required this.id,
    required this.username,
    required this.phone,
    required this.image,
    required this.userType,
  });

  ChatUser copyWith(
      {String? id,
      String? username,
      String? phone,
      String? fcmToken,
      String? userType,
      String? image}) {
    return ChatUser(
      fcmToken: fcmToken ?? this.fcmToken,
      image: image ?? this.image,
      userType: userType ?? this.userType,
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': username,
      'phone': phone,
      'fcm_token': fcmToken,
      'image': image,
      'user_type': userType,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      image: map['image'],
      fcmToken: map['fcm_token'],
      userType: map['user_type'],
      id: map['id'].toString(),
      username: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
  factory ChatUser.fromAppUser(User user) {
    return ChatUser(
      fcmToken: user.fcm.first,
      image: user.avatar,
      userType: user.type.name,
      id: user.id.toString(),
      username: "${user.firstname} ${user.lastname}",
      phone: user.phone,
    );
  }
  factory ChatUser.fromJS(JobSeeker user) {
    return ChatUser(
      image: user.avatar,
      fcmToken: user.deviceTokens.first,
      userType: user.type,
      id: user.id.toString(),
      username: "${user.firstname} ${user.lastname}",
      phone: user.phone,
    );
  }
  factory ChatUser.fromHr(Hr user) {
    return ChatUser(
      image: user.avatar,
      fcmToken: user.deviceTokens.first,
      userType: user.type,
      id: user.id.toString(),
      username: "${user.firstname} ${user.lastname}",
      phone: user.phone,
    );
  }
  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, username: $username, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatUser &&
        other.id == id &&
        other.username == username &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ phone.hashCode;
  }
}
