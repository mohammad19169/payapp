import 'dart:async';

// import '../../util/get_cookies.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payapp/main.dart';

import '../../config/route_config.dart';
import '../../controller/location_controller.dart';
import '../../data/model/body/notification_body.dart';
import '../../helper/notification_helper.dart';

// import '../../main_e.dart';
import '../../themes/colors.dart';
import '../../view/screens/dashboard/dashboard_screen.dart';
import '../../view/screens/home/home_screen.dart';
import '../../view/screens/location/access_location_screen.dart';
import '../../view/screens/splash/splash_screen.dart';

class SambBNB extends StatelessWidget {
  const SambBNB({
    super.key,
    required this.size,
    required this.navStream,
    required this.page1,
    required this.page2,
    required this.page3,
    required this.page4,
    required this.icon1,
    required this.icon2,
    required this.icon3,
    required this.icon4,
    this.page1Tap,
    this.page2Tap,
    this.page3Tap,
    this.page4Tap,
    required this.languages,
    required this.body,
    required this.fromSplash,
    required this.pageIndex,
  });

  final Size size;

  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  final Stream<int> navStream;
  final String page1;
  final String page2;
  final String page3;
  final String page4;
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final IconData icon4;
  final bool fromSplash;
  final int pageIndex;
  final VoidCallback? page1Tap;
  final VoidCallback? page2Tap;
  final VoidCallback? page3Tap;
  final VoidCallback? page4Tap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ThemeColors.primaryBlueColor.withOpacity(0.7),
            offset: const Offset(20.0, 20.0),
            blurRadius: 25.0,
          ),
        ],
      ),
      height: 70,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomPainter(),
            ),
          ),
          Center(
            heightFactor: .7,
            child: Align(
              alignment: Alignment.topCenter,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                mini: false,
                isExtended: true,
                tooltip:
                    " Hi, I'm Osama M. Elngar, Software Developer, call me Via \n :osamaelngar98@gmail.com, \n :+201097157080",
                onPressed: () async {
                  NotificationBody? body;
                  // try {
                  //   if (GetPlatform.isMobile) {
                  //     final RemoteMessage? remoteMessage =
                  //         await FirebaseMessaging.instance.getInitialMessage();
                  //     if (remoteMessage != null) {
                  //       body = NotificationHelper.convertNotification(
                  //           remoteMessage.data);
                  //     }
                  //     await NotificationHelper.initialize(
                  //         flutterLocalNotificationsPlugin);
                  //     FirebaseMessaging.onBackgroundMessage(
                  //         myBackgroundMessageHandler);
                  //   }
                  // } catch (_) {}
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          // Text("Hello world")
                          // DashboardScreen(pageIndex: 0, fromSplash: Get.parameters['from-splash'] == 'true')
                      const EcommerceDashboardScreen(pageIndex: 0)));
                },
                elevation: 0.1,
                child: const Icon(
                  Icons.fingerprint_sharp,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: StreamBuilder<int>(
                      stream: navStream,
                      builder: (context, snapshot) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor:
                                ThemeColors.primaryBlueColor.withOpacity(0.15),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30)),
                            onTap: page1Tap,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon1,
                                  color: snapshot.data == 0
                                      ? ThemeColors.primaryBlueColor
                                      : Colors.grey,
                                ),
                                Text(
                                  page1,
                                  style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .035,
                                      color: snapshot.data == 0
                                          ? ThemeColors.primaryBlueColor
                                          : Colors.grey,
                                      fontWeight: snapshot.data == 0
                                          ? FontWeight.w500
                                          : FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: StreamBuilder<int>(
                      stream: navStream,
                      builder: (context, snapshot) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor:
                                ThemeColors.primaryBlueColor.withOpacity(0.15),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15)),
                            onTap: page2Tap,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon2,
                                  color: snapshot.data == 1
                                      ? ThemeColors.primaryBlueColor
                                      : Colors.grey,
                                ),
                                // Icon(Iconsax.flag,color: snapshot.data==1?ThemeColors.blueColor:Colors.grey,),
                                Text(
                                  page2,
                                  style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .035,
                                      color: snapshot.data == 1
                                          ? ThemeColors.primaryBlueColor
                                          : Colors.grey,
                                      fontWeight: snapshot.data == 1
                                          ? FontWeight.w500
                                          : FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  width: size.width * 0.20,
                ),
                Expanded(
                  child: StreamBuilder<int>(
                      stream: navStream,
                      builder: (context, snapshot) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor:
                                ThemeColors.primaryBlueColor.withOpacity(0.15),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15)),
                            onTap: page3Tap,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon3,
                                  color: snapshot.data == 2
                                      ? ThemeColors.primaryBlueColor
                                      : Colors.grey,
                                ),
                                Text(
                                  page3,
                                  style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .030,
                                      color: snapshot.data == 2
                                          ? ThemeColors.primaryBlueColor
                                          : Colors.grey,
                                      fontWeight: snapshot.data == 2
                                          ? FontWeight.w500
                                          : FontWeight.normal),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: StreamBuilder<int>(
                      stream: navStream,
                      builder: (context, snapshot) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor:
                                ThemeColors.primaryBlueColor.withOpacity(0.15),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30)),
                            onTap: page4Tap,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon4,
                                  color: snapshot.data == 3
                                      ? ThemeColors.primaryBlueColor
                                      : Colors.grey,
                                ),
                                Text(
                                  page4,
                                  style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .035,
                                      color: snapshot.data == 3
                                          ? ThemeColors.primaryBlueColor
                                          : Colors.grey,
                                      fontWeight: snapshot.data == 3
                                          ? FontWeight.w500
                                          : FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class SnakeBottomBar extends StatelessWidget {
//   const SnakeBottomBar({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(
//             20,
//           ),
//           topRight: Radius.circular(
//             20,
//           ),
//         ),
//       ),
//       child: Consumer<EarnScreenProvider>(
//         builder: (context, provider, child) {
//           return SnakeNavigationBar.color(
//             behaviour: SnakeBarBehaviour.pinned,
//             snakeShape: SnakeShape.circle,
//             padding: const EdgeInsets.symmetric(vertical: 5),
//             unselectedLabelStyle: const TextStyle(fontSize: 11),
//             snakeViewColor: Theme.of(context).primaryColor,
//             unselectedItemColor: Colors.black54,
//             showUnselectedLabels: true,
//             currentIndex: provider.currentIndex,
//             onTap: (index) {
//               provider.updateIndex(index);
//             },
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.category), label: 'Planner '),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.cast_for_education), label: 'Courses'),
//               BottomNavigationBarItem(
//                   icon: Icon(Iconsax.cup), label: 'Achievements')
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = ThemeColors.backgroundLightBlue
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.0, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);

    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BNBCustomPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = ThemeColors.backgroundLightBlue
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.0, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);

    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
