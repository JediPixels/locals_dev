import 'dart:convert';

class AuthModel {
  AuthModel({
    required this.result,
  });

  Result result;

  factory AuthModel.fromRawJson(String str) => AuthModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  Result({
    required this.username,
    required this.email,
    required this.userId,
    required this.uniqueId,
    required this.ssAuthToken,
    required this.activeSubscriber,
    required this.unclaimedGift,
  });

  String username;
  String email;
  int userId;
  String uniqueId;
  String ssAuthToken;
  int activeSubscriber;
  int unclaimedGift;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    username: json["username"],
    email: json["email"],
    userId: json["user_id"],
    uniqueId: json["unique_id"],
    ssAuthToken: json["ss_auth_token"],
    activeSubscriber: json["active_subscriber"],
    unclaimedGift: json["unclaimed_gift"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "user_id": userId,
    "unique_id": uniqueId,
    "ss_auth_token": ssAuthToken,
    "active_subscriber": activeSubscriber,
    "unclaimed_gift": unclaimedGift,
  };
}

// JSON
// {
//   "result": {
//   "username": "@test_locals0",
//   "email": "testlocals0@gmail.com",
//   "user_id": 45018,
//   "unique_id": "u_059e304c-bf71-4ef0-87df-3d0fc76e921d",
//   "ss_auth_token": "3dc41db750a76befc2c45ee455d224d52dde907d9abe0feed87436f45f3574c0",
//   "active_subscriber": 0,
//   "unclaimed_gift": 0
//   }
// }