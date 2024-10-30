import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:payapp/config/apiconfig.dart';
import 'package:payapp/models/earnoffermodel.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/earn_section/sub_screens/apply_offer_form_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/earn_section/tabs/details_tab.dart';
import 'package:payapp/ui/screens/navigationscreen/earn_section/tabs/share_media_tab.dart';
import 'package:payapp/ui/screens/navigationscreen/earn_section/tabs/stats_tab.dart';
import 'package:payapp/ui/screens/navigationscreen/earn_section/tabs/training_tab.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:payapp/widgets/tabs_bar_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/animations/dot_loder_widget.dart';
import '../../../../../core/animations/shimmer_animation.dart';
import '../../../../../core/components/tab_indicator.dart';
import '../../../../../core/utils/helper/helper.dart';
import '../../../../../themes/icons_broken.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String title;
  final String offerId;

  const OfferDetailsScreen(
      {Key? key, required this.title, required this.offerId})
      : super(key: key);

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  var offer;
  bool isLoading = true; //

  @override
  void initState() {
    super.initState();
    _fetchOffer();
  }

  Future<void> _fetchOffer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var apiUrl = Uri.parse('https://xyzabc.sambhavapps.com/v1/earn/offers');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response 1 status code: ${response.statusCode}");

      print("Response 1 body: ${response.body}");

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        final firstElement = decodedResponse["data"]
            .firstWhere((e) => e["id"] == widget.offerId, orElse: () => null);

        if (firstElement != null) {
          var apiUrl2 = Uri.parse(
              'https://xyzabc.sambhavapps.com/v1/earn/offer/cat/${firstElement["cat_id"]['id']}');

          var response2 = await http.get(
            apiUrl2,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          print("Response 2 status code: ${response2.statusCode}");

          print("Response 2 body: ${response2.body}");
          if (response2.statusCode == 200) {
            var decodedResponse2 = jsonDecode(response2.body);
            final firstElement2 = decodedResponse2["data"].firstWhere(
                (e) => e["id"] == widget.offerId,
                orElse: () => null);
            setState(() {
              offer = firstElement2;
              isLoading = false;
            });
          } else {
            print(
                'API Request Failed with Status Code: ${response2.statusCode}');
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print('No offer found with id ${widget.offerId}');
          setState(() {
            isLoading = false;
          });
        }
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
  Widget build(BuildContext context) {
    print(offer);
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ThemeColors.darkBlueColor,
                ),
              ),
              elevation: 5,
              centerTitle: true,
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: ThemeColors.darkBlueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              collapsedHeight: 250,
              stretch: true,
              flexibleSpace: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: offer != null
                          ? CarouselSlider.builder(
                              itemCount: offer["banner_img"].length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    offer["banner_img"][itemIndex],
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const ShimmerAnimation();
                                    },
                                  ),
                                ),
                              ),
                              options: CarouselOptions(
                                height: 170,
                                viewportFraction: 0.95,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : const SizedBox(), // Placeholder widget if offer is null
                    ),

            ),
          ],
          body: isLoading
              ? const Center(
                  child: KSProgressAnimation(
                    dotsColor: ThemeColors.primaryBlueColor,
                  ),
                )
              : offer==null? const Text(""): Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width:1,color:Colors.black.withOpacity(0.5))
                    ),
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      labelColor:  Colors.white,
                      isScrollable: true,// Selected label color
                      unselectedLabelColor:
                      Colors.grey.shade500,

                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.only(top:6,bottom:6,left:10,right:10),
                      indicatorPadding: const EdgeInsets.only(top:5,bottom:5,left:6,right:6),
                      labelStyle: const TextStyle(
                        fontSize: 14, // Font size for selected label
                        fontWeight: FontWeight.w500, // Font weight for selected label
                      ),
                      indicator: BoxDecoration(
                        color: const Color(0xFF0080FF).withOpacity(0.7), // Indicator color
                        borderRadius: BorderRadius.circular(25.0), // Rounded indicator
                      ),
                      tabs: const [
                        Tab(text: 'Description'),
                        Tab(text: 'Terms'),
                        Tab(text: 'Benefits'),
                        Tab(text: 'How it works'),
                        Tab(text: 'Marketing'),
                        Tab(text: 'Training'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(3, 3),
                                    color: const Color(0xff2057A6).withOpacity(0.2),
                                    blurRadius: 20.0,
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3), width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Html(
                              data: offer?["description"] ?? "",
                              style: {
                                "body": Style(
                                  fontSize: FontSize(15),
                                  fontWeight: FontWeight.w700,
                                ),
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(3, 3),
                                    color: const Color(0xff2057A6).withOpacity(0.2),
                                    blurRadius: 20.0,
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3), width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Html(
                              data: offer!=null? offer["terms"] ?? "":"",
                              style: {
                                "body": Style(
                                  fontSize: FontSize(15),
                                  fontWeight: FontWeight.w700,
                                ),
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(3, 3),
                                    color: const Color(0xff2057A6).withOpacity(0.2),
                                    blurRadius: 20.0,
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3), width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Html(
                              data:offer!=null? offer["benefits"]:"",
                              style: {
                                "body": Style(
                                  fontSize: FontSize(15),
                                  fontWeight: FontWeight.w700,
                                ),
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(3, 3),
                                    color: const Color(0xff2057A6).withOpacity(0.2),
                                    blurRadius: 20.0,
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3), width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Html(
                              data:offer!=null? offer["how_work"]:"",
                              style: {
                                "body": Style(
                                  fontSize: FontSize(15),
                                  fontWeight: FontWeight.w700,
                                ),
                              },
                            ),
                          ),
                          const DetailsTab(),
                          const Text("Training")
                        ],
                      ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
