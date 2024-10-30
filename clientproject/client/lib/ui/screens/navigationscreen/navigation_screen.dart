import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:payapp/provider/loginSignUpProvider.dart';
import 'package:payapp/provider/setingsProvider.dart';
import 'package:payapp/ui/screens/navigationscreen/profilescreen/profilescreen.dart';
import 'package:payapp/ui/widgets/samb_bnb.dart';
import 'package:provider/provider.dart';

import '../../../config/hiveConfig.dart';
import '../../../core/services/hiveDatabase.dart';
import '../../../data/model/body/notification_body.dart';
import '../../../themes/colors.dart';
import '../../../view/base/not_logged_in_screen.dart';
import 'ca_services/ca_home_screen.dart';
import 'earn_section/earn_main_screen.dart';
import 'education/educationform.dart';
import 'faqScreen/faqScreen.dart';
import 'homescreen/sambhav_home_screen.dart';
import 'navigation_drawer_widget.dart';

class NavigationScreen extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;

  final bool fromSplash;
  final int pageIndex;

  const NavigationScreen(
      {Key? key,
      required this.languages,
      required this.body,
      required this.fromSplash,
      required this.pageIndex})
      : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  //NotificationServices notificationServices = NotificationServices();
  final pageController = PageController(initialPage: 0);
  StreamController<int> streamController = StreamController();
  late Stream<int> navStream;

  @override
  void initState() {
    navStream = streamController.stream.asBroadcastStream();
    streamController.sink.add(0);
    super.initState();
    // notificationServices.requestNotificatPermission();
    // notificationServices.firebaseInit();
    // notificationServices.getDeviceToken().then((value) => print('device token:- '+value));
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavigationDrawerWidget(
        languages: widget.languages,
        body: widget.body,
      ),
      appBar: AppBar(
        titleSpacing: 5,
        title: Consumer<SettingsProvider>(
          builder: (_, settingsProvider, child) {
            if (settingsProvider.settingsModel != null) {
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.cover,
                      width: 30,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    "Sambhav",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: ThemeColors.blueAccent,
                    ),
                  ),
                ],
              );
            } else {
              return const Text(
                "Sambhav",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.blueAccent,
                ),
              );
            }
          },
        ),
        foregroundColor: Colors.black,
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(200),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Lottie.asset(
                'assets/lottie/video_intro.json',
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(200),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const FaqScreen(show: true)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Lottie.asset('assets/lottie/FAQ.json'),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(200),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            languages: widget.languages,
                            body: widget.body,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Lottie.asset('assets/lottie/account_persons.json'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Consumer<LoginSignUpProvider>(
                  builder: (context, loginSignUpProvider, child) {
                    return PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        streamController.sink.add(index);
                      },
                      itemCount: 4,
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          return SambhavHomeScreen(
                            navController: streamController,
                            pageController: pageController,
                            languages: widget.languages,
                            body: widget.body,
                          );
                        } else if (index == 1) {
                          return const EarnMainScreen();
                        } else if (index == 2) {
                          return const CaServicesScreen();
                        }
                        return const EducationFormScreen();
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SambBNB(
                    size: size,
                    navStream: navStream,
                    page1: "Home",
                    icon1: Iconsax.home,
                    page2: "Earn",
                    icon2: Iconsax.money,
                    page3: "CA Services",
                    icon3: Iconsax.medal_star,
                    page4: "Education",
                    icon4: Iconsax.book,
                    page1Tap: () {
                      streamController.sink.add(0);

                      pageController.animateToPage(0,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    page2Tap: () async {
                      Box box =
                          await HiveDataBase.openBox(boxName: HiveConfig.user);
                      final user = await HiveDataBase.getSingleItem(
                          key: HiveConfig.user, box: box);
                      if (user == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotLoggedInScreen(
                            callBack: (success) {
                              Navigator.of(context).pop();
                            },
                          ),
                        ));
                      } else {
                        streamController.sink.add(1);

                        pageController.animateToPage(
                          1,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    page3Tap: () async {
                      Box box =
                          await HiveDataBase.openBox(boxName: HiveConfig.user);
                      final user = await HiveDataBase.getSingleItem(
                          key: HiveConfig.user, box: box);
                      if (user == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotLoggedInScreen(
                            callBack: (success) {
                              Navigator.of(context).pop();
                            },
                          ),
                        ));
                      } else {
                        streamController.sink.add(2);

                        pageController.animateToPage(
                          2,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    page4Tap: () async {
                      // final loginSignUpProvider = Provider
                      //     .of<LoginSignUpProvider>(
                      //         context,
                      //         listen: false);
                      // if (loginSignUpProvider.userModel !=
                      //     null) {
                      //   final educationFormProvider =
                      //       Provider.of<
                      //               EductionFormProvider>(
                      //           context,
                      //           listen: false);
                      //   educationFormProvider
                      //           .onBoardingStatus ??=
                      //       await educationFormProvider
                      //           .initOnBoarding();
                      //   if (educationFormProvider
                      //           .onBoardingStatus ==
                      //       null) {
                      //     // Go To On Boarding Screen
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 OnBoardingScreenEducation()));
                      //   } else {
                      //     if (loginSignUpProvider
                      //             .userModel!
                      //             .academicStatus ==
                      //         "0") {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const EducationFormScreen()));
                      //     } else {
                      //       streamController.sink.add(3);
                      //       pageController.animateToPage(
                      //           3,
                      //           duration: const Duration(
                      //               microseconds: 500),
                      //           curve: Curves.easeInOut);
                      //     }
                      //   }
                      // } else {
                      //   Navigator.push(
                      //       context,
                      //       CupertinoPageRoute(
                      //           fullscreenDialog: true,
                      //           builder: (context) =>
                      //               const LoginScreen(
                      //                 fromInside: true,
                      //               )));
                      // }

                      Box box =
                          await HiveDataBase.openBox(boxName: HiveConfig.user);
                      final user = await HiveDataBase.getSingleItem(
                          key: HiveConfig.user, box: box);
                      if (user == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotLoggedInScreen(
                            callBack: (success) {
                              Navigator.of(context).pop();
                            },
                          ),
                        ));
                      } else {
                        //TODO:: when work done. change its like before.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EducationFormScreen()));
                      }
                    },
                    languages: widget.languages,
                    body: widget.body,
                    pageIndex: widget.pageIndex,
                    fromSplash: widget.fromSplash,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // final resones=await RemoteCAServices.fetchCAHomeServices();
      //     // final resones=await EarnScreenProvider().getActiveOffersfor_all_cata();
      //     final payments = await ApiService.FRequreddata();
      //     print(payments);
      //     // print(payments[1]);
      //     print("=================================================================");
      //     print("=================================================================");
      //     print("=================================================================");
      //     print("=================================================================");
      //     // print(resones);
      //   },
      // ),
    );
  }
}
