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
      String department,
      String status,
      int complete) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "name": name,
      "manager": managerID,
      "start": startDay,
      "end": endDay,
      "status": status,
      "members": listEmployee,
      "department": department,
      "description": description,
      "complete": complete,
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

  void updateProject(String id, Map<String, dynamic> map) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.update(map);
  }

  Future<List<ProjectModel>> getAllProjectOfManager(String id) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("manager", isEqualTo: id)
          .get()
          .then((result) {
        List<ProjectModel> projects = [];
        for (DocumentSnapshot project in result.docs) {
          projects.add(ProjectModel.fromSnapshot(project));
        }

        return projects;
      });

  void addCompletion(String projectid, num complete) async {
    num currentComplete;
    num increase;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: projectid)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    currentComplete = (doc.data() as dynamic)["complete"];
    increase = currentComplete + complete;
    docref.update(<String, dynamic>{'complete': increase});
  }

  void addMember(String memberID, String projectid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: projectid)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    docref.update({
      'members': FieldValue.arrayUnion([memberID])
    });
  }

  void removeMember(String memberID, String projectid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: projectid)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    docref.update({
      'members': FieldValue.arrayRemove([memberID])
    });
  }

  void removeMemberwithMemberID(String memberID) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    List<QueryDocumentSnapshot> docSnapshots = querySnapshot.docs;
    for (QueryDocumentSnapshot docSnapshot in docSnapshots) {
      DocumentReference docref = docSnapshot.reference;
      docref.update({
        'members': FieldValue.arrayRemove([memberID])
      });
    }
  }

  void deleteProject(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: id)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.delete();
  }

  Future<List<ProjectModel>> getProjectByID(String id) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("id", isEqualTo: id)
          .get()
          .then((result) {
        List<ProjectModel> projects = [];
        for (DocumentSnapshot project in result.docs) {
          projects.add(ProjectModel.fromSnapshot(project));
        }
        return projects;
      });

  Future<ProjectModel> getProjectID(String id) => FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((doc) {
        return ProjectModel.fromSnapshot(doc);
      });
  Future<List<ProjectModel>> getAllProject() async =>
      FirebaseFirestore.instance.collection(collection).get().then((result) {
        List<ProjectModel> projects = [];
        for (DocumentSnapshot project in result.docs) {
          projects.add(ProjectModel.fromSnapshot(project));
        }

        return projects;
      });
}
