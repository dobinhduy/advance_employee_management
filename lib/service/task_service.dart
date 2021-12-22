import 'package:advance_employee_management/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  String collection = "tasks";

  void createTask(
      String id,
      String projectid,
      String deadline,
      String memberID,
      String description,
      int assignday,
      String status,
      int percent,
      String answer,
      String file) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "projectid": projectid,
      "assignday": assignday,
      "deadline": deadline,
      "memberid": memberID,
      "description": description,
      "status": status,
      "percent": percent,
      "answer": answer,
      "file": file,
    });
  }

  Future<num> getComplete(String projectid) async => FirebaseFirestore.instance
          .collection(collection)
          .where("projectid", isEqualTo: projectid)
          .get()
          .then((value) {
        num percent = 0;
        for (DocumentSnapshot element in value.docs) {
          percent += (element.data() as dynamic)["percent"];
        }
        return percent;
      });

  void removeAllTasknwithMemberID(String memberID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("memberid", isEqualTo: memberID)
        .get();
    List<QueryDocumentSnapshot> docSnapshots = querySnapshot.docs;
    for (QueryDocumentSnapshot docSnapshot in docSnapshots) {
      DocumentReference docref = docSnapshot.reference;
      await docref.delete();
    }
  }

  void updateStatus(String taskID, String status) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: taskID)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    docref.update({'status': status});
  }

  void updateAnswer(String taskID, String answer) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: taskID)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    docref.update({'answer': answer});
  }

  void updateFilePath(String taskID, String path) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: taskID)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    docref.update({'file': path});
  }

  Future<List<TaskModel>> getAllTask(String projectid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("projectid", isEqualTo: projectid)
          .orderBy("assignday")
          .get()
          .then((result) {
        List<TaskModel> tasks = [];
        for (DocumentSnapshot task in result.docs) {
          tasks.add(TaskModel.fromSnapshot(task));
        }
        return tasks;
      });

  Future<List<TaskModel>> getAllTaskOfEmployee(
          String projectid, String employeeid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("projectid", isEqualTo: projectid)
          .where("memberid", isEqualTo: employeeid)
          .orderBy("assignday")
          .get()
          .then((result) {
        List<TaskModel> tasks = [];
        for (DocumentSnapshot task in result.docs) {
          tasks.add(TaskModel.fromSnapshot(task));
        }
        return tasks;
      });
}
