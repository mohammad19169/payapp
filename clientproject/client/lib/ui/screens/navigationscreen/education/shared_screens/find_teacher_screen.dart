import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:payapp/themes/colors.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../widgets/app_bar_widget.dart';
import '../shared_widgets/build_teacher_card.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class FindTeacherScreen extends StatefulWidget {
  const FindTeacherScreen({super.key});

  @override
  State<FindTeacherScreen> createState() => _FindTeacherScreenState();
}

class _FindTeacherScreenState extends State<FindTeacherScreen> {
  bool isLoading = true;
  final Location _location = Location();

  String? _latitude;
  String? _longitude;
  List colors = [
    0xffDF300A,
    0xffF5A817,
    0xffBF17F5,
    0xff17EBF5,
    0xffF54D17,
    0xff1750F5,
    0xffBF17F5,
    0xff17EBF5,
    0xff1750F5,
  ];

  List<String> filterLabels = [
    'Near 1Km',
    'English',
    'Near 2Km',
    'Near 3Km',
    'Maths',
    'Near 4Km',
    'Near 5Km',
    'Hindi',
    'All subjects',
    'Class 5th',
    'Class 6th',
  ];
  List<IconData> filterIconData = [
    Icons.social_distance,
    Iconsax.flag,
    Icons.social_distance,
    Icons.social_distance,
    Iconsax.math,
    Icons.social_distance,
    Icons.social_distance,
    Iconsax.flag,
  ];
  final Set<int> _selectedItems = {};
  List _teachersProfile = [];

  Future<void> _fetchTeachersProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var apiUrl =
          Uri.parse('https://xyzabc.sambhavapps.com/v1/education/teacher');

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
          _teachersProfile = responseData;
          isLoading = false;
          print(_teachersProfile);
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

  Future<void> _fetchTeachersProfileByDistance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth-token');
      var apiUrl = Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/education/teacher');

      var response = await http.get(apiUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
         );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var responseData = decodedResponse["data"];
        setState(() {
          _teachersProfile = [];
          _teachersProfile = responseData;
          isLoading = false;
          print(_teachersProfile);
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
    // TODO: implement initState
    super.initState();
  //  _getLocation();
    _fetchTeachersProfile();
  }

  Future<void> _getLocation() async {
    try {
      var currentLocation = await _location.getLocation();
      setState(() {
        _latitude = currentLocation.latitude.toString();
        _longitude = currentLocation.longitude.toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarWidget(title: 'Find Home Teacher', size: 55),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: TextField(
                      onTap: () {
                        print("Fetching teachers from 10 KM ");
                        _fetchTeachersProfileByDistance();
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // contentPadding: const EdgeInsets.only(bottom: 5.0,left: 8.0),
                        hintText: 'Fetch from current location',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Lottie.asset(
                            'assets/lottie/search_icon.json',
                          ),
                        ),
                        border: InputBorder.none, // Remove the border
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const HorizontalItemList(),
                // const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1 / 2,
                    // childAspectRatio:
                    //     MediaQuery.of(context).size.height / size.height * 0.6,
                  ),
                  itemCount: _teachersProfile.length,
                  itemBuilder: (_, index) {
                    return BuildTeacherCard(
                      size: size,
                      title: _teachersProfile[index]["name"],
                      subTitle: _teachersProfile[index]["image"],
                      image: _teachersProfile[index]["image"],
                      rating: _teachersProfile[index]["rating"].toString(),
                      teacherId: _teachersProfile[index]["id"].toString(),
                    );
                  },
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        width: MediaQuery.of(context).size.width * 65,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: Colors.black.withOpacity(.85),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.filter_list_rounded,
                size: 25,
                color: Colors.white,
              ),
              label: Text(
                'Filter',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
            Container(width: .8, height: 30, color: Colors.grey),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.sort_rounded,
                size: 25,
                color: Colors.white,
              ),
              label: Text(
                'Sorting',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<List<String>> filters = [
  [
    'Distances',
    'Near 1Km',
    'Near 2Km',
    'Near 3Km',
    'Near 4Km',
    'Near 5Km',
  ],
  [
    'Subjects',
    'Maths',
    'Physics',
    'English',
    'Hindi',
    'Arabic',
  ],
  [
    'Fee(in Rupee)',
    '100/m',
    '200/m',
    '200/m',
    '200/m',
    '200/m',
  ],
];
List<String> distances = [
  'Distances',
  'Near 1Km',
  'Near 2Km',
  'Near 3Km',
  'Near 4Km',
  'Near 5Km',
];
List<String> subjects = [
  'Subjects',
  'Maths',
  'Physics',
  'English',
  'Hindi',
  'Arabic',
];
List<String> fees = [
  'Fee(in Rupee)',
  '100/m',
  '200/m',
  '200/m',
  '200/m',
  '200/m',
];

class HorizontalItemList extends StatelessWidget {
  const HorizontalItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        itemBuilder: (context, index) => DropdownButtonExample(
          menu: filters[index],
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key, required this.menu});

  final List<String> menu;

  @override
  _DropdownButtonExampleState createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  late String selectedFilter;

  void _showMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset offset = overlay.localToGlobal(const Offset(110, 220));
    showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: widget.menu
          .map(
            (
              filter,
            ) =>
                PopupMenuItem(
              child: Text(filter),
              onTap: () {},
            ),
          )
          .toList(),
    );
  }

  @override
  void initState() {
    selectedFilter = widget.menu.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _showMenu(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]!, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff2A63B8).withOpacity(.3),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: ThemeColors.darkBlueColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                selectedFilter,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
