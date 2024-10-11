import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/controller/auth_controller.dart';
import 'package:donor_darah/page/admin/detail_user.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  final Map<String, dynamic> userCredentials;
  const HomeAdmin({super.key, required this.userCredentials});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // Initialize tab controller
  }

  @override
  void dispose() {
    _tabController
        .dispose(); // Dispose of tab controller when state is destroyed
    super.dispose();
  }

  final LoginController auth = LoginController();

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin Keluar?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              child: const Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                auth.logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi, ${widget.userCredentials["name"]}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutDialog();
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          // Add TabBar as part of AppBar's bottom
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Home'),
            Tab(text: 'Verified'),
            Tab(text: 'Not Verified'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Home Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final users = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['role'] != 'admin' && data['isRelawan'] == true ||
                      data['isRelawan'] == false && data['status'] != null;
                }).toList();
                // (doc.data() as Map<String, dynamic>)['role'] != 'admin')

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final name = user['name'] ?? '';
                    final role = user['role'] ?? "";
                    final isVerified = user['status'] ?? false;

                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailUsers(userEmail: user['email']),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$name"),
                                Text(
                                  role == "user" ? "relawan" : "",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Badge(
                              label: isVerified
                                  ? Text('verification')
                                  : Text('not verified'),
                              backgroundColor:
                                  isVerified ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),

          // Verified Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('status', isEqualTo: true)
                .where('isRelawan', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final users = snapshot.data!.docs
                    .where((doc) =>
                        (doc.data() as Map<String, dynamic>)['role'] != 'admin')
                    .toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final name = user['name'] ?? '';
                    final role = user['role'] ?? "";
                    final isVerified = user['status'] ?? false;

                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailUsers(userEmail: user['email']),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$name"),
                                Text(
                                  role == "user" ? "relawan" : "",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Badge(
                              label: isVerified
                                  ? Text('verification')
                                  : Text('not verified'),
                              backgroundColor:
                                  isVerified ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),

          // Not Verified Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final users = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['role'] != 'admin' &&
                      data['isRelawan'] == true &&
                      data['status'] == false;
                }).toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final name = user['name'] ?? '';
                    final role = user['role'] ?? "";
                    final isVerified = user['status'] ?? false;

                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailUsers(userEmail: user['email']),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$name"),
                                Text(
                                  role == "user" ? "relawan" : "",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Badge(
                              label: isVerified
                                  ? Text('batal ')
                                  : Text('not verified'),
                              backgroundColor:
                                  isVerified ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
