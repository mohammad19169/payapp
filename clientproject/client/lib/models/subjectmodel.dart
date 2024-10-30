class SubjectModel {
  final String id;
  final String name;
  final String logo;

  SubjectModel({
    required this.id,
    required this.name,
    required this.logo,
  });
  factory SubjectModel.fromMap(Map<dynamic, dynamic> map) {
    return SubjectModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      logo: map['logo'] ?? "",
    );
  }
}
