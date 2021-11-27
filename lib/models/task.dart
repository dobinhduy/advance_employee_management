import 'package:advance_employee_management/models/employee.dart';
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
  late String _id;
  late String _projectid;
  late String _memberid;
  late int _assignday;
  late String _status;
  late int _deadline;
  late String _description;
  String get id => _id;
  String get projectid => _projectid;
  String get memberid => _memberid;
  int get assignday => _assignday;
  String get status => _status;
  int get deadline => _deadline;
  String get description => _description;
  TaskModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = (snapshot.data() as dynamic)[ID];
    _projectid = (snapshot.data() as dynamic)[ID];
    _status = (snapshot.data() as dynamic)[STATUS];
    _memberid = (snapshot.data() as dynamic)[MEMBERID];
    _assignday = (snapshot.data() as dynamic)[ASSIGNDAY];
    _deadline = (snapshot.data() as dynamic)[DEADLINE];
    _description = (snapshot.data() as dynamic)[DESCRIPTION];
  }
}
