import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: constant_identifier_names
class ProjectModel {
  static const PROJECTID = "id";
  static const NAME = "name";
  static const MANAGERNAME = "manager";
  static const STARTDAY = "start";
  static const ENDDAY = "end";
  static const STATUS = "status";
  static const MEMBER = "members";
  static const DESCRIPTION = "description";
  static const COMPLETE = "complete";

  late String _id;
  late String _name;
  late String _manager;
  late String _startday;
  late String _endday;
  late List _member;
  late String _status;
  late int _complete;
  late String _description;

  String get id => _id;
  String get name => _name;
  String get manager => _manager;
  String get startday => _startday;
  String get endday => _endday;
  List get member => _member;
  String get status => _status;
  int get complete => _complete;
  String get desciption => _description;

  ProjectModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = (snapshot.data() as dynamic)[PROJECTID];
    _name = (snapshot.data() as dynamic)[NAME];
    _manager = (snapshot.data() as dynamic)[MANAGERNAME];
    _startday = (snapshot.data() as dynamic)[STARTDAY];
    _endday = (snapshot.data() as dynamic)[ENDDAY];
    _member = (snapshot.data() as dynamic)[MEMBER];
    _status = (snapshot.data() as dynamic)[STATUS];
    _complete = (snapshot.data() as dynamic)[COMPLETE];
    _description = (snapshot.data() as dynamic)[DESCRIPTION];
  }
}
