// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  static const ID = "id";
  static const PROJECTNAME = "projectname";
  static const SENDERID = "senderid";
  static const SENDERNAME = "sendername";
  static const RECEIVERID = "receiverid";
  static const SENDDATE = "sendday";
  static const ISREAD = "isread";

  late String _id;
  late String _senderid;
  late String _sendername;
  late String _receiverid;
  late String _sendday;
  late bool _isread;
  late String _projectname;

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = (snapshot.data() as dynamic)[ID];
    _senderid = (snapshot.data() as dynamic)[SENDERID];
    _sendername = (snapshot.data() as dynamic)[SENDERNAME];
    _receiverid = (snapshot.data() as dynamic)[RECEIVERID];
    _sendday = (snapshot.data() as dynamic)[SENDDATE];
    _isread = (snapshot.data() as dynamic)[ISREAD];
    _projectname = (snapshot.data() as dynamic)[PROJECTNAME];
  }
  String get id => _id;
  String get senderid => _senderid;
  String get sendername => _sendername;
  String get receiverID => _receiverid;
  String get sendday => _sendday;
  bool get isread => _isread;
  String get projectname => _projectname;
}
