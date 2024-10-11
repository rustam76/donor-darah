import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/controller/auth_controller.dart';
import 'package:donor_darah/controller/relawan_controller.dart';
import 'package:donor_darah/page/history_chat.dart';

// import 'package:donor_darah/page/chat_ui.dart';
// import 'package:donor_darah/page/list_user_ui.dart';

import 'package:donor_darah/page/registrasi_ui.dart';
import 'package:donor_darah/page/relawan/profile_ui.dart';
import 'package:donor_darah/page/select_blood_ui.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeUi extends StatefulWidget {
  final Map<String, dynamic> userCredentials;
  const HomeUi({super.key, required this.userCredentials});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  bool isLogin = true;
  final LoginController auth = LoginController();
  RelawanController relawanController = RelawanController();

  late String currentUserId;
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();

    currentUserId = auth
        .getCurrentUserUid(); // Implementasikan metode ini sesuai dengan logika aplikasi Anda
   
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Keluar"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                auth.logout(); // Perform logout action
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _showLogoutDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Navigator(
            key: _homeNavigatorKey, // Add a GlobalKey for the Navigator
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) => myHomePage(user: widget.userCredentials),
              );
            },
          ),
          Navigator(
            key: _chatNavigatorKey, // Add a GlobalKey for the Navigator
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) =>
                    HistoryChat(currentUserId: widget.userCredentials),
              );
            },
          ),
          Container(), // Placeholder for other pages if needed
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                  color:
                      _selectedIndex == 0 ? Colors.white : Colors.transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.black : Colors.white,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                  color:
                      _selectedIndex == 1 ? Colors.white : Colors.transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.chat,
                color: _selectedIndex == 1 ? Colors.black : Colors.white,
              ),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                  color:
                      _selectedIndex == 2 ? Colors.white : Colors.transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
          Icons.logout,
          color: _selectedIndex == 2 ? Colors.black : Colors.white,
        ),
            ),
            label: 'Keluar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        onTap: (index) {
    if (index == 2) {
      // Trigger logout when tapping the "Keluar" item
      _showLogoutDialog();
    } else {
      if (_selectedIndex == index) {
        // If the current tab is tapped again, pop to the first route
        if (index == 0) {
          _homeNavigatorKey.currentState?.popUntil((route) => route.isFirst);
        } else if (index == 1) {
          _chatNavigatorKey.currentState?.popUntil((route) => route.isFirst);
        }
      } else {
        // Switch tabs
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  },
      ),
    );
  }

// Declare GlobalKeys for Navigators
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _chatNavigatorKey =
      GlobalKey<NavigatorState>();
}

class myHomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  const myHomePage({Key? key, required this.user}) : super(key: key);

  @override
  _myHomePageState createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream =
        _firestore.collection("users").doc(widget.user['email']).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Center(child: Text('No Data Available'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Selamat Datang",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  userData['name'] ?? "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Center(
                  child:
                      Image.asset("assets/donor.png", width: 360, height: 360),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width, 60),
                    ),
                    onPressed: () {
                      _checkStatusRelawan(userData);
                    },
                    child: const Text("Relawan Pendonor"),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red, width: 1.6),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width, 60),
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SelectBlood())),
                    child: const Text("Butuh Darah"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkStatusRelawan(Map<String, dynamic> userData) {
    bool isRelawan = userData['isRelawan'] ?? false;

    if (isRelawan) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileUi()),
          //  builder: (context) => RegistrasiUi(userRelawan: widget.user)),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => RegistrasiUi(userRelawan: widget.user)),
      );
    }
  }
}
