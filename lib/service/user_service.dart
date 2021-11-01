import 'package:advance_employee_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_services.dart';

class UserServices {
  String collection = "employees";
  void createUser(String id, String name, String email) {
    FirebaseFirestore.instance.collection(collection).doc(id).set({
      "id": id,
      "name": name,
      "email": email,
    });
  }

  void updateUser(Map<String, dynamic> values) {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(values['id'])
        .update(values);
  }

  void addUser() {
    FirebaseFirestore.instance.collection("employees").add({
      "id": "123",
      "name": "Duy",
      "email": "sasa",
    });
  }

  Future<UserModel> getUserbyID(String id) => FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((doc) {
        return UserModel.fromSnapshot(doc);
      });
  Future<List<UserModel>> getAllUser() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<UserModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(UserModel.fromSnapshot(user));
        }
        return users;
      });
}
