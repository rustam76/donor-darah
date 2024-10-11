import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
    List<String>? connections;
    List<Chat>? chat;

    ChatModel({
        this.connections,
        this.chat,
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        connections: List<String>.from(json["connections"].map((x) => x)),
        chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connections!.map((x) => x)),
        "chat": List<dynamic>.from(chat!.map((x) => x.toJson())),
    };
}

class Chat {
    String? pengirim;
    String? penerima;
    String? pesan;
    DateTime? time;

    Chat({
        this.pengirim,
        this.penerima,
        this.pesan,
        this.time,
    });

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json["pengirim"],
        penerima: json["penerima"],
        pesan: json["pesan"],
        time: DateTime.parse(json["time"]),
    );

    Map<String, dynamic> toJson() => {
        "pengirim": pengirim,
        "penerima": penerima,
        "pesan": pesan,
        "time": time!.toIso8601String(),
    };
}
