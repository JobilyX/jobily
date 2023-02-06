class ChangelanguageModel {
  ChangelanguageModel({
    required this.code,
    required this.status,
    required this.message,
    required this.body,
    required this.info,
  });

  int code;
  bool status;
  String message;
  Body body;
  String info;

  factory ChangelanguageModel.fromJson(Map<String, dynamic> json) =>
      ChangelanguageModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        body: Body.fromJson(json["body"]),
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

class Body {
  Body({
    required this.language,
  });

  Language language;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        language: Language.fromJson(json["language"]),
      );

  Map<String, dynamic> toJson() => {
        "language": language.toJson(),
      };
}

class Language {
  Language({
    required this.id,
    required this.name,
    required this.flag,
    required this.code,
  });

  int id;
  String name;
  String flag;
  String code;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        name: json["name"],
        flag: json["flag"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "flag": flag,
        "code": code,
      };
}
