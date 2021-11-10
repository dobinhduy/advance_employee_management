import 'package:advance_employee_management/models/manager.dart';
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

  void updateManager(Map<String, dynamic> values) {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(values['id'])
        .update(values);
  }

  void addManager(
      String id,
      String name,
      String birthday,
      String phone,
      String address,
      String position,
      String email,
      String gender,
      String photourl) {
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
