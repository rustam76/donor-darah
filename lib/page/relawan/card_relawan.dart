import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/model/users_model.dart';
import 'package:donor_darah/page/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserCard extends StatefulWidget {
  final String id;
  final String email;
  final String name;
  final String age;
  final String bloodType;
  final String? nextDonationDate;
  final String frendEmail;

  const UserCard({
    Key? key,
    required this.id,
    required this.email,
    required this.frendEmail,
    required this.name,
    required this.age,
    required this.bloodType,
    this.nextDonationDate,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  UserModel _users = UserModel();
  var chat_id;

  void goToChatRoom(
    String id,
    String email,
    String friendEmail,
    String name,
  ) async {
    bool isNewConnection = false;
    String date = DateTime.now().toIso8601String();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference message =
        FirebaseFirestore.instance.collection('chats');

    final getDataChat = await users.doc(email).collection('chats').get();

    if (getDataChat.docs.isNotEmpty) {
      final checkConnection = await users
          .doc(email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        isNewConnection = false;
        chat_id = checkConnection.docs[0].id;
      } else {
        isNewConnection = true;
      }
    } else {
      isNewConnection = true;
    }

    if (isNewConnection) {
      final creatChatDoc = await message.where(
        "connections",
        whereIn: [
          [email, friendEmail],
          [friendEmail, email],
        ],
      ).get();

      if (creatChatDoc.docs.isNotEmpty) {
        final chatDataId = creatChatDoc.docs[0].id;
        final chatData = creatChatDoc.docs[0].data() as Map<String, dynamic>;

        await users.doc(email).collection("chats").doc(chatDataId).update({
          "lastTime": chatData["lastTime"],
          "total_unread": 0,
        });

        final listChat = await users.doc(email).collection("chats").get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          for (var element in listChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
            ));
          }
          setState(() {
            _users.chats = dataListChats;
          });
        } else {
          setState(() {
            _users.chats = [];
          });
          chat_id = chatDataId;
        }
      } else {
        final newChatDoc = await message.add({
          "connections": [
            email,
            friendEmail,
          ],
        });

        await message.doc(newChatDoc.id).collection("chat");

        await users.doc(email).collection("chats").doc(newChatDoc.id).set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats = await users.doc(email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
            ));
          }

          setState(() {
            _users.chats = dataListChats;
          });
        } else {
          setState(() {
            _users.chats = [];
          });
        }
        chat_id = newChatDoc.id;
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatMessage(
          id: id,
          email: email,
          frendEmail: friendEmail,
          name: name,
          chatId: chat_id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Detail Relawan'),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      widget.frendEmail,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text('${widget.age}', style: TextStyle(fontSize: 22.0)),
              ),
              SizedBox(width: 8.0),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(widget.bloodType, style: TextStyle(fontSize: 22.0)),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    children: [
                      Text('Terakhir Donor', style: TextStyle(fontSize: 12.0)),
                      Text(
                        widget.nextDonationDate != null
                            ? DateFormat.yMMMMEEEEd().format(DateTime.parse(widget.nextDonationDate.toString()))
                            : 'No date available',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            SizedBox(height: 16.0),
            Center(
              child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // side: BorderSide(color: Colors.red, width: 1.6),
                        ),
                        fixedSize: Size(MediaQuery.of(context).size.width, 60)),
                    onPressed: () {
                      goToChatRoom(
                        widget.id,
                        widget.email,
                        widget.frendEmail,
                        widget.name,
                      );
                    },
                    child: const Text("Kirim Pesan"),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
