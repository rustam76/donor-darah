import 'package:cloud_firestore/cloud_firestore.dart';


class RelawanController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async {
  DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  return userDoc;
}


  
}