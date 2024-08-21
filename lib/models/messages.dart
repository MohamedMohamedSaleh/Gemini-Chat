class Message {
  String chatId;
  String messageId;
  Role role;
  StringBuffer message;
  List<String> imagesUrls;
  DateTime timeSend;

  Message({
    required this.chatId,
    required this.messageId,
    required this.role,
    required this.message,
    required this.imagesUrls,
    required this.timeSend,
  });

//toMap
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'messageId': messageId,
      'role': role.index,
      'message': message.toString(),
      'imagesUrls': imagesUrls,
      'timeSend': timeSend,
    };
  }

  //fromMap
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      chatId: map['chatId'],
      messageId: map['messageId'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imagesUrls: List<String>.from(map['imagesUrls']),
      timeSend: DateTime.parse(map['timeSend'].toString()),
    );
  }

  //copyWith This method allows you to copy an object and
  // update some of its properties without changing the original object.
  Message copyWith({
    String? chatId,
    String? messageId,
    Role? role,
    StringBuffer? message,
    List<String>? imagesUrls,
    DateTime? timeSend,
  }) {
    return Message(
      chatId: chatId ?? this.chatId,
      messageId: messageId ?? this.messageId,
      role: role ?? this.role,
      message: message ?? this.message,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      timeSend: timeSend ?? this.timeSend,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.messageId == messageId;
  }

  @override
  int get hashCode => messageId.hashCode;
}

enum Role {
  user,
  assistant,
}
