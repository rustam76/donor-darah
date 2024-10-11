import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatefulWidget {
  final id;
  final email;
  final frendEmail;
  final name;
  final chatId;

  const ChatMessage(
      {Key? key, this.id, this.email, this.frendEmail, this.name, this.chatId})
      : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  User? _user;
  int total_unread = 0;
  bool isFirstChat = false;

  List<String> _suggestions = [
    'Halo, Saya membutuhkan bantuan Anda!?',
    'halo, apakah anda bersedia mendonorkan darah?',
    'Halo, Apakah anda ingin mendonorkan darah?',
  ];

  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _getUser();
    _focusNode.addListener(_onFocusChange); // Add focus listener
    _checkIfFirstChat();
     _filteredSuggestions.addAll(_suggestions);
  }

void _onChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredSuggestions.clear();
        _filteredSuggestions.addAll(_suggestions);
      } else {
  
        _filteredSuggestions = _suggestions
            .where((suggestion) =>
                suggestion.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

_buildSuggestions() {
  return _filteredSuggestions.isEmpty
      ? SizedBox()
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: _filteredSuggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _controller.text = suggestion;
                  _filteredSuggestions.clear();
                  _focusNode.requestFocus();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    suggestion.length > 25 ? '${suggestion.substring(0, 25)}...' : suggestion,
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
              );
            }).toList(),
          ),
        );
}


  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange); // Remove focus listener
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _getUser() async {
    _user = _auth.currentUser;
    if (_user == null) {
      UserCredential userCredential = await _auth.signInAnonymously();
      _user = userCredential.user;
    }
  }

  void _checkIfFirstChat() async {
    DocumentSnapshot chatDoc =
        await _firestore.collection("chats").doc(widget.chatId).get();
    setState(() {
      isFirstChat = !chatDoc.exists;
    });
  }

  Stream<DocumentSnapshot<Object?>> streamFriendData(String friendEmail) {
    CollectionReference users = _firestore.collection("users");

    return users.doc(friendEmail).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chat_id) {
    CollectionReference chats = _firestore.collection("chats");

    return chats.doc(chat_id).collection("chat").orderBy("time").snapshots();
  }

  void newChat(String email, String chat) async {
    if (chat != "") {
      CollectionReference chats = _firestore.collection("chats");
      CollectionReference users = _firestore.collection("users");

      String date = DateTime.now().toIso8601String();

      if (isFirstChat) {
        await chats.doc(widget.chatId).collection("chat").add({
          "pengirim": email,
          "penerima": widget.frendEmail,
          "msg": "halo apa kabar",
          "time": date,
          "isRead": false,
          "groupTime": DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
        });
        setState(() {
          isFirstChat = false;
        });
      }

      await chats.doc(widget.chatId).collection("chat").add({
        "pengirim": email,
        "penerima": widget.frendEmail,
        "msg": chat,
        "time": date,
        "isRead": false,
        "groupTime": DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
      });

      await users.doc(email).collection("chats").doc(widget.chatId).update({
        "lastTime": date,
      });

      final checkChatsFriend = await users
          .doc(widget.frendEmail)
          .collection("chats")
          .doc(widget.chatId)
          .get();

      if (checkChatsFriend.exists) {
        final checkTotalUnread = await chats
            .doc(widget.chatId)
            .collection("chat")
            .where("isRead", isEqualTo: false)
            .where("pengirim", isEqualTo: email)
            .get();

        total_unread = checkTotalUnread.docs.length;

        await users
            .doc(widget.frendEmail)
            .collection("chats")
            .doc(widget.chatId)
            .update({"lastTime": date, "total_unread": total_unread});
      } else {
        await users
            .doc(widget.frendEmail)
            .collection("chats")
            .doc(widget.chatId)
            .set({
          "connection": email,
          "lastTime": date,
          "total_unread": 1,
        });
      }
    }
    _controller.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showTemplateBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 280,
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 5),
                  Text('Pilih Template',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                  Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close))
                ],
              ),
              ListTile(
                title: Text('Halo, Saya membutuhkan bantuan Anda!?'),
                onTap: () {
                  _controller.text = 'Halo, Saya membutuhkan bantuan Anda!?';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('halo, apakah anda bersedia mendonorkan darah?'),
                onTap: () {
                  _controller.text =
                      'halo, apakah anda bersedia mendonorkan darah?';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Apakah kamu bisa melakukan donor darah?'),
                onTap: () {
                  _controller.text = 'Apakah kamu bisa melakukan donor darah';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: streamChats(widget.chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var alldata = snapshot.data!.docs;

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: alldata.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              ItemChat(
                                msg: "${alldata[index]["msg"]}",
                                isSender:
                                    alldata[index]["pengirim"] == widget.email,
                                time: "${alldata[index]["time"]}",
                              ),
                            ],
                          );
                        } else {
                          if (alldata[index]["groupTime"] ==
                              alldata[index - 1]["groupTime"]) {
                            return ItemChat(
                              msg: "${alldata[index]["msg"]}",
                              isSender:
                                  alldata[index]["pengirim"] == widget.email,
                              time: "${alldata[index]["time"]}",
                            );
                          } else {
                            return Column(
                              children: [
                                Text(
                                  "${alldata[index]["groupTime"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ItemChat(
                                  msg: "${alldata[index]["msg"]}",
                                  isSender: alldata[index]["pengirim"] ==
                                      widget.email,
                                  time: "${alldata[index]["time"]}",
                                ),
                              ],
                            );
                          }
                        }
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSuggestions(),
                SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    // InkWell(
                    //   onTap: _showTemplateBottomSheet,
                    //   borderRadius:
                    //       BorderRadius.circular(8.0), // Menambahkan border radius
                    //   child: Container(
                    //     padding: EdgeInsets.all(
                    //         2.0), // Menambahkan padding di dalam Container
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[200], // Warna latar belakang
                    //       borderRadius:
                    //           BorderRadius.circular(8.0), // Sudut membulat
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Icon(
                    //           Icons.format_quote_rounded,
                    //           color: Colors.blue,
                    //         ),
                    //         Text(
                    //           'Template',
                    //           style: TextStyle(color: Colors.black54, fontSize: 10),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: _controller,
                                focusNode: _focusNode, // Attach FocusNode
                                  onChanged: _onChanged,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message',
                                ),
                              ),
                            ),
                         SizedBox(height: 10.0),
                        
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          newChat(widget.email, _controller.text);
                        },
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}


class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSender ? Colors.red : Colors.grey[200],
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: EdgeInsets.all(15),
            child: Text(
              "$msg",
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(DateFormat.jm().format(DateTime.parse(time))),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
