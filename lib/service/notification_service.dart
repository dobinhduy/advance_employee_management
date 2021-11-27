import 'package:advance_employee_management/models/notification.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  String collection = "notifications";

  void createNotification(String id, String projectname, String senderID,
      String sendername, String receiverID, int sendDay, bool isread) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "projectname": projectname,
      "senderid": senderID,
      "sendername": sendername,
      "receiverid": receiverID,
      "sendday": sendDay,
      "isread": isread,
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
      "isreead": status,
    });
  }

  Future<List<NotificationModel>> getNotificationbyemployeeID(
          String employeeid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("receiverid", isEqualTo: employeeid)
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
