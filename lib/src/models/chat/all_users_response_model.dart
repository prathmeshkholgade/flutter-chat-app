class AllUsersResponseModel {
  final List<ChatUserModel> allUsers;
  final int totalUser;
  final int totalPages;
  AllUsersResponseModel({
    required this.allUsers,
    required this.totalUser,
    required this.totalPages,
  });

  factory AllUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return AllUsersResponseModel(
      allUsers: (json["allUsers"] as List)
          .map((e) => ChatUserModel.fromJson(e))
          .toList(),
      totalUser: json["totalUser"],
      totalPages: json["totalPages"],
    );
  }
}

class ChatUserModel {
  final int id;
  final String fullName;
  final String email;
  final String? image;

  ChatUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.image,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json["id"],
      fullName: json["fullName"],
      email: json["email"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "fullName": fullName, "email": email, "image": image};
  }
}
