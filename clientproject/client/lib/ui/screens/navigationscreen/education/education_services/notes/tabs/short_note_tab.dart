import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../themes/colors.dart';

// Note model with id, title and file and fromMap
class Note {
  final String title;
  final String pdf;

  Note({
    required this.title,
    required this.pdf,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    print(json);
    return Note(
      title: json['title'],
      pdf: json['video'],
    );
  }
}

class ShortNotesTab extends StatelessWidget {
  const ShortNotesTab({super.key, required this.chapterId});

  final String chapterId;

  // Fetch notes from api endpoint education/notes/subject/subjectId with bearer token from shared preferences using http library

  // Function to get the token from shared preferences
  static Future<String> getApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  //Print user token if available and if not print not available
  printToken() async {
    await getApiToken().then((value) {
      if (value != "") {
        print("Token is available : $value");
      } else {
        print("Token is not available");
      }
    });
  }

  // Function to fetch notes from api endpoint education/notes/subject/subjectId
  static Future<List<Note>> fetchNotes({required String chapterId}) async {
    String userToken = await getApiToken();
    final response = await http.get(
      Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/education/note/chapter/$chapterId'),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );
    print("Hello");
    if (response.statusCode == 200) {
      final List<dynamic> notes = json.decode(response.body)["data"];
      return notes.map((json) => Note.fromJson(json["note"][0])).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchNotes(chapterId: chapterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final notes = snapshot.data as List<Note>;
          return GridView.builder(
            itemBuilder: (context, index) => buildNotesContainer(
                onTap: () {},
                note: notes[index].title,
                context: context,
                pdfUrl: notes[index].pdf),
            itemCount: notes.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: (1 / 1.84),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        }
      },
    );
    // return GridView.builder(
    //   itemBuilder: (context, index) =>
    //       buildNotesContainer(onTap: () {}, note: notes[index]),
    //   itemCount: 10,
    //   scrollDirection: Axis.vertical,
    //   shrinkWrap: true,
    //   physics: const BouncingScrollPhysics(),
    //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: (1 / 1.64),
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //   ),
    // );
  }
}

InkWell buildNotesContainer(
    {required VoidCallback onTap,
    required String note,
    required String pdfUrl,
    required BuildContext context}) {
  return InkWell(
    // onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: const Color(0xffBBDEFB),
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            child: Image.asset(
              'assets/logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ThemeColors.darkBlueColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          Center(
            child: OutlinedButton.icon(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                side: WidgetStateProperty.all(
                  const BorderSide(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              onPressed: () {
                print("Launching url");
                launchUrl(Uri.parse(pdfUrl));
              },
              icon: const Icon(
                Iconsax.document_download,
              ),
              label: const Text('Download'),
            ),
          ),
          //  const SizedBox(height: 5),
        ],
      ),
    ),
  );
}
