import 'user_model.dart';

class LoginResponseModel {
  final String? token;
  final UserModel? user;

  LoginResponseModel({this.token, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"],
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"token": token, "user": user?.toJson()};
  }
}
