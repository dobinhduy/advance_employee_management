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

  void addEmployee() {
    FirebaseFirestore.instance.collection(collection).add({
      "id": "xxx",
      "name": "xxx",
      "email": "xxx",
    });
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
