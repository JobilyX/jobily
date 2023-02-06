import 'dart:convert';

class AppNotificationResponse {
  final int code;
  final bool status;
  final String message;
  final Body body;
  final String info;
  AppNotificationResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.body,
    required this.info,
  });

  AppNotificationResponse copyWith({
    int? code,
    bool? status,
    String? message,
    Body? body,
    String? info,
  }) {
    return AppNotificationResponse(
      code: code ?? this.code,
      status: status ?? this.status,
      message: message ?? this.message,
      body: body ?? this.body,
      info: info ?? this.info,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'body': body.toMap(),
      'info': info,
    };
  }

  factory AppNotificationResponse.fromMap(Map<String, dynamic> map) {
    return AppNotificationResponse(
      code: map['code']?.toInt() ?? 0,
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      body: Body.fromMap(map['body']),
      info: map['info'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotificationResponse.fromJson(String source) =>
      AppNotificationResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppNotificationResponse(code: $code, status: $status, message: $message, body: $body, info: $info)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppNotificationResponse &&
        other.code == code &&
        other.status == status &&
        other.message == message &&
        other.body == body &&
        other.info == info;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        status.hashCode ^
        message.hashCode ^
        body.hashCode ^
        info.hashCode;
  }
}

class Body {
  final UserNotifications userNotifications;
  Body({
    required this.userNotifications,
  });

  Body copyWith({
    UserNotifications? userNotifications,
  }) {
    return Body(
      userNotifications: userNotifications ?? this.userNotifications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_notifications': userNotifications.toMap(),
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      userNotifications: UserNotifications.fromMap(map['user_notifications']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source));

  @override
  String toString() => 'Body(userNotifications: $userNotifications)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Body && other.userNotifications == userNotifications;
  }

  @override
  int get hashCode => userNotifications.hashCode;
}

class UserNotifications {
  final List<AppNotification> data;
  final Paginate paginate;
  UserNotifications({
    required this.data,
    required this.paginate,
  });

  UserNotifications copyWith({
    List<AppNotification>? data,
    Paginate? paginate,
  }) {
    return UserNotifications(
      data: data ?? this.data,
      paginate: paginate ?? this.paginate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
      'paginate': paginate.toMap(),
    };
  }

  factory UserNotifications.fromMap(Map<String, dynamic> map) {
    return UserNotifications(
      data: List<AppNotification>.from(
          map['data']?.map((x) => AppNotification.fromMap(x))),
      paginate: Paginate.fromMap(map['paginate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserNotifications.fromJson(String source) =>
      UserNotifications.fromMap(json.decode(source));

  @override
  String toString() => 'UserNotifications(data: $data, paginate: $paginate)';
}

class AppNotification {
  final String id;
  final String title;
  final int readAt;
  final String createdAt;
  AppNotification({
    required this.id,
    required this.title,
    required this.readAt,
    required this.createdAt,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    int? readAt,
    String? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'read_at': readAt,
      'created_at': createdAt,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      readAt: map['read_at']?.toInt() ?? 0,
      createdAt: map['created_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) =>
      AppNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppNotification(id: $id, title: $title, readAt: $readAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppNotification &&
        other.id == id &&
        other.title == title &&
        other.readAt == readAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ readAt.hashCode ^ createdAt.hashCode;
  }
}

class Paginate {
  final int total;
  final int count;
  final int perPage;
  final String nextPageUrl;
  final String prevPageUrl;
  final int currentPage;
  final int totalPages;
  Paginate({
    required this.total,
    required this.count,
    required this.perPage,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.currentPage,
    required this.totalPages,
  });

  Paginate copyWith({
    int? total,
    int? count,
    int? perPage,
    String? nextPageUrl,
    String? prevPageUrl,
    int? currentPage,
    int? totalPages,
  }) {
    return Paginate(
      total: total ?? this.total,
      count: count ?? this.count,
      perPage: perPage ?? this.perPage,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'count': count,
      'per_page': perPage,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
      'current_page': currentPage,
      'total_pages': totalPages,
    };
  }

  factory Paginate.fromMap(Map<String, dynamic> map) {
    return Paginate(
      total: map['total']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
      perPage: map['per_page']?.toInt() ?? 0,
      nextPageUrl: map['next_page_url'] ?? '',
      prevPageUrl: map['prev_page_url'] ?? '',
      currentPage: map['current_page']?.toInt() ?? 0,
      totalPages: map['total_pages']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Paginate.fromJson(String source) =>
      Paginate.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Paginate(total: $total, count: $count, perPage: $perPage, nextPageUrl: $nextPageUrl, prevPageUrl: $prevPageUrl, currentPage: $currentPage, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Paginate &&
        other.total == total &&
        other.count == count &&
        other.perPage == perPage &&
        other.nextPageUrl == nextPageUrl &&
        other.prevPageUrl == prevPageUrl &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        count.hashCode ^
        perPage.hashCode ^
        nextPageUrl.hashCode ^
        prevPageUrl.hashCode ^
        currentPage.hashCode ^
        totalPages.hashCode;
  }
}
