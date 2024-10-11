import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/model/chat_model.dart';

class ChatController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;



  
  void addNewConnection(String friendEmail) async {
    bool isNewConnection = false;
    String date = DateTime.now().toIso8601String();
    CollectionReference users = _firestore.collection('users');
    CollectionReference message =_firestore.collection('messages');
  }

  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    CollectionReference users = _firestore.collection('users');
    CollectionReference message = _firestore.collection('messages');

    String date = DateTime.now().toIso8601String();

    // List<ChatModel> messages = [];

    await message.doc(argument['chat_id']).collection('messages').add({
      "pengirim": email,
      "penerima": argument['email'],
      "pesan": chat,
      "time": date
    });

    await users
        .doc(email)
        .collection("messages")
        .doc(argument["chat_id"])
        .update({
      "lastTime": date,
    });

    final checkChatsFriend = await users
        .doc(argument["friendEmail"])
        .collection("messages")
        .doc(argument["chat_id"])
        .get();

    if (checkChatsFriend.exists) {}
  }
}
