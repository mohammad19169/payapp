import 'package:flutter/material.dart';
import 'package:payapp/themes/colors.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String location;
  final int responses;
  final int leads;
  final String status;
  final String postedDate;

  const JobCard({super.key, 
    required this.title,
    required this.location,
    required this.responses,
    required this.leads,
    required this.status,
    required this.postedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(status),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
              ]),
              Text(location),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  // height: 80,
                  // width: 100,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 180,
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeColors.darkBlueColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("0"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Responses till now '),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: ThemeColors.darkBlueColor,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 180,
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeColors.darkBlueColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("0"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Leads in Database '),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: ThemeColors.darkBlueColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Posted on: $postedDate"),
            ],
          ),
        ),
      ),
    );
  }
}
