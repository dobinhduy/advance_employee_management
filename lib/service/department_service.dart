import 'package:advance_employee_management/models/department.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void removeProject(String departmentName, String projectid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("name", isEqualTo: departmentName)
        .get();
    try {
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference docref = doc.reference;
      docref.update({
        'projectid': FieldValue.arrayRemove([projectid])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> checkExistDepartment(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }

  Future<bool> checkExistDepartmentName(String name) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("name", isEqualTo: name)
        .get();
    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }

  Future<bool> checkUniqueID(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }

  void addProjectID(String departmentName, String projectid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("name", isEqualTo: departmentName)
        .get();
    try {
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference docref = doc.reference;
      docref.update({
        'projectid': FieldValue.arrayUnion([projectid])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteDepartment(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    try {
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference docref = doc.reference;
      await docref.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void updateProject(String id, Map<String, dynamic> map) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    try {
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference docref = doc.reference;

      await docref.update(map);
    } catch (e) {
      print(e.toString());
    }
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
