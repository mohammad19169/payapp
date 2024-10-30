import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/notes/screens/select_subject_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../../config/route_config.dart';
import '../notes_main_screen.dart';
import 'build_class_container.dart';

import 'package:http/http.dart' as http;

// final List<String> classes = [
//   'Class One',
//   'Class Two',
//   'Class Three',
//   'Class four',
//   'Class five',
//   'Class six',
//   'Class seven',
//   'Class eight',
//   'Class nine',
//   'Class ten',
// ];

class SelectClassesList extends StatelessWidget {
  const SelectClassesList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String token = snapshot.data ?? '';
          return FutureBuilder(
            future: _callApiWithToken(token),
            builder: (context, apiSnapshot) {
              if (apiSnapshot.connectionState == ConnectionState.done) {
                var res = apiSnapshot.data;
                if (res is List) {
                  print("Length : ");
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: res.length,
                    itemBuilder: (context, index) {
                      // Print all classes with their index
                      print("Class : ${res[index]} Index : $index");
                      return buildClassContainer(
                        context,
                        index,
                        res[index]["name"],
                        onTap: () {
                          Navigator.pop(context);
                          RouteConfig.navigateToRTL(
                              context,
                              SelectSubjectScreen(
                                classNumber: res[index]["name"],
                                classId: res[index]["id"],
                              ));
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
    );
    // return ListView.separated(
    //   shrinkWrap: true,
    //   physics: const BouncingScrollPhysics(),
    //   itemBuilder: (context, index) => buildClassContainer(
    //     context,
    //     index,
    //     classes[index],
    //     onTap: () {
    //       Navigator.pop(context);
    //       RouteConfig.navigateToRTL(
    //           context,
    //           SelectSubjectScreen(
    //             classNumber: classes[index],
    //           ));
    //     },
    //   ),
    //   separatorBuilder: (context, index) => const SizedBox(height: 10),
    //   itemCount: 10,
    // );
  }

  Future<String> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ??
        ''; // Default to empty string if token is not found
  }

  Future _callApiWithToken(String token) async {
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      var apiUrl =
          Uri.parse('https://xyzabc.sambhavapps.com/v1/education/class');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
