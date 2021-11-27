import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: constant_identifier_names

class DepartmentModel {
  static const ID = "id";
  static const NAME = "name";
  static const PHONE = "phone";
  static const EMAIL = "email";
  static const PROJECTID = "projectid";
  static const CREATEDAY = "establishday";

  late String _id;
  late String _name;
  late String _phone;
  late String _email;
  late List _projectid;
  late String _createday;
  String get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  List get projectid => _projectid;
  String get createday => _createday;
  DepartmentModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = (snapshot.data() as dynamic)[NAME];
    _email = (snapshot.data() as dynamic)[EMAIL];
    _id = (snapshot.data() as dynamic)[ID];
    _phone = (snapshot.data() as dynamic)[PHONE];
    _projectid = (snapshot.data() as dynamic)[PROJECTID];
    _createday = (snapshot.data() as dynamic)[CREATEDAY];
  }

}
