import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/additional_details_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/job_description_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/job_posting_screen.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobScreenForm extends StatefulWidget {
  final JobDescriptionData jobDescriptionData;
  final JobPostingData jobPostingData;
  const JobScreenForm(
      {super.key,
      required this.jobDescriptionData,
      required this.jobPostingData});
  @override
  _JobScreenFormState createState() => _JobScreenFormState();
}

class _JobScreenFormState extends State<JobScreenForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _recruiterNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();

  TimeOfDay? _interviewTime;
  TimeOfDay? _workTime;
  DateTime? _experienceStartDate;
  DateTime? _experienceEndDate;

  @override
  void dispose() {
    _companyNameController.dispose();
    _recruiterNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyAddressController.dispose();
    _jobRoleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context,
      {required bool isInterviewTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isInterviewTime) {
          _interviewTime = picked;
        } else {
          _workTime = picked;
        }
      });
    }
  }

  Future<void> _pickDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _experienceStartDate = picked;
        } else {
          _experienceEndDate = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final jobPost = JobPost(
        companyName: _companyNameController.text,
        recruiterName: _recruiterNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _companyAddressController.text,
        jobRole: _jobRoleController.text,
        interviewTime: _interviewTime,
        workTime: _workTime,
        experienceStartDate: _experienceStartDate,
        experienceEndDate: _experienceEndDate,
      );

      const baseUrl =
          'https://xyzabc.sambhavapps.com'; // Replace with your base URL

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token =
          prefs.getString('token') ?? ''; // Add your token here if required

      final response = await http.post(
        Uri.parse('$baseUrl/v1/job/p1/job/recruiter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jobPost.toJson(),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AdditionalDetailsScreen(),
        ));
      } else {
        print(response.statusCode);
        print(response.body);
        print('Failed to submit job post. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     final jobPost = JobPost(
  //       companyName: _companyNameController.text,
  //       recruiterName: _recruiterNameController.text,
  //       email: _emailController.text,
  //       phone: _phoneController.text,
  //       address: _companyAddressController.text,
  //       jobRole: _jobRoleController.text,
  //       interviewTime: _interviewTime,
  //       workTime: _workTime,
  //       experienceStartDate: _experienceStartDate,
  //       experienceEndDate: _experienceEndDate,
  //     );

  //     // Navigate to the next screen with the jobPost data
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => AdditionalDetailsScreen(),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Company Form",
        size: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                controller: _companyNameController,
                label: 'Name of My Company',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the company name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _recruiterNameController,
                label: 'Contact Person / Recruiter Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the recruiter name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _emailController,
                label: 'Email ID',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Please enter a valid email'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a phone number' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _companyAddressController,
                label: 'My Company Address',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the company address' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _jobRoleController,
                label: 'Job Role',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the job role' : null,
              ),
              const SizedBox(height: 16),
              _buildTimeField(
                context: context,
                label: 'Interview Timing',
                time: _interviewTime,
                onTap: () => _pickTime(context, isInterviewTime: true),
              ),
              const SizedBox(height: 16),
              _buildTimeField(
                context: context,
                label: 'Work Timing',
                time: _workTime,
                onTap: () => _pickTime(context, isInterviewTime: false),
              ),
              const SizedBox(height: 16),
              _buildDateField(
                context: context,
                label: 'Experience Start Date',
                date: _experienceStartDate,
                onTap: () => _pickDate(context, isStartDate: true),
              ),
              const SizedBox(height: 16),
              _buildDateField(
                context: context,
                label: 'Experience End Date',
                date: _experienceEndDate,
                onTap: () => _pickDate(context, isStartDate: false),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.warning, color: Colors.yellow),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Asking job seekers for any kind of payment is strictly prohibited",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 300, width: 2)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: OverflowBar(
        alignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context); // Go back
            },
            backgroundColor: Colors.blue,
            child: Icon(FontAwesomeIcons.arrowLeft),
          ),
          FloatingActionButton(
            onPressed: _submitForm,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time != null ? time.format(context) : 'Select time'),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date != null ? DateFormat.yMd().format(date) : 'Select date'),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}

class JobPost {
  String companyName;
  String recruiterName;
  String email;
  String phone;
  String address;
  String jobRole;
  TimeOfDay? interviewTime;
  TimeOfDay? workTime;
  DateTime? experienceStartDate;
  DateTime? experienceEndDate;
  String bonusAmount;
  String bonusType;
  String staff;
  String totalExperience;
  String callsFrom;
  String workFromHome;

  JobPost({
    required this.companyName,
    required this.recruiterName,
    required this.email,
    required this.phone,
    required this.address,
    required this.jobRole,
    required this.interviewTime,
    required this.workTime,
    required this.experienceStartDate,
    required this.experienceEndDate,
    this.bonusAmount = '',
    this.bonusType = '',
    this.staff = '',
    this.totalExperience = '',
    this.callsFrom = '',
    this.workFromHome = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'company': companyName,
      'recruiter': recruiterName,
      'email': email,
      'phone': phone,
      'address': address,
      'jobRole': jobRole,
      'interview_timing': interviewTime != null
          ? '${interviewTime!.hour}:${interviewTime!.minute}'
          : '',
      'work_timing':
          workTime != null ? '${workTime!.hour}:${workTime!.minute}' : '',
      'experience': experienceStartDate != null
          ? '${experienceStartDate!.year}-${experienceStartDate!.month}-${experienceStartDate!.day}'
          : '',
      'bonusAmount': bonusAmount,
      'bonusType': bonusType,
      'staff': staff,
      'totalExperience': totalExperience,
      'callsFrom': callsFrom,
      'workFromHome': workFromHome,
    };
  }
}
