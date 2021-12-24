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
    await docref.update(<String, dynamic>{
      "name": map.values.elementAt(0),
      "gender": map.values.elementAt(1),
      "birthday": map.values.elementAt(2),
      "email": map.values.elementAt(3),
      "address": map.values.elementAt(4),
      "phone": map.values.elementAt(5),
      "role": map.values.elementAt(6),
      "department": map.values.elementAt(7),
      "supervisorid": map.values.elementAt(8)
    });
  }

  void updateEmployeeManager(String email, Map<String, dynamic> map) async {
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
    try {
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference docref = doc.reference;

      await docref.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getphotoURL(String email) async {
    String photoURL = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    try {
      DocumentSnapshot doc = querySnapshot.docs[0];
      photoURL = (doc.data() as dynamic)['photourl'];
    } catch (e) {
      print(e.toString());
    }
    return photoURL;
  }

  Future<String> getDepartmentName(String email) async {
    String departmentName = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    try {
      DocumentSnapshot doc = querySnapshot.docs[0];
      departmentName = (doc.data() as dynamic)['department'];
    } catch (e) {
      print(e.toString());
    }
    return departmentName;
  }

  Future<String> getEmployeeName(String email) async {
    String name = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    try {
      DocumentSnapshot doc = querySnapshot.docs[0];
      name = (doc.data() as dynamic)['name'];
    } catch (e) {
      print(e.toString());
    }
    return name;
  }

  Future<String> getEmployeeIDbyEmail(String email) async {
    String id = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    try {
      DocumentSnapshot doc = querySnapshot.docs[0];
      id = (doc.data() as dynamic)['id'];
    } catch (e) {
      print(e.toString());
    }
    return id;
  }

  Future<String> getEmployeeNamebyID(String id) async {
    String name = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    try {
      DocumentSnapshot doc = querySnapshot.docs[0];
      name = (doc.data() as dynamic)['name'];
    } catch (e) {
      print(e.toString());
    }
    return name;
  }

  Future<bool> checkExistEmployee(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
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

  Future<bool> checkhasEmployee(String id) async => FirebaseFirestore.instance
          .collection(collection)
          .where("supervisorid", isEqualTo: id)
          .get()
          .then((result) {
        List<EmployeeModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          if ((user.data() as dynamic)["id"] != id) {
            users.add(EmployeeModel.fromSnapshot(user));
          }
        }

        return users.isNotEmpty;
      });

  Future<bool> checkExistEmployeebyID(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }

  Future<String> getSupervisorID(String id) async {
    String supervisorID = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    try {
      DocumentSnapshot doc = querySnapshot.docs[0];
      supervisorID = (doc.data() as dynamic)['supervisorid'];
    } catch (e) {
      print(e.toString());
    }
    return supervisorID;
  }

  Future<EmployeeModel> getEmployeebyEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    return EmployeeModel.fromSnapshot(doc);
  }

  Future<EmployeeModel> getEmployeebyID(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    return EmployeeModel.fromSnapshot(doc);
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
    String role,
    String department,
    String supervisorid,
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
      "role": role,
      "department": department,
      "supervisorid": supervisorid,
    });
  }

  Future<List<EmployeeModel>> getAllEmployee() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<EmployeeModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(EmployeeModel.fromSnapshot(user));
        }

        return users;
      });

  Future<List<EmployeeModel>> getAllEmployeeOfSupervisor(
          String employeeID, String supervisorid) =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("supervisorid", isEqualTo: employeeID)
          .get()
          .then((value) {
        List<EmployeeModel> employees = [];
        for (DocumentSnapshot employee in value.docs) {
          employees.add(EmployeeModel.fromSnapshot(employee));
        }
        return employees;
      });

  Future<List<EmployeeModel>> getAllEmployeeOfManager(String id) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("supervisorid", isEqualTo: id)
          .get()
          .then((result) {
        List<EmployeeModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          if ((user.data() as dynamic)["id"] != id) {
            users.add(EmployeeModel.fromSnapshot(user));
          }
        }

        return users;
      });
  Future<List<EmployeeModel>> getAllEmployeeOfManagerName(String id) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("supervisorid", isEqualTo: id)
          .get()
          .then((result) {
        List<EmployeeModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(EmployeeModel.fromSnapshot(user));
        }

        return users;
      });
}
