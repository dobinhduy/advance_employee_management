import 'package:advance_employee_management/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectService {
  String collection = "projects";

  void createProject(
      String id,
      String name,
      String managerID,
      String startDay,
      String endDay,
      String description,
      List<String> listEmployee,
      String status) {
    FirebaseFirestore.instance.collection(collection).doc(id).set({
      "id": id,
      "name": name,
      "managerid": managerID,
      "startday": startDay,
      "endday": endDay,
      "employees": listEmployee,
      "description": description,
      "status": status,
    });
  }

  void updateStatus(String projectID, String status) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: projectID)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.update(<String, dynamic>{
      "status": status,
    });
  }

  Future<ProjectModel> getProjectID(String id) => FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((doc) {
        return ProjectModel.fromSnapshot(doc);
      });
  Future<List<ProjectModel>> getAllproject() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<ProjectModel> projects = [];
        for (DocumentSnapshot project in result.docs) {
          projects.add(ProjectModel.fromSnapshot(project));
        }

        return projects;
      });
}
