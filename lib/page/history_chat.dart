import 'package:donor_darah/model/users_model.dart';
import 'package:donor_darah/page/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryChat extends StatefulWidget {
  final Map<String, dynamic> currentUserId;

  const HistoryChat({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<HistoryChat> createState() => _HistoryChatState();
}

class _HistoryChatState extends State<HistoryChat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel _users = UserModel();
  String? chat_id; // Ensuring chat_id is properly initialized

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return _firestore
        .collection('users')
        .doc(email)
        .collection("chats")
        .orderBy("lastTime")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return _firestore.collection('users').doc(email).snapshots();
  }

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

        final updateStatusChat = await message
            .doc(chat_id)
            .collection("chat")
            .where("isRead", isEqualTo: false)
            .where("penerima", isEqualTo: email)
            .get();

        for (var element in updateStatusChat.docs) {
          await message
              .doc(chat_id)
              .collection("chat")
              .doc(element.id)
              .update({"isRead": true});
        }

        await users
            .doc(email)
            .collection("chats")
            .doc(chat_id)
            .update({"total_unread": 0});
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

        await users.doc(email).collection("chats").doc(chatDataId).set({
          "connection": friendEmail,
          "lastTime": chatData["lastTime"],
          "total_unread": 0,
        });

        chat_id = chatDataId;
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

        chat_id = newChatDoc.id;
      }
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatMessage(
        id: id,
        email: email,
        frendEmail: friendEmail,
        name: name,
        chatId: chat_id!,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatsStream(widget.currentUserId['email']),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!chatSnapshot.hasData || chatSnapshot.hasError) {
            return const Center(child: Text('No chat data available'));
          }

          var list = chatSnapshot.data!.docs;

          return ListView.separated(
            itemCount: list.length,
            itemBuilder: (context, index) {
              var chatData = list[index].data();
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: friendStream(chatData['connection']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Loading...'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.hasError) {
                    return const ListTile(
                      leading: Icon(Icons.error),
                      title: Text('Error loading user data'),
                    );
                  }

                  var data = snapshot.data!.data();

                  if (data == null) {
                    return const ListTile(
                      leading: Icon(Icons.error),
                      title: Text('User data not available'),
                    );
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      data['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data['email'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      goToChatRoom(
                        list[index].id,
                        widget.currentUserId['email'],
                        chatData['connection'],
                        data['name'],
                      );
                    },
                    trailing: list[index]['total_unread'] == 0
                        ? null
                        : Badge(
                            label: Text(
                              "${list[index]['total_unread']}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey,
                thickness: 1.0,
              );
            },
          );
        },
      ),
    );
  }
}
