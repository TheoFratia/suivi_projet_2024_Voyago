class TypePointOfInterest {
  String type;

  factory TypePointOfInterest.fromJson(Map<String, dynamic> json) {
    return TypePointOfInterest(
      type: json['type'],
    );
  }

  TypePointOfInterest({required this.type});
}