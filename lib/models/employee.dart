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

  late String _id;
  late String _name;
  late String _email;
  late String _address;
  late String _birthday;
  late String _phone;
  late String _gender;
  late String _position;
  String get name => _name;
  String get id => _id;
  String get email => _email;
  String get gender => _gender;
  String get address => _address;
  String get phone => _phone;
  String get birthday => _birthday;
  String get position => _position;

  EmployeeModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = (snapshot.data() as dynamic)[NAME];
    _email = (snapshot.data() as dynamic)[EMAIL];
    _id = (snapshot.data() as dynamic)[ID];
    _address = (snapshot.data() as dynamic)[ADDRESS];
    _phone = (snapshot.data() as dynamic)[PHONE];
    _birthday = (snapshot.data() as dynamic)[BIRTHDAY];
    _position = (snapshot.data() as dynamic)[POSITION];
    _gender = (snapshot.data() as dynamic)[GENDER];
  }
}
