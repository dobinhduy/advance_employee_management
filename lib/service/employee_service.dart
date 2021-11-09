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

  void updateEmployee(Map<String, dynamic> values) {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(values['id'])
        .update(values);
  }

  void addEmployee(String id, String name, String birthday, String phone,
      String address, String position, String email, String gender) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "name": name,
      "email": email,
      "birthday": birthday,
      "address": address,
      "phone": phone,
      "position": position,
      "gender": gender,
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
