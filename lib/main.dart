// import 'package:donor_darah/page/home_ui.dart';
import 'package:donor_darah/controller/login_controller.dart';
import 'package:donor_darah/page/home_ui.dart';
import 'package:donor_darah/page/login_ui.dart';
import 'package:donor_darah/widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      home: DonorView(),
      // home: snapshot.data != null ? const HomeUi() : const LoginUi(),
    );
    // return const DonorView();
  }
}

class DonorView extends StatelessWidget {
  DonorView({super.key});
  final LoginController auth = LoginController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.loginStatus,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingView();
          } else if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder<Map<String, dynamic>>(
                future: auth.getUserCredentials(snapshot.data!.uid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return LoadingView();
                  } else if (userSnapshot.hasData &&
                      userSnapshot.data != null) {
                    return HomeUi(userCredentials: userSnapshot.data!);
                  } else {
                    return Scaffold(
                        body: Center(child: Text('Failed to get user data')));
                  }
                });
          } else {
            return LoginUi();
          }
        });
  }
}
