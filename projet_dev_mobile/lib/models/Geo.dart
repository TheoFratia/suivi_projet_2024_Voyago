import 'package:flutter/cupertino.dart';
import 'PointOfInterest.dart';

class Geo {
  int id;
  String city;
  String country;
  String address;
  Text latitude;
  Text longitude;
  String status;
  DateTime created_at;
  DateTime updated_at;
  PointOfInterest? pointOfInterest;
  String? zipCode;

  Geo({required this.id, required this.city, required this.country, required this.address, required this.latitude, required this.longitude, required this.status, required this.created_at, required this.updated_at, this.pointOfInterest, this.zipCode});
}