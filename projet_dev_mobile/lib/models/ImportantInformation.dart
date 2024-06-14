class ImportantInformation {
  final int id;
  final String titre;
  final String description;
  final String imageLink;

  ImportantInformation({
    required this.id,
    required this.titre,
    required this.description,
    required this.imageLink,
  });

  factory ImportantInformation.fromJson(Map<String, dynamic> json) {
    return ImportantInformation(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      imageLink: json['imageLink'],
    );
  }
}
