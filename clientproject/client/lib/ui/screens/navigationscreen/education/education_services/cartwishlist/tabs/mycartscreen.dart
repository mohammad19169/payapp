import 'package:flutter/material.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/cartwishlist/teachers_tab.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:payapp/widgets/tabs_bar_design.dart';

import 'courses_tab.dart';



class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: "My Cart",
        size: 55,
      ),
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Expanded(
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  CustomTabsBar(
                    tabs: [
                      Tab(
                        text: "Teachers",
                      ),
                      Tab(
                        text: "Courses",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [TeacherCart(), CourseCart()],
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }
}
