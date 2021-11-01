// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  late String _id;
  late String _name;
  late String _email;
  String get name => _name;
  String get id => _id;
  String get email => _email;
  ManagerModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = (snapshot.data() as dynamic)[NAME];
    _email = (snapshot.data() as dynamic)[EMAIL];
    _id = (snapshot.data() as dynamic)[ID];
  }
}
