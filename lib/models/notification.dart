// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  static const ID = "id";
  static const MESSAGE = "message";
  static const SENDERID = "senderid";
  static const RECEIVERID = "receiverid";
  static const SENDDATE = "sendday";
  static const ISREAD = "isread";

  late String _id;
  late String _senderid;
  late String _message;
  late String _receiverid;
  late int _sendday;
  late bool _isread;

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = (snapshot.data() as dynamic)[ID];
    _senderid = (snapshot.data() as dynamic)[SENDERID];
    _message = (snapshot.data() as dynamic)[MESSAGE];
    _receiverid = (snapshot.data() as dynamic)[RECEIVERID];
    _sendday = (snapshot.data() as dynamic)[SENDDATE];
    _isread = (snapshot.data() as dynamic)[ISREAD];
  }
  String get id => _id;
  String get senderid => _senderid;
  String get message => _message;
  String get receiverID => _receiverid;
  int get sendday => _sendday;
  bool get isread => _isread;

  set setisread(bool value) {
    _isread = value;
  }
}
