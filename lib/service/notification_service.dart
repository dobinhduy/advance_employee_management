import 'package:advance_employee_management/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  String collection = "notifications";

  void createNotification(String id, String senderID, String receiverID,
      int sendDay, bool isread, String message) {
    FirebaseFirestore.instance.collection(collection).add({
      "id": id,
      "senderid": senderID,
      "receiverid": receiverID,
      "sendday": sendDay,
      "isread": isread,
      "message": message
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

  void removeNotificationwithMemberID(String memberID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("receiverid", isEqualTo: memberID)
        .get();
    List<QueryDocumentSnapshot> docSnapshots = querySnapshot.docs;
    for (QueryDocumentSnapshot docSnapshot in docSnapshots) {
      DocumentReference docref = docSnapshot.reference;
      await docref.delete();
    }
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

  Future<List<NotificationModel>> getAllNotification(String employeeid) async =>
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
  Future<int> getNumNotification(String employeeid) async =>
      FirebaseFirestore.instance
          .collection(collection)
          .where("receiverid", isEqualTo: employeeid)
          .get()
          .then((result) {
        int value = 0;
        for (DocumentSnapshot notify in result.docs) {
          if ((notify.data() as dynamic)["isread"] == false) {
            value += 1;
          }
        }
        return value;
      });
}
