import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: constant_identifier_names
class TaskModel {
  static const ID = "id";
  static const PROJECTID = "projectid";
  static const MEMBERID = "memberid";
  static const ASSIGNDAY = "assignday";
  static const STATUS = "status";
  static const DEADLINE = "deadline";
  static const DESCRIPTION = "description";
  static const PERCENT = "percent";
  static const ANSWER = "answer";
  static const FILE = "file";
  late String _id;
  late String _projectid;
  late String _memberid;
  late int _assignday;
  late String _status;
  late String _deadline;
  late String _description;
  late int _percent;
  late String _answer;
  late String _file;
  String get id => _id;
  String get projectid => _projectid;
  String get memberid => _memberid;
  int get assignday => _assignday;
  String get status => _status;
  String get deadline => _deadline;
  String get description => _description;
  String get answer => _answer;
  num get percent => _percent;
  String get file => _file;
  TaskModel(
      String id,
      String projectid,
      String memberid,
      int assignday,
      String status,
      String deadline,
      String description,
      int percent,
      String answer,
      String file) {
    _id = id;
    _projectid = projectid;
    _memberid = memberid;
    _assignday = assignday;
    _status = status;
    _deadline = deadline;
    _description = description;
    _percent = percent;
    _answer = answer;
    _file = file;
  }

  TaskModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = (snapshot.data() as dynamic)[ID];
    _projectid = (snapshot.data() as dynamic)[PROJECTID];
    _status = (snapshot.data() as dynamic)[STATUS];
    _memberid = (snapshot.data() as dynamic)[MEMBERID];
    _assignday = (snapshot.data() as dynamic)[ASSIGNDAY];
    _deadline = (snapshot.data() as dynamic)[DEADLINE];
    _description = (snapshot.data() as dynamic)[DESCRIPTION];
    _percent = (snapshot.data() as dynamic)[PERCENT];
    _answer = (snapshot.data() as dynamic)[ANSWER];
    _file = (snapshot.data() as dynamic)[FILE];
  }
}
