class ChatUsersResponse {
  final int total;
  final int page;
  final int totalPages;
  final List<ChatModel> chats;

  ChatUsersResponse({
    required this.total,
    required this.page,
    required this.totalPages,
    required this.chats,
  });

  factory ChatUsersResponse.fromJson(Map<String, dynamic> json) {
    return ChatUsersResponse(
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
      chats: (json["chats"] as List<dynamic>? ?? [])
          .map((e) => ChatModel.fromJson(e))
          .toList(),
    );
  }
}

class ChatModel {
  final int chatId;
  final String type;
  final UserModel? user;
  final int? memberCount;
  final GroupModel? group;

  ChatModel({
    required this.chatId,
    required this.type,
    this.user,
    this.memberCount,
    this.group,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json["chatId"],
      type: json["type"] ?? "",
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      memberCount: json["memberCount"],
      group: json["group"] != null ? GroupModel.fromJson(json["group"]) : null,
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? image;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"] ?? "",
      fullName: json["fullName"] ?? "",
      image: json["image"],
    );
  }
}

class GroupModel {
  final int id;
  final String name;
  final String description;
  final String? image;
  final GroupCreatedByModel? groupCreatedBy;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    this.groupCreatedBy,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"],
      groupCreatedBy: json["groupCreatedBy"] != null
          ? GroupCreatedByModel.fromJson(json["groupCreatedBy"])
          : null,
    );
  }
}

class GroupCreatedByModel {
  final int id;
  final String fullName;
  final String email;

  GroupCreatedByModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory GroupCreatedByModel.fromJson(Map<String, dynamic> json) {
    return GroupCreatedByModel(
      id: json["id"],
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
    );
  }
}
