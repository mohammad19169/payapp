import 'package:flutter/material.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/job_list_page.dart';
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/job_posting_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/education/job_services/screens/build_resume_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/education/job_services/screens/loading_screen.dart';

import 'components/hire_bottom_navbar.dart';
import 'screens/job_list_page_against_degree.dart';

class HireAgainstDegreeMainScreen extends StatefulWidget {
  const HireAgainstDegreeMainScreen({super.key});

  @override
  State<HireAgainstDegreeMainScreen> createState() =>
      _HireAgainstDegreeMainScreenState();
}

class _HireAgainstDegreeMainScreenState
    extends State<HireAgainstDegreeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return JobPostingScreen();
            },
          ));
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        backgroundColor: ThemeColors.darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Job List',
          style: TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      body: JobListPageAgainstDegree(),
      bottomNavigationBar: HireBottomNavBar(),
    );
  }
}
