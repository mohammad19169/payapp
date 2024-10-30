import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:payapp/ui/screens/navigationscreen/education/job_services/screens/preferences_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../themes/colors.dart';
import 'build_resume_screen.dart';

// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExperienceScreen extends StatefulWidget {
  final ResumeData resumeData;

  const ExperienceScreen({super.key, required this.resumeData});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  List<Course> degreeCourses = [];
  List<Course> _filteredCourses = [];
  Course? _selectedCourse;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
          Uri.parse('https://xyzabc.sambhavapps.com/v1/job/p1/qualification'),
          headers: {
            'Authorization': 'Bearer $token',
          });
      var data = jsonDecode(response.body)["data"];
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          degreeCourses =
              List<Course>.from(data.map((model) => Course.fromJson(model)));
          _filteredCourses = List.from(degreeCourses);
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Courses',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _filteredCourses = degreeCourses.where((course) {
                      return course.name
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredCourses[index].name),
                    onTap: () {
                      _courseController.text = _filteredCourses[index].name;
                      setState(() {
                        _selectedCourse = _filteredCourses[index];
                      });
                      // You might want to store selected course ID somewhere
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor:
                  WidgetStateProperty.all(ThemeColors.darkBlueColor),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.blue)),
              ),
              textStyle: WidgetStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16), // Set text style
              ),
            ),
            child: const Text(
              '        BACK      ',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            )),
        const SizedBox(
          width: 20,
        ),
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => JobPreferencesScreen(
                  resumeData: widget.resumeData,
                  selectedCourse: _selectedCourse!,
                ),
              ));
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.blue)),
              ),
              textStyle: WidgetStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16), // Set text style
              ),
            ),
            child: const Text(
              '        NEXT      ',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ))
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 80,
                color: ThemeColors.primaryBlueColor,
                child: StepProgressIndicator()),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey,
              child: const Text(
                "Providing your education details can give employers a better understanding of your strengths as a candidate",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "What's your highest job qualification ?",
              style: TextStyle(
                  color: ThemeColors.darkBlueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => _showBottomSheet(context),
                // Show bottom sheet on tap
                child: AbsorbPointer(
                  child: TextField(
                    controller: _courseController,
                    // Main text field showing selected course
                    decoration: const InputDecoration(
                      labelText: 'Select Degree Course',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Course {
  final String id;
  final String name;

  Course({required this.id, required this.name});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
    );
  }
}

class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.check, color: Colors.white),
          ),
          Expanded(
            child: Divider(color: Colors.blue, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              '2',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(
              '3',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(
              '4',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
