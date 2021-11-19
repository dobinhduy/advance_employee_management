// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  static const ID = "id";
  static const SENDERID = "senderid";
  static const RECEIVERID = "receiverid";
  static const SENDDATE = "sendday";
  static const ISREAD = "isread";

  late String _id;
  late String _senderid;
  late String _receiverid;
  late String _sendday;
  late bool _isread;

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = (snapshot.data() as dynamic)[ID];
    _senderid = (snapshot.data() as dynamic)[SENDERID];
    _receiverid = (snapshot.data() as dynamic)[RECEIVERID];
    _sendday = (snapshot.data() as dynamic)[SENDDATE];
    _isread = (snapshot.data() as dynamic)[ISREAD];
  }
  String get address => _id;
  String get birthday => _senderid;
  String get email => _receiverid;
  String get gender => _sendday;
  bool get id => _isread;
}
