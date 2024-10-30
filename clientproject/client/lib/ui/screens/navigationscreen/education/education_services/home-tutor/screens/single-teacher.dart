import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/data/model/response/place_details_model.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../../../../core/animations/shimmer_animation.dart';
import '../../../../../../../themes/colors.dart';
import '../../../../../../widgets/TextWidgets/richTextWidge.dart';

class SingleTeacher extends StatefulWidget {
  const SingleTeacher({Key? key, required this.teacherId}) : super(key: key);
  final String teacherId;

  @override
  State<SingleTeacher> createState() => _SingleTeacherState();
}

class _SingleTeacherState extends State<SingleTeacher> {
  var teacherProfileDetails = {};
  bool isLoading = true;

  Future<void> _fetchTeacherProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth-token');
      var apiUrl = Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/education/teacher/${widget
              .teacherId}');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var responseData = decodedResponse["data"];
        setState(() {
          teacherProfileDetails = responseData;
          isLoading = false;
        });
      } else {
        print('API Request Failed with Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error calling API: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTeacherProfile();
    getCurrentLocation();
  }

  List<int> color = [
    0xff68CA10,
  ];
  late Position position;
  var distanceInKilometers;

  getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is denied forever.');
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = Geolocator.distanceBetween(
        position.longitude,
        position.latitude,
        teacherProfileDetails["location"]["coordinates"][0],
        teacherProfileDetails["location"]["coordinates"][1]);
    setState(() {
      distanceInKilometers = distanceInMeters / 1000;
    });
    print("Distance in kilometers: $distanceInKilometers");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    print(teacherProfileDetails);
    returnTeachingMode(List statusList) {
      if (statusList.length == 1) {
        return statusList[0].toString();
      } else {
        return 'online/offline';
      }
    }

    print("Elements : ");
    double? ratingsAverage;
    if (!isLoading) {
      int ratingsTotal = 0;
      teacherProfileDetails["ratings"].forEach((element) {
        print(element["star"]);
        ratingsTotal = ratingsTotal + element["star"] as int;
      });
      ratingsAverage = ratingsTotal / teacherProfileDetails["ratings"].length;
    }

    return Scaffold(
      appBar: const AppBarWidget(title: "Teacher Information", size: 55),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: size.height / 2,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        teacherProfileDetails["image"] ??
                            "https://www.pngall.com/wp-content/uploads",
                        width: size.width,
                        height: size.height / 2.25,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: ShimmerAnimation(
                              width: 140,
                              height: 150,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(
                          child: ShimmerAnimation(
                            width: 140,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: size.width * .06,
                    right: size.width * .06,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width / 1.2,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            color: ThemeColors.primaryBlueColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              teacherProfileDetails["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              teacherProfileDetails["bio"],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children:
                                  List<Widget>.generate(5, (index) {
                                    return Icon(
                                      index < ratingsAverage!
                                          ? Icons.star
                                          : Icons.star_border_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "(${ratingsAverage.toString()})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10,
                                      color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Available Slots:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                      teacherProfileDetails["available_slots"].length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.grey, width: 1),
                            // Color(int.parse("${weekend[index]["color"]}")).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            // boxShadow: [ BoxShadow(
                            //     offset: const Offset(1,1),
                            //     color: ThemeColors.blueColor.withOpacity(0.2),
                            //     blurRadius: 5.0,
                            //     spreadRadius: 3
                            // ),],
                          ),
                          child: Column(
                            children: [
                              Text(
                                teacherProfileDetails["available_slots"]
                                [index]["day"],
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.darkBlueColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                teacherProfileDetails["available_slots"]
                                [index]["start_time"],
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.darkBlueColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                teacherProfileDetails["available_slots"]
                                [index]["end_time"],
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.darkBlueColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Class Duration",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: size.width,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: ThemeColors.primaryBlueColor
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                // boxShadow: [ BoxShadow(
                                //     offset: const Offset(1,1),
                                //     color: ThemeColors.blueColor.withOpacity(0.2),
                                //     blurRadius: 5.0,
                                //     spreadRadius: 3
                                // ),],
                              ),
                              child: Center(
                                child: Text(
                                  teacherProfileDetails["class_duration"],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Teaching Mode",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: size.width,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                // boxShadow: [ BoxShadow(
                                //     offset: const Offset(1,1),
                                //     color: ThemeColors.blueColor.withOpacity(0.2),
                                //     blurRadius: 5.0,
                                //     spreadRadius: 3
                                // ),],
                              ),
                              child: Center(
                                child: Text(
                                  teacherProfileDetails["teaching_mode"]
                                      .join("/"),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Language Mode:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...teacherProfileDetails["language"]
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              var e = entry.value;
                              return Container(
                                width: 180,
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.deepPurpleAccent
                                      .withOpacity(0.2)
                                      : Colors.redAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       offset: const Offset(1, 1),
                                  //       color: ThemeColors.darkBlueColor
                                  //           .withOpacity(0.2),
                                  //       blurRadius: 5.0,
                                  //       spreadRadius: 3),
                                  // ],
                                ),
                                child: Center(
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichTextWidget(
                        leftText:
                        teacherProfileDetails["subjects"].length > 1
                            ? "Subjects: "
                            : "Subject: ",
                        rightText:
                        teacherProfileDetails["subjects"].join('/'),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RichTextWidget(
                        leftText: "Fee: ",
                        rightText: "₹${teacherProfileDetails["fee"]}/month",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RichTextWidget(
                        leftText: "Distance From Me: ",
                        rightText:
                        "${distanceInKilometers == null
                            ? "0"
                            : distanceInKilometers.truncate().toString()} km",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Demo Teaching Videos:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                      teacherProfileDetails["demo_videos"].length,
                      itemBuilder: (_, index) {
                        String videoUrl =
                        teacherProfileDetails["demo_videos"][index]
                        ["video"];
                        String videoId =
                        YoutubePlayer.convertUrlToId(videoUrl)
                            .toString();

                        YoutubePlayerController controller =
                        YoutubePlayerController(
                          initialVideoId: videoId,
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        );
                        return Container(
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 3,
                                    blurRadius: 1.5,
                                    offset: const Offset(0, 1))
                              ]),
                          width: size.width * 0.7,
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: YoutubePlayer(
                              controller: controller,
                              showVideoProgressIndicator: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Reviews: ",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            // set to false if you want to force a rating
                            builder: (context) =>
                                RatingDialog(
                                  initialRating: 3.5,
                                  // your app's name?
                                  title: Text(
                                    teacherProfileDetails["name"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // encourage your user to leave a high rating?
                                  message: Text(
                                    'Give some feedback for ${teacherProfileDetails["name"]}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  // your app's logo?
                                  image: Image.network(
                                    teacherProfileDetails["image"] ??
                                        "https://www.pngall.com/wp-content/uploads",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress,) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                        child: ShimmerAnimation(
                                          width: 100,
                                          height: 100,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                    const Center(
                                      child: ShimmerAnimation(
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  submitButtonText: 'Submit',
                                  commentHint: 'write feedback',
                                  onCancelled: () => printThis('cancelled'),
                                  onSubmitted: (response) {
                                    printThis(
                                        'rating: ${response
                                            .rating}, comment: ${response
                                            .comment}');

                                    // TODO: add your own logic
                                    if (response.rating < 3.0) {
                                      // send their comments to your email or anywhere you wish
                                      // ask the user to contact you instead of leaving a bad review
                                    } else {}
                                  },
                                ),
                          );
                        },
                        child: const Text("Add Review"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: teacherProfileDetails["ratings"].length,
                    itemBuilder: (context, index) {
                      return buildSingleReviews(
                          size: size,
                          userName: "User Name",
                          msg: teacherProfileDetails["ratings"][index]
                          ["comment"],
                          star: teacherProfileDetails["ratings"][index]
                          ["star"]
                              .toString(),
                          image:
                          "https://m.media-amazon.com/images/M/MV5BNjBkN2JlMmQtNDdjMC00NWQyLTg1OTctNjA2Y2IxNzhmNmMxXkEyXkFqcGdeQXVyOTMyODgwOTQ@._V1_.jpg");
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //show a pop up box that teacher is hired successfully
          showDialog(
            context: context,
            builder: (context) {
              var teacherHiredLoading = true;
              assignTeacher() async {
                try {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  String? token = prefs.getString('token');
                  var apiUrl = Uri.parse(
                      'https://xyzabc.sambhavapps.com/v1/user/teacher/assign');

                  var response = await http.post(apiUrl,
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: json.encode({"teacher": widget.teacherId}));
                  if (response.statusCode == 200) {
                    print(response.body);

                    teacherHiredLoading = false;
                  } else {
                    print(
                        'API Request Failed with Status Code: ${response
                            .statusCode}');
                    print(response.body);
                    teacherHiredLoading = false;
                  }
                } catch (error) {
                  print('Error calling API: $error');
                  // setState(() {
                  teacherHiredLoading = false;
                  // });
                }
              }

              assignTeacher();
              return teacherHiredLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AlertDialog(
                title: const Text("Teacher Hired"),
                content: const Text("The teacher has been hired successfully."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        label: const Text(
          "          Hire Me          ",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 60,
      //   padding: const EdgeInsets.all(15),
      //   margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      //   decoration: BoxDecoration(
      //     color: ThemeColors.primaryBlueColor,
      //     borderRadius: BorderRadius.circular(20),
      //     boxShadow: [
      //       BoxShadow(
      //           offset: const Offset(1, 1),
      //           color: ThemeColors.primaryBlueColor.withOpacity(0.2),
      //           blurRadius: 5.0,
      //           spreadRadius: 3),
      //     ],
      //   ),
      //   child: InkWell(
      //     onTap: () {
      //
      //     },
      //     child: const Center(
      //       child: Text(
      //         "Hire Me",
      //         style: TextStyle(
      //           fontSize: 17,
      //           fontWeight: FontWeight.w600,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Container buildSingleReviews({
    required Size size,
    required String userName,
    required String msg,
    required String star,
    required String image,
  }) {
    return Container(
      width: size.width / 1.25,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const Icon(Icons.account_circle_outlined,
                  size: 50, color: Colors.grey)
              //  Image.network(
              //   image,
              //   width: 50,
              //   height: 50,
              //   fit: BoxFit.cover,
              // )
              ,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          star,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(msg),
              ],
            ),
          )
        ],
      ),
    );
  }

  final _dialog = RatingDialog(
    initialRating: 3.5,
    // your app's name?
    title: const Text(
      'Samhav',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: const Text(
      'Give some feedback for this teacher.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ),
    // your app's logo?
    image: const FlutterLogo(size: 100),
    submitButtonText: 'Submit',
    commentHint: 'write feedback',
    onCancelled: () => printThis('cancelled'),
    onSubmitted: (response) {
      printThis('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {}
    },
  );
}
