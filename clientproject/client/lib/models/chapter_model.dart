// ignore_for_file: non_constant_identifier_names

class ChapterModel {
  String id;
  String chapter_name;
  String subject_name;
  String subject_id;
    ChapterModel({
        required this.id,
        required this.chapter_name,
        required this.subject_name,
        required this.subject_id,
    });



    factory ChapterModel.fromMap(Map<dynamic, dynamic> map) {
    return ChapterModel(
      id: map['id'] ?? "",
      chapter_name: map['chapter_name']??"",
      subject_name: map['subject_name']??"",
      subject_id: map['subject_id']??"",
    );
  }
}
