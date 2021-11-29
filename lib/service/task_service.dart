import 'package:advance_employee_management/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  String collection = "tasks";

  void createTask(String id, String projectid, String deadline, String memberID,
      String description, int assignday, String status) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "projectid": projectid,
      "assignday": assignday,
      "deadline": deadline,
      "memberid": memberID,
      "description": description,
      "status": status
    });
  }

  Future<List<TaskModel>> getAllTask(
          String projectid, String employeeid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("projectid", isEqualTo: projectid)
          .where("memberid", isEqualTo: employeeid)
          .get()
          .then((result) {
        List<TaskModel> tasks = [];
        for (DocumentSnapshot task in result.docs) {
          tasks.add(TaskModel.fromSnapshot(task));
        }
        return tasks;
      });
}
