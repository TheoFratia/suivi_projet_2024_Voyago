import 'package:flutter/cupertino.dart';

class TypePointOfInterest {
  int id;
  Text type;
  String status;
  DateTime created_at;
  DateTime updated_at;

  TypePointOfInterest({required this.id, required this.status, required this.created_at, required this.updated_at, required this.type});
}