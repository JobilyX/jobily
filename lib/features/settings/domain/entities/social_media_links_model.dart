class GetSocialMediaLinksResponse {
  GetSocialMediaLinksResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.body,
    required this.info,
  });

  final int code;
  final bool status;
  final String message;
  final SocialMediaLinksData body;
  final String info;

  factory GetSocialMediaLinksResponse.fromJson(Map<String, dynamic> json) =>
      GetSocialMediaLinksResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        body: SocialMediaLinksData.fromJson(json["body"]),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "body": body.toJson(),
        "info": info,
      };
}

class SocialMediaLinksData {
  SocialMediaLinksData({
    required this.phone,
    required this.email1,
    required this.twitter,
    required this.youtube,
    required this.facebook,
    required this.linkedin,
    required this.instagram,
    required this.snapchat,
  });

  final String phone;
  final String email1;
  final String twitter;
  final String youtube;
  final String facebook;
  final String linkedin;
  final String instagram;
  final String snapchat;

  factory SocialMediaLinksData.fromJson(Map<String, dynamic> json) =>
      SocialMediaLinksData(
        phone: json["phone"],
        email1: json["email1"],
        twitter: json["twitter"],
        youtube: json["youtube"],
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        instagram: json["instagram"],
        snapchat: json["snapchat"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "email1": email1,
        "twitter": twitter,
        "youtube": youtube,
        "facebook": facebook,
        "linkedin": linkedin,
        "instagram": instagram,
        "snapchat": snapchat,
      };
}
