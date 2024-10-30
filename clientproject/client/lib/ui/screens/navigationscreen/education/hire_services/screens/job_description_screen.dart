import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/job_screen_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../../widgets/app_bar_widget.dart';
import 'job_posting_screen.dart';

class SkillQualification {
  final String title;
  final bool isSkill;

  SkillQualification({required this.title, required this.isSkill});
}

class JobDescriptionData {
  String selectedQualification;
  String selectedGender;
  String selectedEnglishSkill;
  Set<String> selectedSkills;

  JobDescriptionData({
    required this.selectedQualification,
    required this.selectedGender,
    required this.selectedEnglishSkill,
    required this.selectedSkills,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedQualification': selectedQualification,
      'selectedGender': selectedGender,
      'selectedEnglishSkill': selectedEnglishSkill,
      'selectedSkills': selectedSkills.toList(),
    };
  }
}

class JobDescriptionScreen extends StatefulWidget {
  final JobPostingData jobPostingData;

  const JobDescriptionScreen({Key? key, required this.jobPostingData})
      : super(key: key);
  @override
  _JobDescriptionScreenState createState() => _JobDescriptionScreenState();
}

class _JobDescriptionScreenState extends State<JobDescriptionScreen> {
  JobDescriptionData jobDescriptionData = JobDescriptionData(
    selectedQualification: '',
    selectedGender: '',
    selectedEnglishSkill: '',
    selectedSkills: {},
  );

  List<SkillQualification> combinedData = [];
  TextEditingController skillSearchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    skillSearchController.addListener(_filterSkills);
  }

  @override
  void dispose() {
    skillSearchController.removeListener(_filterSkills);
    skillSearchController.dispose();
    super.dispose();
  }

  void _filterSkills() {
    // Filter logic here
  }

  Future<void> _fetchData() async {
    String baseUrl =
        'https://xyzabc.sambhavapps.com'; // Replace with your base URL
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    // Fetch Skills and Qualifications
    final skillResponse = await http.get(
      Uri.parse('$baseUrl/v1/job/p1/skill/recruiter'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final qualificationResponse = await http.get(
      Uri.parse('$baseUrl/v1/job/p1/qualification'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (skillResponse.statusCode == 200 &&
        qualificationResponse.statusCode == 200) {
      final skillData = jsonDecode(skillResponse.body);
      final qualificationData = jsonDecode(qualificationResponse.body);

      final skills = List<SkillQualification>.from(
        skillData['data'].map((skill) =>
            SkillQualification(title: skill['title'], isSkill: true)),
      );

      final qualifications = List<SkillQualification>.from(
        qualificationData['data'].map((qualification) =>
            SkillQualification(title: qualification['name'], isSkill: false)),
      );

      setState(() {
        combinedData.addAll(skills);
        combinedData.addAll(qualifications);
      });
    } else {
      print('Failed to load skills and qualifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobScreenForm(
                jobDescriptionData: jobDescriptionData,
                jobPostingData: widget.jobPostingData,
              ),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
      appBar: const AppBarWidget(
        title: "Work Requirements",
        size: 40,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          controller: _scrollController,
          children: [
            const Text('Candidate\'s Minimum Qualification Should Be'),
            const SizedBox(height: 8.0),
            _buildQualificationOptions(),
            const SizedBox(height: 16.0),
            const Text('Gender of the Staff Should Be'),
            const SizedBox(height: 8.0),
            _buildGenderOptions(),
            const SizedBox(height: 16.0),
            const Text('Candidate\'s English Speaking Skill Should Be'),
            const SizedBox(height: 8.0),
            _buildEnglishSkillOptions(),
            const SizedBox(height: 16.0),
            const Text('Selected Skills'),
            const SizedBox(height: 8.0),
            _buildSelectedSkills(),
            const SizedBox(height: 16.0),
            const Text('All Skills'),
            TextField(
              controller: skillSearchController,
              decoration: const InputDecoration(
                hintText: 'Type to search for skills',
              ),
            ),
            const SizedBox(height: 8.0),
            _buildAllSkills(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxyOption(
      String label, String selectedOption, ValueChanged<String> onSelected) {
    bool isSelected = selectedOption == label;
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isSelected ? Colors.blue : Colors.grey[300],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildQualificationOptions() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          combinedData.where((item) => !item.isSkill).map((qualification) {
        return _buildBoxyOption(
            qualification.title, jobDescriptionData.selectedQualification,
            (value) {
          setState(() {
            jobDescriptionData.selectedQualification = value;
          });
        });
      }).toList(),
    );
  }

  Widget _buildGenderOptions() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildBoxyOption('Male', jobDescriptionData.selectedGender, (value) {
          setState(() {
            jobDescriptionData.selectedGender = value;
          });
        }),
        _buildBoxyOption('Female', jobDescriptionData.selectedGender, (value) {
          setState(() {
            jobDescriptionData.selectedGender = value;
          });
        }),
        _buildBoxyOption('Both', jobDescriptionData.selectedGender, (value) {
          setState(() {
            jobDescriptionData.selectedGender = value;
          });
        }),
      ],
    );
  }

  Widget _buildEnglishSkillOptions() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildBoxyOption(
            'Does not speak English', jobDescriptionData.selectedEnglishSkill,
            (value) {
          setState(() {
            jobDescriptionData.selectedEnglishSkill = value;
          });
        }),
        _buildBoxyOption(
            'Speaks thoda English', jobDescriptionData.selectedEnglishSkill,
            (value) {
          setState(() {
            jobDescriptionData.selectedEnglishSkill = value;
          });
        }),
        _buildBoxyOption(
            'Speaks good English', jobDescriptionData.selectedEnglishSkill,
            (value) {
          setState(() {
            jobDescriptionData.selectedEnglishSkill = value;
          });
        }),
        _buildBoxyOption(
            'Speaks fluent English', jobDescriptionData.selectedEnglishSkill,
            (value) {
          setState(() {
            jobDescriptionData.selectedEnglishSkill = value;
          });
        }),
      ],
    );
  }

  Widget _buildSelectedSkills() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: jobDescriptionData.selectedSkills.map((skill) {
        return Chip(
          label: Text(skill),
          avatar: const Icon(Icons.check),
          onDeleted: () {
            setState(() {
              jobDescriptionData.selectedSkills.remove(skill);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAllSkills() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: combinedData.map((skill) {
        return FilterChip(
          label: Text(skill.title),
          selected: jobDescriptionData.selectedSkills.contains(skill.title),
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                jobDescriptionData.selectedSkills.add(skill.title);
              } else {
                jobDescriptionData.selectedSkills.remove(skill.title);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
