import 'package:flutter/material.dart';
import 'job_details_screen.dart';
import 'dart:convert';
import '../../../../../../themes/colors.dart';
import 'package:http/http.dart' as http;

class Job2 {
  final String department;
  final String city;
  final String locality;
  final int minSalary;
  final int maxSalary;
  final int staff;
  final String totalExperience;
  final int minExperience;
  final int maxExperience;
  final String qualification;
  final String gender;
  final String englishSpeaking;
  final List<String> skills;
  final String callsFrom;
  final String workFromHome;
  final String jobRole;
  final String workTiming;
  final String interviewTiming;
  final String company;
  final String recruiter;
  final String email;
  final String phone;
  final String address;
  final String id;

  Job2({
    required this.department,
    required this.city,
    required this.locality,
    required this.minSalary,
    required this.maxSalary,
    required this.staff,
    required this.totalExperience,
    required this.minExperience,
    required this.maxExperience,
    required this.qualification,
    required this.gender,
    required this.englishSpeaking,
    required this.skills,
    required this.callsFrom,
    required this.workFromHome,
    required this.jobRole,
    required this.workTiming,
    required this.interviewTiming,
    required this.company,
    required this.recruiter,
    required this.email,
    required this.phone,
    required this.address,
    required this.id,
  });

  factory Job2.fromJson(Map<String, dynamic> json) {
    return Job2(
      department: json['department'],
      city: json['city'],
      locality: json['locality'],
      minSalary: json['monthly_salary']['min'],
      maxSalary: json['monthly_salary']['max'],
      staff: json['staff'],
      totalExperience: json['total_experience'],
      minExperience: json['experience']['min'],
      maxExperience: json['experience']['max'],
      qualification: json['qualification'],
      gender: json['gender'],
      englishSpeaking: json['english_speaking'],
      skills: List<String>.from(json['skill']),
      callsFrom: json['calls_from'],
      workFromHome: json['work_from_home'],
      jobRole: json['job_role'],
      workTiming: json['work_timing'],
      interviewTiming: json['interview_timing'],
      company: json['company'],
      recruiter: json['recruiter'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      id: json['id'],
    );
  }
}

Future<List<Job2>> fetchJobs() async {
  final response = await http.get(
    Uri.parse('https://example.com/v1/job/p1/job/recruiter'),
    headers: {
      'Authorization': 'Bearer YOUR_BEARER_TOKEN',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body)['data'];
    List<Job2> jobs = body.map((dynamic item) => Job2.fromJson(item)).toList();
    return jobs;
  } else {
    throw Exception('Failed to load jobs');
  }
}

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  late Future<List<Job2>> futureJobs;

  @override
  void initState() {
    super.initState();
    futureJobs = fetchJobs();
  }

  Widget buildJobCard(BuildContext context, Job2 job) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const JobDetailsScreen(),
        ));
        print("Card pressed");
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.cases, color: Colors.blue),
              title: Text(job.jobRole),
              subtitle: Text('Rs. ${job.minSalary} - Rs. ${job.maxSalary}'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('${job.city} (${job.locality})'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(job.company),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0.5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black54),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('New', style: TextStyle(color: Colors.green))),
                Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0.5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black54),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('${job.staff}')),
                Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0.5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black54),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(job.workFromHome,
                        style: const TextStyle(color: Colors.deepPurple)))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
       /*   AppBar(
            backgroundColor: ThemeColors.darkBlueColor,
            automaticallyImplyLeading: false,
            leading: Icon(
              Icons.location_on_outlined,
              color: Colors.white,
            ),
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                children: [
                  Text(
                    "Taj Khodahi, Bahrai",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            actions: [
              Icon(
                Icons.share,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                margin: EdgeInsets.all(3),
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),*/
       /*   Container(
            color: ThemeColors.darkBlueColor,
            padding: EdgeInsets.only(bottom: 15),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin:
              EdgeInsets.only(bottom: 10.0, left: 10, right: 10, top: 10),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: ThemeColors.darkBlueColor,
                  ),
                  hintText: 'Search job title, company, skill',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),*/
         /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                icon: Icon(Icons.filter_list),
                label: Text('Filters'),
                onPressed: () {
                  // Filter action
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.sort),
                label: Text('Sort by'),
                onPressed: () {
                  // Sort action
                },
              ),
            ],
          ),*/
          FutureBuilder<List<Job2>>(
            future: futureJobs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No jobs found'));
              } else {
                List<Job2> jobs = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    return buildJobCard(context, jobs[index]);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
