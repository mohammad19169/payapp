// ignore_for_file: non_constant_identifier_names

import '../config/apiconfig.dart';

class NotesModel {
  String id;
  String chapter_name;
  String class_name;
  String subject_name;
  String pdf_file;
  String fileName;
    NotesModel({
        required this.id,
        required this.chapter_name,
        required this.class_name,
        required this.subject_name,
        required this.pdf_file,
      required this.fileName
    });



    factory NotesModel.fromMap(Map<dynamic, dynamic> map) {
    return NotesModel(
      id: map['id'] ?? "",
      chapter_name: map['chapter_name']??"",
      class_name: map['class_name']??"",
      subject_name: map['subject_name']??"",
      pdf_file: "${Constants.forImg}/${ map['pdf_file']??""}",
      fileName: (map['pdf_file']??"").toString().split("/").last
    );
  }
}
