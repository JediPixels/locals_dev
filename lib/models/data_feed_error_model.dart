import 'dart:convert';

class DataFeedErrorModel {
  DataFeedErrorModel({
    required this.errors,
    required this.params,
    required this.status,
    required this.code,
  });

  List<dynamic> errors;
  List<dynamic> params;
  int status;
  String code;

  factory DataFeedErrorModel.fromRawJson(String str) => DataFeedErrorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataFeedErrorModel.fromJson(Map<String, dynamic> json) => DataFeedErrorModel(
    errors: List<dynamic>.from(json["errors"].map((x) => x)),
    params: List<dynamic>.from(json["params"].map((x) => x)),
    status: json["status"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "errors": List<dynamic>.from(errors.map((x) => x)),
    "params": List<dynamic>.from(params.map((x) => x)),
    "status": status,
    "code": code,
  };
}

// JSON
// {
//   "errors": [],
//   "params": [],
//   "status": 0,
//   "code": "NOT_AUTH"
// }