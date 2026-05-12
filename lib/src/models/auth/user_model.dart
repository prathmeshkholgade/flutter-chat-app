class UserModel {
  final int? id;
  final String? email;
  final String? fullName;

  UserModel({this.id, this.email, this.fullName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      fullName: json["fullName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "email": email, "fullName": fullName};
  }
}
