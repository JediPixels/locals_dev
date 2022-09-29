import 'dart:convert';

class AuthErrorModel {
  AuthErrorModel({
    required this.error,
  });

  String error;

  factory AuthErrorModel.fromRawJson(String str) => AuthErrorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthErrorModel.fromJson(Map<String, dynamic> json) => AuthErrorModel(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}

// JSON
// {
// "error": "INCORRECT_EMAIL_PASSWORD_COMBINATION"
// }