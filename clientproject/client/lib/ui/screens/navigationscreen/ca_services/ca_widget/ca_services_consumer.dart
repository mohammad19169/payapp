import 'package:flutter/material.dart';
import 'package:payapp/data/api/api_client.dart';
import 'package:payapp/models/ca_models/home_services_model.dart';
import 'package:payapp/provider/caservicesprovider/ca_services_provider.dart';
import 'package:payapp/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/animations/dot_loder_widget.dart';
import '../../../../../core/animations/shimmer_animation.dart';
import 'ca_services_category_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<String> namesOfServices = [
  'GST Services',
  'Taxation Services',
  'Company Registration Services',
  'GST Services',
  'Taxation Services',
  'Company Registration Services',
  'GST Services',
  'Taxation Services',
  'Company Registration Services',
];

class CAServicesConsumer extends StatelessWidget {
  const CAServicesConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CaServicesProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Container(width:60,height:1,color:const Color(0xffD0CFCE)),
                    const SizedBox(width:15),
                    const Text(
                      "Our Services",
                      style: TextStyle(
                        fontSize: 20,
                        color: ThemeColors.darkBlueColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width:15),
                    Container(width:60,height:1,color:const Color(0xffD0CFCE)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                // height: 300,
                child: FutureBuilder<String>(
                  future: _loadToken(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String token = snapshot.data ?? '';
                      return FutureBuilder(
                        future: _callApiWithToken(token),
                        builder: (context, apiSnapshot) {
                          if (apiSnapshot.connectionState ==
                              ConnectionState.done) {
                            var res = apiSnapshot.data;
                            if (res is List) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: res.length + 1,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  //childAspectRatio: 1 / 1,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 10,
                                  //  childAspectRatio: 1.2 / .60,
                                ),
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return buildHistoryCategoryItem(context,
                                        title: 'History');
                                  } else {
                                    return buildCAServiceCategoryItem(
                                      context,
                                      callback: () {
                                        print(0);
                                      },
                                      model: CAHomeServicesDataModel(
                                          cat_img: res[index - 1]["cat_img"],
                                          catName: res[index - 1]["cat_name"],
                                          id: res[index - 1]["id"],
                                          status: res[index - 1]["status"]),
                                    );
                                  }
                                },
                              );
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: const Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ShimmerAnimation(),
                                    Text(
                                        'Unknown error occured! Please Log in and try again'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 300,
                              child: const Center(
                                child: KSProgressAnimation(
                                  dotsColor: ThemeColors.primaryBlueColor,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: const CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
              // SizedBox(
              //   child: GridView.builder(
              //     shrinkWrap: true,
              //     physics: const BouncingScrollPhysics(),
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //       //childAspectRatio: 1 / 1,
              //       mainAxisSpacing: 20,
              //       crossAxisSpacing: 10,
              //       //  childAspectRatio: 1.2 / .60,
              //     ),
              //     itemCount: provider.cAHomeServices.length + 1,
              //     itemBuilder: (context, index) {
              //       if (!provider.isLoadingCAHOmeServices) {
              //         if (index == 0) {
              //           return buildHistoryCategoryItem(context,
              //               title: 'History');
              //         } else {
              //           return buildCAServiceCategoryItem(
              //             context,
              //             model: provider.cAHomeServices[index - 1],
              //           );
              //         }
              //       } else {
              //         return GridView.builder(
              //           shrinkWrap: true,
              //           physics: const BouncingScrollPhysics(),
              //           gridDelegate:
              //               const SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 3,
              //             mainAxisSpacing: 20,
              //             crossAxisSpacing: 10,
              //           ),
              //           itemCount: provider.cAHomeServices.length + 1,
              //           itemBuilder: (context, index) => const ShimmerAnimation(
              //             width: 50,
              //             height: 40,
              //           ),
              //         );
              //       }
              //     },
              //   ),
              // ),
              const SizedBox(height: 15,)
            ],
          ),
        );
      },
    );
  }

  Future<String> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("Login token ${prefs.getString('token')}");
    return prefs.getString('token') ??
        ''; // Default to empty string if token is not found
  }

  Future _callApiWithToken(String token) async {
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      var apiUrl = Uri.parse('https://xyzabc.sambhavapps.com/v1/ca/category');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $loginToken',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        return decodedResponse["data"];
      } else {
        print('API Request Failed with Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error calling API: $error');
    }
  }
}
