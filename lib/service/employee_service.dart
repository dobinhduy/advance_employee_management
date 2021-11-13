import 'package:advance_employee_management/models/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeServices {
  String collection = "employees";
  void createEmployee(String id, String name, String email) {
    FirebaseFirestore.instance.collection(collection).doc(id).set({
      "id": id,
      "name": name,
      "email": email,
    });
  }

  void updateEmployee(String email, Map<String, dynamic> map) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.update(map);
  }

  void deleteEmployee(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.delete();
  }

  void getphotoURL(String id, String photoURL) {
    FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .snapshots()
        .forEach((element) {
      FirebaseFirestore.instance.collection(collection).add({
        "photourl": photoURL,
      });
    });
  }

  void addEmployee(
    String id,
    String name,
    String gender,
    String birthday,
    String email,
    String address,
    String phone,
    String photourl,
    String position,
  ) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "name": name,
      "email": email,
      "birthday": birthday,
      "address": address,
      "phone": phone,
      "position": position,
      "gender": gender,
      "photourl": photourl,
    });
  }

  bool checkExistEmployee(String email) {
    if (FirebaseFirestore.instance
            .collection(collection)
            .where("email", isEqualTo: email) !=
        null) {
      return false;
    }
    return true;
  }

  Future<EmployeeModel> getEmployeebyID(String id) => FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((doc) {
        return EmployeeModel.fromSnapshot(doc);
      });

  Future<List<EmployeeModel>> getAllEmployee() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<EmployeeModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(EmployeeModel.fromSnapshot(user));
        }

        return users;
      });
}
