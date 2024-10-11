import 'package:donor_darah/page/home_ui.dart';
import 'package:donor_darah/controller/auth_controller.dart';
import 'package:donor_darah/page/admin/home_admin.dart';
// import 'package:donor_darah/page/home_ui.dart';
import 'package:donor_darah/page/login_ui.dart';
// import 'package:donor_darah/page/relawan/home_relawan.dart';
import 'package:donor_darah/widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donor Darah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  DonorView(),
    
    );
  }
}

class DonorView extends StatelessWidget {
  DonorView({Key? key}) : super(key: key);
  final LoginController auth = LoginController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.loginStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingView();
        } else if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<Map<String, dynamic>>(
            future: auth.getUserCredentials(snapshot.data!.email),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return LoadingView();
              } else if (userSnapshot.hasData && userSnapshot.data != null) {
                final userData = userSnapshot.data! as Map<String, dynamic>;
                final role = userData['role']; // Periksa peran pengguna
                if (role == 'admin') {
                  return HomeAdmin(userCredentials: userData);
                } else if (role == 'user') {
                  return HomeUi(userCredentials: userData);
                } else {
                  return LoginUi();
                }
              } else {
                return LoginUi();
              }
            },
          );
        } else {
          return LoginUi();
        }
      },
    );
  }
}