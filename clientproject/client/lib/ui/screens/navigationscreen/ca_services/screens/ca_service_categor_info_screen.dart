import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/data/api/api_client.dart';
import 'package:payapp/models/cacategorise_services.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/service_details_screen.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/views/kslistviewbuilder.dart';
import '../../../../../provider/caservicesprovider/ca_services_provider.dart';
import '../ca_widget/ca_tile_widget.dart';

import 'package:http/http.dart' as http;

class CaServiceCategoryInfoScreen extends StatefulWidget {
  final String id;
  final String categoryTitle;

  final bool isCategory2;

  const CaServiceCategoryInfoScreen(
      {Key? key,
      required this.id,
      required this.categoryTitle,
      required this.isCategory2})
      : super(key: key);

  @override
  State<CaServiceCategoryInfoScreen> createState() =>
      _CaServiceCategoryInfoScreenState();
}

class _CaServiceCategoryInfoScreenState
    extends State<CaServiceCategoryInfoScreen> {
  @override
  void initState() {
    super.initState();
    final caServiceProvider =
        Provider.of<CaServicesProvider>(context, listen: false);
    caServiceProvider.getCategoriseServices(id: widget.id);
    caServiceProvider.isLoadingCategorised = true;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> loadToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      print("Login token ${prefs.getString('token')}");
      return prefs.getString('token') ??
          ''; // Default to empty string if token is not found
    }

    Future callApiWithToken(String token) async {
      try {
        // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
        var apiUrl = Uri.parse(widget.isCategory2
            ? 'https://xyzabc.sambhavapps.com/v1/ca/service/sub2/${widget.id}'
            : 'https://xyzabc.sambhavapps.com/v1/ca/service/sub/${widget.id}');
        print(
            "Url used ${widget.isCategory2 ? 'https://xyzabc.sambhavapps.com/v1/ca/service/sub2/${widget.id}' : 'https://xyzabc.sambhavapps.com/v1/ca/service/sub/${widget.id}'}");
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
        }
      } catch (error) {
      }
    }

    return Scaffold(
      appBar: AppBarWidget(title: widget.categoryTitle, size: 55),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: FutureBuilder<String>(
                future: loadToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String token = snapshot.data ?? '';
                    return FutureBuilder(
                      future: callApiWithToken(token),
                      builder: (context, apiSnapshot) {
                        if (apiSnapshot.connectionState ==
                            ConnectionState.done) {
                          var res = apiSnapshot.data;
                          if (res is List) {
                            return KSListView(
                              scrollDirection: Axis.vertical,
                              separateSpace: 10,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              itemCount: res.length,
                              itemBuilder: (context, index) {
                                return CaTileWidget(
                                  service: CaCategoriseServiceModel(
                                      id: res[index]["id"],
                                      cross_price: res[index]["cross_price"],
                                      description: 'text',
                                      image: res[index]["logo"],
                                      price: res[index]["price"],
                                      title: res[index]["title"]),
                                  onTap: () {
                                    RouteConfig.navigateTo(
                                      context,
                                      ServiceDetailsScreen(
                                          id: res[index]["id"],
                                          title: res[index]["title"]),
                                    );

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             CaFormScreen(
                                    //                 id: caServiceProvider
                                    //                     .categoriseServices[index].id
                                    //             )));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ServiceDetailsScreen(
                                    //                 id: caServiceProvider
                                    //                     .categoriseServices[index]
                                    //                     .id)));
                                  },
                                );
                              },
                            );
                          }

                          return Text(res.toString());
                        } else {
                          return const Text("Loading");
                        }
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            // Expanded(
            //   child: Consumer<CaServicesProvider>(
            //     builder: (context, caServiceProvider, child) {
            //       return caServiceProvider.isLoadingCategorised
            //           ? const Center(
            //               child: CircularProgressIndicator(
            //                 strokeWidth: 2,
            //               ),
            //             )
            //           : caServiceProvider.categoriseServices.isNotEmpty
            //               ? KSListView(
            //                   scrollDirection: Axis.vertical,
            //                   separateSpace: 10,
            //                   padding: const EdgeInsets.symmetric(
            //                     horizontal: 10,
            //                     vertical: 10,
            //                   ),
            //                   itemCount:
            //                       caServiceProvider.categoriseServices.length,
            //                   itemBuilder: (context, index) {
            //                     return CaTileWidget(
            //                       service: caServiceProvider
            //                           .categoriseServices[index],
            //                       onTap: () {
            //                         RouteConfig.navigateTo(
            //                           context,
            //                           ServiceDetailsScreen(
            //                             id: caServiceProvider
            //                                 .categoriseServices[index].id,
            //                             title: caServiceProvider
            //                                 .categoriseServices[index].title,
            //                           ),
            //                         );
            //
            //                         // Navigator.push(
            //                         //     context,
            //                         //     MaterialPageRoute(
            //                         //         builder: (context) =>
            //                         //             CaFormScreen(
            //                         //                 id: caServiceProvider
            //                         //                     .categoriseServices[index].id
            //                         //             )));
            //                         // Navigator.push(
            //                         //     context,
            //                         //     MaterialPageRoute(
            //                         //         builder: (context) =>
            //                         //             ServiceDetailsScreen(
            //                         //                 id: caServiceProvider
            //                         //                     .categoriseServices[index]
            //                         //                     .id)));
            //                       },
            //                     );
            //                   },
            //                 )
            //               : Center(
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Lottie.asset(
            //                       'assets/lottie/not_found.json',
            //                       width: MediaQuery.of(context).size.width / 1.3,
            //                     ),
            //                     const Text(
            //                       "No results found!",
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.normal,
            //                         fontSize: 14,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
