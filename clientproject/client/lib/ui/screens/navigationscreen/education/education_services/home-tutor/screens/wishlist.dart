import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../../../../../widgets/app_bar_widget.dart';
import '../../../shared_widgets/build_teacher_card.dart';

class WishlistHomeTutor extends StatefulWidget {
  const WishlistHomeTutor({Key? key}) : super(key: key);

  @override
  State<WishlistHomeTutor> createState() => _WishlistHomeTutorState();
}

class _WishlistHomeTutorState extends State<WishlistHomeTutor> {
  // final List _teachersProfile = [
  //   "https://www.pngall.com/wp-content/uploads/4/Male-Teacher-PNG-Picture.png",
  //   "https://www.pngall.com/wp-content/uploads/4/Female-Teacher-PNG-Free-Download.png",
  //   "https://cutewallpaper.org/24/teacher-png/teacher-6e753-png.png",
  //   "https://www.pngall.com/wp-content/uploads/4/Male-Teacher-PNG-Picture.png",
  //   "https://www.pngall.com/wp-content/uploads/4/Female-Teacher-PNG-Free-Download.png",
  //   "https://cutewallpaper.org/24/teacher-png/teacher-6e753-png.png",
  // ];

  List _teachersProfile = [];
  bool isLoading = true;
  Future<void> _fetchTeachersProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var apiUrl = Uri.parse('https://xyzabc.sambhavapps.com/v1/wishlist');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var responseData = decodedResponse["wishlist"];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchTeachersProfile();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const AppBarWidget(title: 'Teachers Wishlist', size: 55),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1 / 2,
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
            ],
          ),
        ),
      ),
    );
  }
}
