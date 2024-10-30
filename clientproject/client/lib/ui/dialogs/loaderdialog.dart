import 'package:flutter/material.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/dialogs/videodialog.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/i_am_student/student_dashboard.dart';

import '../screens/navigationscreen/education/education_services/i_am_student/student_education_home_screen.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text("PleaseWait...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlert(BuildContext context) async {
  return await showDialog(
    context: context,
    // barrierColor: Colors.green,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        // actionsPadding: EdgeInsets.only(
        // bottom: MediaQuery.of(context).size.height * 0.016,
        // right: MediaQuery.of(context).size.width * 0.05,
        // ),
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.02)),
        content: SizedBox(
          height: 120,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Are You Preparing For Competitive Exams ?",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        RouteConfig.navigateToRTL(
                            context, const StudentsDashboard());
                      },
                      child: const Text('No'),
                    ),
                    OutlinedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              ThemeColors.primaryBlueColor)),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: ThemeColors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

showVideoDialog(BuildContext context, {required String videoUrl}) async {
  showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return VideoDialog(
          videoUrl: videoUrl,
        );
      });
}
