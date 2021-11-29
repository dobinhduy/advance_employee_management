import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  String collection = "admins";
  Future<bool> getPosition(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }
}
