import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? uid;
    String? name;
    String? email;
    String? umur;
    String? bloodType;
    String? jenisKelamin;
    bool? isRelawan;
    String? lastDonor;
    String? ktpFile;
    String? bloodCardFile;
    String? foto;
    String? role;
    bool? status;
    String? createdAt;
    String? updatedTime;
    List<ChatUser>? chats;

    UserModel({
        this.uid,
        this.name,
        this.email,
        this.umur,
        this.bloodType,
        this.jenisKelamin,
        this.isRelawan,
        this.lastDonor,
        this.ktpFile,
        this.bloodCardFile,
        this.foto,
        this.role,
        this.status,
        this.createdAt,
        this.updatedTime,
        this.chats,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        umur: json["umur"],
        bloodType: json["bloodType"],
        jenisKelamin: json["jenis_kelamin"],
        isRelawan: json["isRelawan"],
        lastDonor: json["lastDonor"],
        ktpFile: json["ktp_file"],
        bloodCardFile: json["blood_card_file"],
        foto: json["foto"],
        role: json["role"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedTime: json["updatedTime"],
        chats: json["chats"] == null ? [] : List<ChatUser>.from(json["chats"].map((x) => ChatUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "umur": umur,
        "bloodType": bloodType,
        "jenis_kelamin": jenisKelamin,
        "isRelawan": isRelawan,
        
        "ktp_file": ktpFile,
        "lastDonor": lastDonor,
        "blood_card_file": bloodCardFile,
        "foto": foto,
        "role": role,
        "status": status,
        "createdAt": createdAt,
        "updatedTime": updatedTime,
        "chats": chats == null ? [] : List<dynamic>.from(chats!.map((x) => x.toJson())),
    };
}

class ChatUser {
    String? connection;
    String? chatId;
    DateTime? lastTime;
    int? totalUnread;

    ChatUser({
        this.connection,
        this.chatId,
        this.lastTime,
        this.totalUnread,
    });

    factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        connection: json["connection"],
        chatId: json["chat_id"],
        lastTime: json["lastTime"] == null ? null : DateTime.parse(json["lastTime"]),
        totalUnread: json["total_unread"],
    );

    Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "lastTime": lastTime?.toIso8601String(),
        "total_unread": totalUnread,
    };
}