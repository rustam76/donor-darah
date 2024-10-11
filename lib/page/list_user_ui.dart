import 'package:donor_darah/controller/chat_controller.dart';
// import 'package:donor_darah/model/users_model.dart';
// import 'package:donor_darah/page/chat_ui.dart';
import 'package:donor_darah/page/relawan/card_relawan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserList extends StatefulWidget {
  final String bloodType;

  const UserList({Key? key, required this.bloodType}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  ChatController chatController = ChatController();
  // UserModel _users = UserModel();

  Stream<QuerySnapshot<Map<String, dynamic>>> _getUserAndRelawanData() {
    return _firestore
        .collection('users')
        .where('bloodType', isEqualTo: widget.bloodType)
        .where('status', isEqualTo: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return _firestore.collection('users').doc(email).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Relawan Darah - ${widget.bloodType}'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _getUserAndRelawanData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text('No user data available'));
          }

          var listBlood = snapshot.data!.docs;

          if (listBlood.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          }

          return ListView.builder(
            itemCount: listBlood.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: friendStream(listBlood[index]['email']),
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
                  final lastDonationDate = data['lastDonor'];

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      // Placeholder avatar or load user's profile image
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      data['name'] ?? 'Anonymous',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data['email'] ?? 'Anonymous',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserCard(
                            id: listBlood[index].id,
                            email: auth.currentUser!.email!,
                            frendEmail: listBlood[index]['email'],
                            name: listBlood[index]['name'],
                            age: listBlood[index]['umur'],
                            bloodType: listBlood[index]['bloodType'],
                            nextDonationDate: lastDonationDate,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
