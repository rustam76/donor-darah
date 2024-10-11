import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/model/users_model.dart';

class RelawanController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return userDoc;
  }

  Future<bool> updateUser(String email, Map<String, dynamic> data) async {
    try {
      // Get user document from Firestore
      final userDoc = await firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        UserModel user = UserModel.fromJson(userData);

        user.name = data["name"] ?? user.name ?? '';
        user.email = data["email"] ?? user.email ?? '';
        user.umur = data["umur"] ?? user.umur ?? 0;
        user.bloodType = data["bloodType"] ?? user.bloodType ?? '';
        user.isRelawan = data["isRelawan"] ?? user.isRelawan;
        user.jenisKelamin = data["jenis_kelamin"] ?? user.jenisKelamin ?? '';
        user.ktpFile = data["ktp_file"] ?? user.ktpFile ?? '';
        user.status = data["status"] ?? user.status ?? false;
        user.bloodCardFile =
            data["blood_card_file"] ?? user.bloodCardFile ?? '';
        user.updatedTime = DateTime.now().toIso8601String();
        await firestore.collection('users').doc(email).update(user.toJson());

        print("User updated successfully.");
        return true;
      } else {
        print("User not found.");
        return false;
      }
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  Future<bool> updateUserStatus(String email, bool status) async {
    try {
      // Check if the user document exists
      final userDoc = await firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        await firestore.collection('users').doc(email).update({
          'status': status,
          'isRelawan': true,
          'updatedTime': DateTime.now().toIso8601String(),
        });

        print("User status updated successfully.");
        return true;
      } else {
        print("User not found.");
        return false;
      }
    } catch (e) {
      print("Error updating user status: $e");
      return false;
    }
  }

  Future<bool> updateUserDonor(String email) async {
    try {
      // Check if the user document exists
      final userDoc = await firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        await firestore.collection('users').doc(email).update({
          'lastDonor': DateTime.now().toIso8601String(),
          'updatedTime': DateTime.now().toIso8601String(),
        });

        print("User status updated successfully.");
        return true;
      } else {
        print("User not found.");
        return false;
      }
    } catch (e) {
      print("Error updating user status: $e");
      return false;
    }
  }
}
