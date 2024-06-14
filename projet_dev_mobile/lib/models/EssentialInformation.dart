class EssentialInformation {
  final int id;
  final String titre;
  final String description;
  final String imageLink;

  EssentialInformation({
    required this.id,
    required this.titre,
    required this.description,
    required this.imageLink,
  });

  factory EssentialInformation.fromJson(Map<String, dynamic> json) {
    return EssentialInformation(
      id: json['id'],
      titre: json['title'],
      description: json['description'],
      imageLink: json['imagesLink'],
    );
  }
}
