class ChatMessagesData {
  final List<ChatMessageModel> chats;

  ChatMessagesData({required this.chats});

  factory ChatMessagesData.fromJson(Map<String, dynamic> json) {
    return ChatMessagesData(
      chats: json["chats"] != null
          ? List<ChatMessageModel>.from(
              json["chats"].map((e) => ChatMessageModel.fromJson(e)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {"chats": chats.map((e) => e.toJson()).toList()};
  }
}

class ChatMessageModel {
  final int id;
  final String type;
  final int senderId;
  final int chatId;
  final String text;
  final String? fileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessageModel({
    required this.id,
    required this.type,
    required this.senderId,
    required this.chatId,
    required this.text,
    required this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      senderId: json["senderId"] ?? 0,
      chatId: json["chatId"] ?? 0,
      text: json["text"] ?? "",
      fileUrl: json["fileUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "senderId": senderId,
      "chatId": chatId,
      "text": text,
      "fileUrl": fileUrl,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
