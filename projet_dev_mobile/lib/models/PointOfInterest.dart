import 'package:flutter/cupertino.dart';
import 'TypePointOfInterest.dart';

class PointOfInterest {
  int id;
  Text description;
  String link;
  double price;
  TypePointOfInterest type;
  String titre;
  String status;
  DateTime created_at;
  DateTime updated_at;

  PointOfInterest({required this.id, required this.status, required this.created_at, required this.updated_at, required this.description, required this.link, required this.price, required this.type, required this.titre});
}