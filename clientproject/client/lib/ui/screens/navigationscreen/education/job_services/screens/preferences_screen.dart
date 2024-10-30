import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../themes/colors.dart';
import 'build_resume_screen.dart';
import 'experience_screen.dart';
import 'see_jobs_screen.dart';

class Job {
  final String title;
  final String subtitle;
  final String id;

  Job(this.title, this.subtitle, this.id);

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(json['title'], json['description'], json['id']);
  }
}

class JobPreferencesScreen extends StatefulWidget {
  final ResumeData resumeData;
  final Course selectedCourse;

  const JobPreferencesScreen(
      {super.key, required this.resumeData, required this.selectedCourse});

  @override
  State<JobPreferencesScreen> createState() => _JobPreferencesScreenState();
}

class _JobPreferencesScreenState extends State<JobPreferencesScreen> {
  int activeStep = 2;

  List<Job> allJobs = [];
  late List<Job> _filteredJobs;
  final TextEditingController _searchController = TextEditingController();
  Map<Job, bool> _selectedJobs = {};

  @override
  void initState() {
    super.initState();
    _fetchJobs();
    _filteredJobs = List.from(allJobs);
  }

  Future<void> _fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      // Handle the case when there is no token
      return;
    }

    final response = await http.get(
      Uri.parse('https://xyzabc.sambhavapps.com/v1/job/p1/departments'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          allJobs = (data['data'] as List)
              .map((jobJson) => Job.fromJson(jobJson))
              .toList();
          _filteredJobs = List.from(allJobs);
          _selectedJobs = { for (var job in allJobs) job : false };
        });
      }
    } else {
      // Handle error
      print('Failed to load jobs');
    }
  }

  void _filterJobs(String query) {
    setState(() {
      _filteredJobs = allJobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
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
                const TextStyle(fontSize: 16),
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
              print(_selectedJobs);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SeeJobsScreen(
                  resumeData: widget.resumeData,
                  selectedCourse: widget.selectedCourse,
                  selectedJobs: _selectedJobs,
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
                const TextStyle(fontSize: 16),
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
                "Get personalised job recommendations based on your experience.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Select preferred department/area of work",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Search Jobs",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _filterJobs(value),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8),
                    child: Text(
                      "All Jobs",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._filteredJobs.map((job) {
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.work),
                          title: Text(
                            job.title,
                          ),
                          subtitle: Text(job.subtitle),
                          trailing: Checkbox(
                            value: _selectedJobs[job],
                            onChanged: (value) {
                              setState(() {
                                _selectedJobs[job] = value!;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
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
            child: Icon(Icons.check, color: Colors.white),
          ),
          Expanded(
            child: Divider(color: Colors.grey, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
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
