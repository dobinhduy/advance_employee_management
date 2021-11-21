import 'package:advance_employee_management/models/department.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DepartmentService {
  String collection = "departments";

  void addDepartment(String id, String name, String email, String phone,
      List projectid, String createday) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "projectid": projectid,
      "createday": createday,
    });
  }

  Future<bool> checkExistDepartment(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }

  Future<List<String>> getAllDepartmentName() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<String> departmentName = [];
        for (var department in result.docs) {
          departmentName.add((department.data() as dynamic)['name']);
        }

        return departmentName;
      });

  Future<List<DepartmentModel>> getAllDepartment() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<DepartmentModel> departments = [];
        for (DocumentSnapshot department in result.docs) {
          departments.add(DepartmentModel.fromSnapshot(department));
        }

        return departments;
      });
}
