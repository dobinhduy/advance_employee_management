import 'package:advance_employee_management/models/department.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentService {
  String collection = "departments";

  void addDepartment(
      String id, String name, String email, String phone, List projectid) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "projectid": projectid
    });
  }

  Future<List<DepartmentModel>> getAllDepartment() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<DepartmentModel> departments = [];
        for (DocumentSnapshot department in result.docs) {
          departments.add(DepartmentModel.fromSnapshot(department));
        }

        return departments;
      });
}
