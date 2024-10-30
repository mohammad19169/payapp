import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../themes/colors.dart';
import '../../../../widgets/custom_video_player.dart';
import '../screens/ca_recent_courses_screen.dart';

class CaRecentCourses extends StatefulWidget {
  const CaRecentCourses({super.key});

  @override
  State<CaRecentCourses> createState() => _CaRecentCoursesState();
}

class _CaRecentCoursesState extends State<CaRecentCourses> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Recent Courses ',
                  style: TextStyle(
                    color: Colors.blue,
                    // Assuming you don't have ThemeColors defined
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    Get.to(() => TrainingScreen());
                  },
                  child: const Text(
                    'See All >>',
                    style: TextStyle(
                      color: ThemeColors.darkBlueColor,
                      // Assuming you don't have ThemeColors defined
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(5),
              itemBuilder: (context, index) {
                return  GestureDetector(
                  onTap: () {


                  },
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 180,
                      // height: 180,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                            child: Stack(
                              children: [
                                ClipRRect(

                                  borderRadius: BorderRadius.circular(10),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Learn and Earn with m, Demat Account",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                          )
                        ],
                      )),
                );
              },
            ),
          )
        ]));
  }
}
