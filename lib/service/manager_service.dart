import 'package:advance_employee_management/models/manager.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerServices {
  String collection = "managers";
  void createManager(String id, String name, String email) {
    FirebaseFirestore.instance.collection(collection).doc(id).set({
      "id": id,
      "name": name,
      "email": email,
    });
  }

  Future<String> getManagerName(String email) async {
    String name = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    name = (doc.data() as dynamic)['name'];
    return name;
  }

  Future<ManagerModel> getManagerbyID(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    return ManagerModel.fromSnapshot(doc);
  }

  void deleteManager(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.delete();
  }

  Future<String> getphotoURL(String email) async {
    String photoURL = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    photoURL = (doc.data() as dynamic)['photourl'];
    return photoURL;
  }

  Future<bool> checkExisManager(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();

    List<DocumentSnapshot> doc = querySnapshot.docs;

    return doc.length == 1;
  }

  void updateManager(String email, Map<String, dynamic> map) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.update(map);
  }

  Future<ManagerModel> getManagerByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    return ManagerModel.fromSnapshot(doc);
  }

  void addManager(
    String id,
    String name,
    String gender,
    String birthday,
    String email,
    String address,
    String phone,
    String photourl,
    String position,
    String departmentName,
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
      "department": departmentName,
    });
  }

  Future<String> getManagerIDbyEmail(String email) async {
    String id = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
    DocumentSnapshot doc = querySnapshot.docs[0];
    id = (doc.data() as dynamic)['id'];
    return id;
  }

  Future<ManagerModel> getManagerID(String id) => FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((doc) {
        return ManagerModel.fromSnapshot(doc);
      });

  Future<List<ManagerModel>> getAllManger() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<ManagerModel> managers = [];
        for (DocumentSnapshot manager in result.docs) {
          managers.add(ManagerModel.fromSnapshot(manager));
        }

        return managers;
      });
}
