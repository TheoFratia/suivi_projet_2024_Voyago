import 'PointOfInterest.dart';
import 'User.dart';

class Location {
  final int id;
  final List<PointOfInterest> idPointOfInterest;
  final String status;
  final List<User> userId;
  final String name;
  final int totalPrice;

  Location({
    required this.id,
    required this.idPointOfInterest,
    required this.status,
    required this.userId,
    required this.name,
    required this.totalPrice,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    var idPointOfInterestJson = json['idPointOfInterest'] as List;
    List<PointOfInterest> idPointOfInterestList = idPointOfInterestJson.map((i) => PointOfInterest.fromJson(i)).toList();

    var userIdJson = json['UserId'] as List;
    List<User> userIdList = userIdJson.map((i) => User.fromJson(i)).toList();

    return Location(
      id: json['id'],
      idPointOfInterest: idPointOfInterestList,
      status: json['status'],
      userId: userIdList,
      name: json['name'],
      totalPrice: json['totalPrice'],
    );
  }
}