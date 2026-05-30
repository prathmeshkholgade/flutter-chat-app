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
  final LastMessageModel? lastMessage;

  ChatModel({
    required this.chatId,
    required this.type,
    this.user,
    this.memberCount,
    this.group,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json["chatId"],
      type: json["type"] ?? "",
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      memberCount: json["memberCount"],
      group: json["group"] != null ? GroupModel.fromJson(json["group"]) : null,
      lastMessage: json["lastMessage"] != null
          ? LastMessageModel.fromJson(json["lastMessage"])
          : null,
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

class LastMessageModel {
  final int id;
  final String type;
  final int senderId;
  final int chatId;
  final String? text;
  final String? fileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final MessageUserModel? user;

  LastMessageModel({
    required this.id,
    required this.type,
    required this.senderId,
    required this.chatId,
    this.text,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json["id"],
      type: json["type"] ?? "",
      senderId: json["senderId"],
      chatId: json["chatId"],
      text: json["text"],
      fileUrl: json["fileUrl"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"]).toLocal()
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"]).toLocal()
          : null,
      user: json["User"] != null
          ? MessageUserModel.fromJson(json["User"])
          : null,
    );
  }
}

class MessageUserModel {
  final int id;
  final String fullName;
  final String email;
  final String? image;

  MessageUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.image,
  });

  factory MessageUserModel.fromJson(Map<String, dynamic> json) {
    return MessageUserModel(
      id: json["id"],
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      image: json["image"],
    );
  }
}
