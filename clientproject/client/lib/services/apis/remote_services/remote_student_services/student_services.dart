import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payapp/config/apiconfig.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/notesmodel.dart';
import '../../../../models/subjectmodel.dart';

class RemoteStudentServices {
  static String basicAuth =
      'Basic ${base64.encode(utf8.encode('mygromoapp:SacPass112233'))}';

  static http.Client client = http.Client();

  static String AmrToken = "";

  // Function to get the token from shared preferences
  static Future<void> getApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AmrToken = prefs.getString('auth-token') ?? '';
  }

  //Print user token if available and if not print not available

  static Future<void> printToken() async {
    await getApiToken();
    if (AmrToken != "") {
      print("Token is available : $AmrToken");
    } else {
      print("Token is not available");
    }
  }

  static Map<String, String>? headers = {
    'Authorization': 'Bearer $loginToken',
    "Cookies": "token=$loginToken",
    "Accept": "application/json"
  };
  static Map<String, String>? postHeaders = {
    'Authorization': 'Bearer $AmrToken',
    "Cookies": "token=$AmrToken",
    "Accept": "application/json"
  };

  static Future<dynamic> fetchStudentsSubjects(
      {required String classId}) async {
    final Uri url = Uri.parse(Constants.getSubjects + classId);
    printToken();
    final http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $AmrToken',
      "Cookies": "token=$AmrToken",
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      final source = response.body;

      var responseData = jsonDecode(source);
      final subjects = responseData["data"] as List;
      return subjects.map((subject) => SubjectModel.fromMap(subject)).toList();
    } else {
      return [];
    }
  }

  static Future<dynamic> fetchStudentNotes(
      {required String userId, required String subjectId}) async {
    Uri url = Uri.parse(Constants.notesList);
    // to get notes, you have to send body with the user_id & subject_id,

    Map<String, dynamic> body = {
      "user_id": userId,
      "subject_id": subjectId,
      "list": "notes"
    };

    final http.Response response =
        await client.post(url, headers: postHeaders, body: body);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData["status"] != false) {
        final List<dynamic> notes = responseData["data"] as List;
        return notes.map((e) => NotesModel.fromMap(e)).toList();
      } else {
        return responseData["status"];
      }
    } else {
      return;
    }
  }
}
