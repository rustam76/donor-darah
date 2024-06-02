import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

class LoginController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<User?> get loginStatus => auth.authStateChanges();

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An unknown error occurred.";
    }
  }

  Future<User?> register(String name, String email, String password, String role) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        await firestore
            .collection('users')
            .doc(user.email)
            .set({'name': name, 'email': email,'isRelawan': false, role: role });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An unknown error occurred."; 
    } 
  }

Future<Map<String, dynamic>> getUserCredentials(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = 
        await firestore.collection('users').doc(id).get();
      return userDoc.data() ?? {};
    } catch (e) {
      print("Error getting user data: $e");
      return {};
    }
  }


  void logout() async {
    await auth.signOut();
  }
}
