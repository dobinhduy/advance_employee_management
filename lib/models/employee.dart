// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const GENDER = "gender";
  static const BIRTHDAY = "birthday";
  static const ADDRESS = "address";
  static const PHONE = "phone";
  static const POSITION = "position";
  static const PHOTOURL = "photourl";

  late String _id;
  late String _name;
  late String _email;
  late String _address;
  late String _birthday;
  late String _phone;
  late String _gender;
  late String _position;
  late String _photourl;
  EmployeeModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = (snapshot.data() as dynamic)[NAME];
    _email = (snapshot.data() as dynamic)[EMAIL];
    _id = (snapshot.data() as dynamic)[ID];
    _address = (snapshot.data() as dynamic)[ADDRESS];
    _phone = (snapshot.data() as dynamic)[PHONE];
    _birthday = (snapshot.data() as dynamic)[BIRTHDAY];
    _position = (snapshot.data() as dynamic)[POSITION];
    _gender = (snapshot.data() as dynamic)[GENDER];
    _photourl = (snapshot.data() as dynamic)[PHOTOURL];
  }
  String get address => _address;
  String get birthday => _birthday;
  String get email => _email;
  String get gender => _gender;
  String get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get photourl => _photourl;
  String get position => _position;
}
