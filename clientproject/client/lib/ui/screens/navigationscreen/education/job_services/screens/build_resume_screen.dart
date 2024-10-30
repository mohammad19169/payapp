import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payapp/themes/colors.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../job_services/screens/jobs_search_screen.dart';
import 'experience_screen.dart';

class BuildResumeScreen extends StatefulWidget {
  const BuildResumeScreen({super.key});

  @override
  State<BuildResumeScreen> createState() => _BuildResumeScreenState();
}

class ResumeData {
  String fullName;
  String email;
  String age;
  String gender;
  XFile? profilePicture;

  ResumeData({
    this.fullName = '',
    this.email = '',
    this.age = '',
    this.gender = 'male',
    this.profilePicture,
  });
}

class _BuildResumeScreenState extends State<BuildResumeScreen> {
  final _formKey = GlobalKey<FormState>();
  ResumeData resumeData = ResumeData();
  bool _isLoading = true; // Add a loading state

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkResumeStatus(); // Check resume status on init
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        resumeData.profilePicture = image;
      });
    }
  }

  Future<void> _checkResumeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle token not available case
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var response = await http.get(
      Uri.parse('https://xyzabc.sambhavapps.com/v1/job/p1/check/employe'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        var resumeInfo = responseData['data'];
        resumeData = ResumeData(
          fullName: resumeInfo['name'],
          email: resumeInfo['email'],
          age: resumeInfo['age'],
          gender: resumeInfo['gender'],
          profilePicture: XFile(resumeInfo['logo']),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => JobSearchScreen(),
        ));
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Handle error case
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to check resume status.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey,
                    ),
                    child: resumeData.profilePicture == null
                        ? const Icon(Icons.person_outline, size: 60)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(resumeData.profilePicture!.path),
                        height: 140,
                        width: 140,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: _pickImage,
                      child: Text(
                        resumeData.profilePicture == null
                            ? "Add Photo"
                            : "Change Photo",
                        style: const TextStyle(
                            color: ThemeColors.darkBlueColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Text(
                          "Let's build your resume",
                          style: TextStyle(
                              color: ThemeColors.darkBlueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Enter your details so that employers can find you easily for a job",
                          style: TextStyle(
                              color: ThemeColors.darkBlueColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onSaved: (value) => resumeData.fullName = value!,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => resumeData.email = value!,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Age',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                    onSaved: (value) => resumeData.age = value!,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Gender",
                    style: TextStyle(
                        color: ThemeColors.darkBlueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    title: const Text('Male'),
                    leading: Radio<String>(
                      value: "male",
                      groupValue: resumeData.gender,
                      onChanged: (value) {
                        setState(() {
                          resumeData.gender = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Female'),
                    leading: Radio<String>(
                      value: "female",
                      groupValue: resumeData.gender,
                      onChanged: (value) {
                        setState(() {
                          resumeData.gender = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          resumeData.profilePicture != null) {
                        _formKey.currentState!.save();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ExperienceScreen(
                                resumeData: resumeData,
                              )),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please complete the form and select a profile picture.')),
                        );
                      }
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
                      'NEXT',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
