import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payapp/constants.dart';
import 'package:payapp/core/utils/validator/validator.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../../themes/colors.dart';
import '../../../../../../widgets/editdetailswidget.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherInfoEdit extends StatefulWidget {
  const TeacherInfoEdit({Key? key}) : super(key: key);

  @override
  State<TeacherInfoEdit> createState() => _TeacherInfoEditState();
}

class _TeacherInfoEditState extends State<TeacherInfoEdit> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();

  final bioController = TextEditingController();
  final designation = TextEditingController();
  final villageController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  final classDuration = TextEditingController();
  final teachingMode = TextEditingController();
  final language = TextEditingController();
  final subject = TextEditingController();
  final fee = TextEditingController();
  final Location _location = Location();
  String? _latitude;
  String? _longitude;
  List<XFile> _videos = [];
  List<VideoPlayerController> _controllers = [];
  List<String> classVideos = [];

  postTeacher(Map teacherData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    var response = await http.post(
        Uri.parse('https://xyzabc.sambhavapps.com/v1/education/teacher'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "name": "arooj",
          "image": "image",
          "banner": [
            "img1",
            "img2"
          ],
          "fee": "500",
          "available_slots": [
            {
              "day": "Monday",
              "start_time": "08:20",
              "end_time": "16:30"
            }
          ],
          "class_duration": "2.5h",
          "teaching_mode": [
            "online",
            "offline"
          ],
          "language": [
            "hindi",
            "english"
          ],
          "demo_videos": [
            {
              "title": "First Video",
              "video": "video1"
            },
            {
              "title": "Second Video",
              "video": "video2"
            }
          ],
          "mobile": "8989898989",
          "bio": "hey this is my bio",
          "subjects": [
            "hindi",
            "physics",
            "english"
          ],
          "village": "my village",
          "district": "my district",
          "zipcode": "787878",
          "state": "my state",
          "location": {
            "type": "Point",
            "coordinates": [
              121.212,
              64.656
            ]
          },
          "country": "India"
        }));


    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> pickVideos() async {
    final pickedVideos = await ImagePicker().pickMultiImage();
    _videos = pickedVideos;
    _controllers = _videos.map((videoFile) {
      final controller = VideoPlayerController.file(File(videoFile.path))
        ..initialize().then((_) {
          setState(() {});
        });
      return controller;
    }).toList();
    }

  Future<void> uploadVideo(XFile video) async {
    final request = http.MultipartRequest('POST', Uri.parse('Your API URL'));
    request.files.add(await http.MultipartFile.fromPath('video', video.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      // Get the download URL and add it to classVideos
      // This depends on your API response
    }
  }

  Future<void> deleteVideo(String videoUrl) async {
    // This depends on your API
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark // status bar color
    ));
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      var currentLocation = await _location.getLocation();
      setState(() {
        _latitude = currentLocation.latitude.toString();
        _longitude = currentLocation.longitude.toString();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Permission denied');
      }
    }
  }

  final daysSelected = [];

  @override
  Widget build(BuildContext context) {
    Map printDataToJson() {
      var data = {
        "name": nameController.text,
        "image": "image",
        "banner": ["img1", "img2"],
        "fee": fee.text,
        "country": "India",
        "available_slots": daysSelected,
        "class_duration": classDuration.text,
        "teaching_mode": teachingMode.text.split("/"),
        "language": language.text.split(","),
        "demo_videos": [
          {"title": "First Video", "video": "video1"},
          {"title": "Second Video", "video": "video2"}
        ],
        "mobile": mobileController.text,
        "bio": bioController.text,
        "subjects": subject.text.split(","),
        "village": villageController.text,
        "district": districtController.text,
        "zipcode": zipCodeController.text,
        "state": stateController.text,
        "location": {
          "type": "Point",
          "coordinates": [double.parse(_latitude!), double.parse(_longitude!)]
        }
        // "latitude": _latitude,
        // "longitude": _longitude
      };
      // Converting to JSON string
      // Printing JSON data
      print(data);
      return data;
    }

    TimeOfDay selectedTime = TimeOfDay.now();
    var days = [
      " Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Sartuday"
    ];

    Future<TimeOfDay> selectTime(
        {required String period, required String day}) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          // Find the day in daysSelected list
          var dayFoundIndex =
          daysSelected.indexWhere((element) => element["day"] == day);

          if (dayFoundIndex != -1) {
            // If the day is found, update the selected time for the specified period
            daysSelected[dayFoundIndex][period] = pickedTime;
          }
        });
        print(daysSelected);
        return pickedTime;
      }
      return TimeOfDay.now();
    }

    Widget buildTimeOfDay({required String day,
      required TimeOfDay timeTo,
      required TimeOfDay timeFrom}) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    day,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1.2,
                    color: Colors.blueGrey,
                    style: BorderStyle.solid,
                  ),
                ),
                child: GestureDetector(
                  onTap: () async {
                    TimeRange result = await showTimeRangePicker(
                      context: context,
                      strokeWidth: 4,
                      ticks: 12,
                      ticksOffset: 2,
                      ticksLength: 8,
                      handlerRadius: 8,
                      ticksColor: Colors.grey,
                      rotateLabels: false,
                      labels: [
                        "24 h",
                        "3 h",
                        "6 h",
                        "9 h",
                        "12 h",
                        "15 h",
                        "18 h",
                        "21 h"
                      ]
                          .asMap()
                          .entries
                          .map((e) {
                        return ClockLabel.fromIndex(
                            idx: e.key, length: 8, text: e.value);
                      }).toList(),
                      labelOffset: 30,
                      padding: 55,
                      labelStyle:
                      const TextStyle(fontSize: 18, color: Colors.black),
                      start: timeFrom,
                      end: timeTo,
                      // disabledTime: TimeRange(
                      //     startTime: const TimeOfDay(hour: 6, minute: 0),
                      //     endTime: const TimeOfDay(hour: 10, minute: 0)),
                      clockRotation: 180.0,
                    );
                    setState(() {
                      var dayFoundIndex = daysSelected
                          .indexWhere((element) => element["day"] == day);
                      if (dayFoundIndex != -1) {
                        daysSelected[dayFoundIndex]["from"] = result.startTime;
                        daysSelected[dayFoundIndex]["to"] = result.endTime;
                      }
                    });
                    timeFrom = result.startTime;
                    timeTo = result.endTime;
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "add",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("From : ", style: TextStyle(fontSize: 17)),
              Text(
                timeFrom.format(context),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text("To :", style: TextStyle(fontSize: 17)),
              Text(
                timeTo.format(context),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }

    Widget buildDayChip({required String day}) {
      Color getColor() {
        var containsDay = false;
        for (var element in daysSelected) {
          if (element["day"] == day) {
            containsDay = true;
          }
        }
        if (containsDay) {
          return Colors.blueGrey;
        }
        return const Color(0xffc2c0c0ff);
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            var dayAdded = false;
            var daysSelectedFound = <Map<String,
                dynamic>>[]; // Specify the type of the list elements

            // Iterate through daysSelected list
            for (var element in daysSelected) {
              if (element["day"] == day) {
                // Check if the day is already in daysSelected
                dayAdded = true;
                daysSelectedFound
                    .add(element); // If found, add it to daysSelectedFound list
              }
            }
            if (!dayAdded) {
              // Use negation operator directly
              daysSelected.add({
                "day": day,
                "from": const TimeOfDay(hour: 8, minute: 20),
                "to": const TimeOfDay(hour: 16, minute: 30)
              });
            } else {
              for (var element in daysSelectedFound) {
                daysSelected.remove(
                    element); // Remove the found element from daysSelected
              }
            }
          });
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 1.2,
              color: Colors.blueGrey,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
              child: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
              )),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const AppBarWidget(title: "Edit Profile", size: 55),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 280,
              //   child: Stack(
              //     children: [
              //       // MyBanner(),
              //       Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: const Color(0xffF8F8F8),
              //               borderRadius: BorderRadius.circular(100)),
              //           padding: const EdgeInsets.all(2),
              //           child: const CircleAvatar(
              //             radius: 50,
              //             child: Icon(Icons.add_a_photo_outlined,
              //                 color: Colors.white, size: 40),
              //             // Profile image
              //             backgroundImage: NetworkImage(
              //                 'https://i.pinimg.com/originals/c1/fa/16/c1fa169559a6e6bb172c0c79408eb37e.jpg'),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),

//               Center(
//                 child: Container(
//                   height: 90,
//                   width: 90,
//                   decoration: BoxDecoration(
//                     color: ThemeColors.darkBlueColor,
// borderRadius:
//                   ),
//                 ),
//               ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EditDetailsWidget(
                                  title: "Name",
                                  detail: "Name",
                                  editingController: nameController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "Phone",
                                  detail: "Phone Number",
                                  editingController: mobileController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "Bio",
                                  detail: "Edit Bio",
                                  editingController: bioController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "Language",
                                  detail: "Language",
                                  editingController: language,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "Designation",
                                  detail: "Designation",
                                  editingController: designation,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "Village",
                                  detail: "New Delhi",
                                  editingController: villageController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "District",
                                  detail: "Enter District",
                                  editingController: districtController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "State",
                                  detail: "Enter State",
                                  editingController: stateController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              EditDetailsWidget(
                                  title: "Zip code",
                                  detail: "Enter Zip code",
                                  editingController: zipCodeController,
                                  validator: (value) =>
                                      FormValidator.validateName(value)),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1,
                                        color: ThemeColors.primaryBlueColor
                                            .withOpacity(0.3))),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF399BC4),
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  bottom:
                                                  Radius.circular(20))),
                                          child: const Text(
                                            "Available days for training",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text("Days:"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 100,
                                        child: GridView.count(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4.0,
                                            childAspectRatio: 3.0,
                                            mainAxisSpacing: 10.0,
                                            children: [
                                              ...days.map((day) =>
                                                  buildDayChip(day: day))
                                            ]),
                                      ),
                                      const Text("Slots per Day"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ...daysSelected.map(
                                            (e) =>
                                            buildTimeOfDay(
                                                day: e["day"],
                                                timeFrom: e["from"],
                                                timeTo: e["to"]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: EditDetailsWidget(
                                        title: "Class duration",
                                        detail: "1 hr",
                                        editingController: classDuration,
                                        validator: (value) =>
                                            FormValidator.validateName(value)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: EditDetailsWidget(
                                      title: "Teaching mode",
                                      detail: "Online/Offline",
                                      editingController: teachingMode,
                                      validator: (value) {
                                        if (value == "Online" ||
                                            value == "Offline" ||
                                            value == "Online/Offline") {
                                          return null; // Valid input
                                        } else {
                                          return "Invalid input"; // Detailed error message
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: EditDetailsWidget(
                                        title: "Subjects",
                                        detail: "Your subject",
                                        editingController: subject,
                                        validator: (value) =>
                                            FormValidator.validateName(value)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: EditDetailsWidget(
                                        title: "Fee",
                                        detail: "10,000/mon",
                                        editingController: fee,
                                        validator: (value) =>
                                            FormValidator.validateName(value)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Location",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          color: Colors.black54,
                                          fontSize: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              .034,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        _getLocation();
                                      },
                                      child: const Text("Detect")),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Upload class video",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * .03,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await pickVideos();
                                  for (var video in _videos) {
                                    await uploadVideo(video);
                                  }
                                  setState(() {});
                                },
                                child: SizedBox(
                                  height: 200,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: ListView.builder(
                                    itemCount: _videos.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(_videos[index].name),
                                        onLongPress: () async {
                                          await deleteVideo(classVideos[index]);
                                          _controllers[index].dispose();
                                          _controllers.removeAt(index);
                                          _videos.removeAt(index);
                                          classVideos.removeAt(index);
                                          Fluttertoast.showToast(
                                              msg: "Video deleted");
                                          setState(() {});
                                        },
                                        leading: _controllers[index]
                                            .value
                                            .isInitialized
                                            ? AspectRatio(
                                          aspectRatio: _controllers[index]
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(
                                              _controllers[index]),
                                        )
                                            : Container(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print("Hello world");
            // Call method to generate JSON data and print it
            var postData = printDataToJson();
            postTeacher(postData);
          },
          label: const Text(
            "      Create profile      ",
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyBanner(),
    );
  }
}

class MyBanner extends StatefulWidget {
  const MyBanner({super.key});

  @override
  _MyBannerState createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  List<String> imageUrls = [
    "https://nwlc.org/wp-content/uploads/2017/04/black-teacher.jpg",
    "https://nwlc.org/wp-content/uploads/2017/04/black-teacher.jpg",
    "https://nwlc.org/wp-content/uploads/2017/04/black-teacher.jpg",
    "https://nwlc.org/wp-content/uploads/2017/04/black-teacher.jpg",
    // Add more image URLs as needed
  ];

  Future<void> _getImageFromGallery() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload the image to the server
      await uploadImage(File(pickedFile.path));
    }
  }

  Future<void> uploadImage(File imageFile) async {
    // Open a byte stream
    var stream = http.ByteStream(imageFile.openRead());
    // Get the length of the file
    var length = await imageFile.length();

    // Parse the URL
    var uri = Uri.parse("https://xyzabc.sambhavapps.com/v1/media/uploads");

    // Create a multipart request
    var request = http.MultipartRequest("POST", uri);

    // Create a multipart file using the byte stream, length of the file and the filename
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: imageFile.path
            .split("/")
            .last,
        contentType: MediaType('image', 'jpeg'));

    // Add the file to the multipart request
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    // Listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      // Get the download URL and append it to imageUrls
      var downloadUrl = value; // Replace this with the actual parsing logic
      setState(() {
        imageUrls.add(downloadUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 200,
        margin: const EdgeInsets.all(5),
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20.0,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 1,
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          imageUrls.remove(url);
                        });
                      },
                      child: Image.network(
                        url,
                        height: 200,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width, // set width to screen width
                        fit: BoxFit.cover, // set fit to BoxFit.cover
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _getImageFromGallery();
                },
                child: Container(
                  color: Colors.black
                      .withOpacity(0.7), // semi-transparent black background
                  child: const Text(
                    "Tap to add image , long press to remove image",
                    style: TextStyle(
                      color: Colors.white, // white text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
