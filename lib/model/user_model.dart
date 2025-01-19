
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? email;
  String? profilePic;
  String? tokenId;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.profilePic,
    this.tokenId
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePic: json["profile_pic"],
    tokenId: json["tokenId"]
  );

  Map<String, dynamic> toJson() => {
  "id": id,
  "name": name,
  "email": email,
  "profile_pic": profilePic,
    "tokenId":tokenId
  };
}