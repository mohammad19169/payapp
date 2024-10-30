import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/notes/notes_main_screen.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectChapterScreen extends StatefulWidget {
  const SelectChapterScreen(
      {super.key,
      required this.subject,
      required this.classNumber,
      required this.subjectId});

  final String subject;

  final String subjectId;
  final String classNumber;

  @override
  State<SelectChapterScreen> createState() => _SelectChapterScreenState();
}

class _SelectChapterScreenState extends State<SelectChapterScreen> {
  // fetch chapters from api endpoint education/chapter/subject/SubjectId with bearer token from shared preferences using http library

  static String AmrToken = "";

  // Function to get the token from shared preferences
  static Future<void> getApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AmrToken = prefs.getString('token') ?? '';
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
    'Authorization': 'Bearer $AmrToken',
    "Cookies": "token=$AmrToken",
    "Accept": "application/json"
  };
  static Future<List<Chapter>> fetchSubjectsChapters(
      {required String subjectId}) async {
    //print subject id
    print("Our subject id is $subjectId");
    getApiToken();
    final Uri url = Uri.parse(
        "https://xyzabc.sambhavapps.com/v1/education/chapter/subject/$subjectId");

    print({
      'Authorization': 'Bearer $AmrToken',
      "Cookies": "token=$AmrToken",
      "Accept": "application/json"
    });
    final http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $AmrToken',
      "Cookies": "token=$AmrToken",
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      final source = response.body;

      var responseData = jsonDecode(source);
      print("Our response data");
      print(responseData["data"]);
      final chapters = responseData["data"] as List;
      return chapters.map((chapter) => Chapter.fromMap(chapter)).toList();
    } else {
      // Print respose status code and body
      print("Response status code is ${response.statusCode}");
      print("Response body is ${response.body}");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: widget.subject, size: 55),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                elevation: WidgetStateProperty.all(1),
                hintText: 'Search for a specific chapter',
                hintStyle: WidgetStateProperty.all(
                  const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                leading: Lottie.asset(
                  'assets/lottie/search_icon.json',
                  height: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Chapter ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ThemeColors.darkBlueColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: fetchSubjectsChapters(subjectId: widget.subjectId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'An error occurred. Please try again later.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final chapters = snapshot.data as List<Chapter>;
                  if (chapters.isEmpty) {
                    return const Center(
                      child: Text(
                        'No chapters available for this subject.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemBuilder: (context, index) => buildChapterContainer(
                      index: index,
                      chapter: chapters[index],
                      onTap: () => RouteConfig.navigateToRTL(
                        context,
                        NotesMainScreen(
                          classNumber: widget.classNumber,
                          subject: widget.subject,
                          chapter: chapters[index].name,
                          chapterId: chapters[index].id,

                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: chapters.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildChapterContainer(
      {required VoidCallback onTap,
      required Chapter chapter,
      required int index}) {
    index++;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: Color(Colors.white.value),
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(chapter.logo),
                  fit: BoxFit.cover,
                ),
              ),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                '$index',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ThemeColors.darkBlueColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ThemeColors.darkBlueColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const Text(
                  //   '32 notes',
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 14.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: const Icon(
                Icons.double_arrow_outlined,
                color: ThemeColors.primaryBlueColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Create a chapter model with a fromMap
class Chapter {
  final String name;
  final String id;

  final String logo;

  Chapter({
    required this.name,
    required this.id,
    required this.logo,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      name: map['name'],
      id: map['id'],
      logo: map['logo'],
    );
  }
}
