import 'package:flutter/material.dart';
import 'package:payapp/services/apis/remote_services/remote_student_services/student_services.dart';

import '../../../models/chapter_model.dart';
import '../../../models/notesmodel.dart';
import '../../../models/subjectmodel.dart';

class StudentNotesProvider extends ChangeNotifier {
  bool isLoadingNotes = false;
  bool isLoadingChapters = false;
  bool isLoadingSubjects = false;

  List<NotesModel> notesList = [];
  List<ChapterModel> chapterList = [];
  List<SubjectModel> subjectsList = [];

  Future<List<SubjectModel>> getSubjects({required String classId}) async {
    isLoadingSubjects = true;
    var t = await RemoteStudentServices.fetchStudentsSubjects(classId: classId);
    subjectsList =
        await RemoteStudentServices.fetchStudentsSubjects(classId: classId);
    isLoadingSubjects = false;
    notifyListeners();
    return subjectsList;
  }

  Future<List<NotesModel>> getNotes(
      {required String subjectId, required String userId}) async {
    isLoadingNotes = true;
    notesList = await RemoteStudentServices.fetchStudentNotes(
      userId: userId,
      subjectId: subjectId,
    );
    isLoadingNotes = false;

    notifyListeners();
    return notesList;
  }
}
