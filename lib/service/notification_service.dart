import 'package:advance_employee_management/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  String collection = "notifications";

  void createNotification(
      String id,
      String projectname,
      String senderID,
      String sendername,
      String receiverID,
      int sendDay,
      bool isread,
      String type) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "projectname": projectname,
      "senderid": senderID,
      "sendername": sendername,
      "receiverid": receiverID,
      "sendday": sendDay,
      "isread": isread,
      "type": type
    });
  }

  void createNewTask(String id, String projectname, String receiverID,
      int sendDay, bool isread, int percent, String description, String type) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "projectname": projectname,
      "receiverid": receiverID,
      "sendday": sendDay,
      "isread": isread,
      "description": description,
      "percent": percent,
      "type": type
    });
  }

  void updateStatus(String notificationid, bool status) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: notificationid)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;

    await docref.update(<String, dynamic>{
      "isread": status,
    });
  }

  void deleteNotification(String notificationid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("id", isEqualTo: notificationid)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docref = doc.reference;
    await docref.delete();
  }

  Future<List<NotificationModel>> getNotificationAssignTask(
          String employeeid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("receiverid", isEqualTo: employeeid)
          .where("type", isEqualTo: "ASSIGNTASK")
          .orderBy("sendday")
          .limitToLast(2)
          .get()
          .then((result) {
        List<NotificationModel> notifies = [];
        for (DocumentSnapshot notify in result.docs) {
          notifies.add(NotificationModel.fromSnapshot(notify));
        }
        return notifies;
      });
  Future<List<NotificationModel>> getNotificationAddProject(
          String employeeid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("receiverid", isEqualTo: employeeid)
          .where("type", isEqualTo: "ADDPROJECT")
          .orderBy("sendday")
          .get()
          .then((result) {
        List<NotificationModel> notifies = [];
        for (DocumentSnapshot notify in result.docs) {
          notifies.add(NotificationModel.fromSnapshot(notify));
        }
        return notifies;
      });
}
