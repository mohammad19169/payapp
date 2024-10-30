class ContestModel {
  String id;
  String awards_description;
  String fee;
  String title;
  String awards_image;
  String details;
  String eligibility;
  String att_file;
  String result_date;
    ContestModel({
        required this.id,
        required this.awards_description,
        required this.fee,
        required this.title,
        required this.awards_image,
        required this.details,
        required this.eligibility,
        required this.att_file,
        required this.result_date,
    });



    factory ContestModel.fromMap(Map<dynamic, dynamic> map) {
    return ContestModel(
      id: map['id'] ?? "",
      awards_description: map['awards_description']??"",
      fee: map['fee']??"",
      title: map['title']??"",
      awards_image: map['awards_image']??"",
      details: map['details']??"",
      eligibility: map['eligibility']??"",
      att_file: map['att_file']??"",
      result_date: map['result_date']??""
    );
  }
}
