import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:payapp/core/animations/shimmer_animation.dart';
import 'package:payapp/data/api/api_client.dart';
import 'package:payapp/provider/caservicesprovider/ca_services_provider.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/ca_testimonials_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/carousel_loading/carouse_loading.dart';
import '../../../../widgets/carousel_loading/carousel_view.dart';
import 'ca_widget/ca_recent_courses.dart';
import 'ca_widget/ca_services_consumer.dart';
import 'ca_widget/ca_video_consumer.dart';
import 'package:payapp/widgets/carousel_loading/carousel_view.dart' as sliderView;

class CaServicesScreen extends StatefulWidget {
  const CaServicesScreen({Key? key}) : super(key: key);

  @override
  State<CaServicesScreen> createState() => _CaServicesScreenState();
}

class _CaServicesScreenState extends State<CaServicesScreen> {
  bool isLoading = true;
  bool isTestimonalLoading=true;
  List banners = [];

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchTestimonials();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchBanners() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.getString('auth-token');
      var apiUrl = Uri.parse('https://xyzabc.sambhavapps.com/v1/ca/banner');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $loginToken',
        },
      );

      if (response.statusCode == 200) {


        var decodedResponse = jsonDecode(response.body);
        var responseData = decodedResponse["data"];
        for (var data in responseData) {
          var bannersData = data["banners"];

          setState(() {
            banners
                .addAll(bannersData.map<String>((banner) => banner.toString()));
          });
        }
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }
  late List<dynamic> _testimonials = [];

  Future<void> _fetchTestimonials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('auth-token');

    final response = await http.get(
      Uri.parse('https://xyzabc.sambhavapps.com/v1/ca/testimonial'),
      headers: {'Authorization': 'Bearer $loginToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _testimonials = json.decode(response.body)['data'];
        isTestimonalLoading = false;
      });
    } else {
      throw Exception('Failed to load testimonials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: Colors.white,
        child: SizedBox(
          height: 500,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Column(
                children: [
                  isLoading && isTestimonalLoading
                      ? const Center(child: CircularProgressIndicator())
                      : banners.isEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          ShimmerAnimation(),
                          Text(
                              'Unknown error occured! Please Log in and try again'),
                        ],
                      ),
                    ),
                  )
                      : sliderView.CarouselView(
                    bannerList: banners,
                    withBaseUrl: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  CAVideoConsumer(),
                  const CAServicesConsumer(),

                  const CaRecentCourses(),
                  CaTestimonials(testimonials: _testimonials,),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
