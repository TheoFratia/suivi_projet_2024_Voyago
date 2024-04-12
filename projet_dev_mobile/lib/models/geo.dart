import 'package:projet_dev_mobile/models/PointOfInterest.dart';

class Geo {
  int id;
  String city;
  String country;
  String address;
  String latitude;
  String longitude;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  ListPointOfInterest? pointOfInterest;
  String? zipCode;

  Geo({required this.id, required this.city, required this.country, required this.address, required this.latitude, required this.longitude, required this.status, required this.createdAt, required this.updatedAt, this.pointOfInterest, this.zipCode});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      id: json['id'],
      city: json['city'],
      country: json['country'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pointOfInterest: json['pointOfInterests'] != null ? ListPointOfInterest.fromJson(json['pointOfInterests']) : null,
      zipCode: json['zipCode'],
    );
  }

}