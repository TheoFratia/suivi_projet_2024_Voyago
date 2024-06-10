class PointOfInterest {
  int id;
  String description;
  String link;
  int price;
  String type;
  String titre;
  String status;
  String imageLink;
  DateTime createdAt;
  DateTime updatedAt;

  factory PointOfInterest.fromJson(Map<String, dynamic> json) {
    if (json['idIType'] == null || json['idIType'].isEmpty) {
      throw Exception(json['idIType']);
    }
    return PointOfInterest(
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      description: json['description'],
      type: json['idIType'][0]['type'],
      link: json['link'],
      price: json['price'],
      titre: json['titre'],
      imageLink: json['imageLink'],
    );
  }

  PointOfInterest({required this.id, required this.type ,required this.status, required this.createdAt, required this.updatedAt, required this.description, required this.link, required this.price, required this.titre, required this.imageLink});
}


class ListPointOfInterest {
  final List<PointOfInterest> pointOfInterests;

  ListPointOfInterest(this.pointOfInterests);

  factory ListPointOfInterest.fromJson(List<dynamic> json) {
    List<PointOfInterest> pois = [];
    for (var item in json) {
      pois.add(PointOfInterest.fromJson(item as Map<String, dynamic>));
    }
    return ListPointOfInterest(pois);
  }
}