import 'package:cloud_firestore/cloud_firestore.dart';

class GolonganDarahController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> getGolonganDarah() async {
    CollectionReference data = db.collection('relawan');
    return data.get();
  }

}
