
class ScholarshipModel {
    ScholarshipModel({
        required this.id,
        required this.title,
        required this.description,
        required this.banner,
        required this.eligibility,
        required this.benefits,
        required this.result_on,
        required this.last_date,
    });

    String id;
    String title;
    String description;
    String banner;
    String eligibility;
    String benefits;
    String result_on;
    String last_date;

    factory ScholarshipModel.fromMap(Map<dynamic, dynamic> map) {
    return ScholarshipModel(
      id: map['id'] ?? "",
      title: map['title']??"",
      description: map['description']??"",
      banner: map['banner']??"",
      eligibility: map['eligibility']??"",
      benefits: map['benefits']??"",
      result_on: map['result_on']??"",
      last_date: map['last_date']??"",
    );
  }
}
