import 'dart:convert';

GetPrivacyPolicyResponse getPrivacyPolicyResponseFromJson(String str) =>
    GetPrivacyPolicyResponse.fromJson(json.decode(str));

String getPrivacyPolicyResponseToJson(GetPrivacyPolicyResponse data) =>
    json.encode(data.toJson());

class GetPrivacyPolicyResponse {
  GetPrivacyPolicyResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.privacyPolicyContent,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<PrivacyPolicyContent> privacyPolicyContent;

  factory GetPrivacyPolicyResponse.fromJson(Map<String, dynamic> json) =>
      GetPrivacyPolicyResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        privacyPolicyContent: List<PrivacyPolicyContent>.from(
            json["results"].map((x) => PrivacyPolicyContent.fromJson(x))),
      );

  factory GetPrivacyPolicyResponse.fromMap(Map<String, dynamic> map) {
    return GetPrivacyPolicyResponse(
      count: map['count'],
      next: map['next'],
      previous: map['previous'],
      privacyPolicyContent: List<PrivacyPolicyContent>.from(
          map['results']?.map((x) => PrivacyPolicyContent.fromMap(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results":
            List<dynamic>.from(privacyPolicyContent.map((x) => x.toJson())),
      };
}

class PrivacyPolicyContent {
  PrivacyPolicyContent({
    this.id,
    this.privacyPolicy,
  });

  int? id;
  String? privacyPolicy;

  factory PrivacyPolicyContent.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyContent(
        id: json["id"],
        privacyPolicy: json["privacy_policy"],
      );

  factory PrivacyPolicyContent.fromMap(Map<String, dynamic> map) {
    return PrivacyPolicyContent(
      id: map['id'],
      privacyPolicy: map['privacy_policy'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "privacy_policy": privacyPolicy,
      };
}
