import 'user_model.dart';

class SignupResponseModel {
  final String? token;
  final UserModel? user;

  SignupResponseModel({this.token, this.user});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      token: json["token"],
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"token": token, "user": user?.toJson()};
  }
}
