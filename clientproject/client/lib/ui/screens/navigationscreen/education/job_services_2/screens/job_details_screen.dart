import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../themes/colors.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.darkBlueColor,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        toolbarHeight: 75,
        title: const Text(
          "Liberium Global Researchers and company",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              overflow: TextOverflow.ellipsis),
        ),
        actions: [
          Container(
            width: 40,
          )
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(tabs: [
              Tab(
                child: Text("JOB DETAILS"),
              ),
              Tab(
                child: Text("COMPANY PROFILE"),
              )
            ]),
            Expanded(
                child: TabBarView(children: [
              Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: OverflowBar(
                   // layoutBehavior: ButtonBarLayoutBehavior.padded,
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton.icon(
                          icon: const Icon(Icons.email_outlined),
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) ,
                            // ));
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            // bagroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.blue)),

                            textStyle: const TextStyle(
                              fontSize: 16,
                            ), // Set text style
                          ),
                          label: const Text(
                            'Apply',
                            style: TextStyle(
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      ElevatedButton.icon(
                          icon: const Icon(Icons.call_outlined),
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) ,
                            // ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.blue)),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ), // Set text style
                          ),
                          label: const Text(
                            'Click to call HR',
                            style: TextStyle(
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ]),
                body: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Sales Executive"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(" ₹ 12,000-14,000"),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(child: const Text("Location")),
                      Container(child: const Text("Experience"))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(child: const Text("Qualification")),
                      Container(child: const Text("English"))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(child: const Text("Job Info")),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(child: const Text("Job Timing")),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(child: const Text("Job Address")),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    child: const Column(
                      children: [
                        Text("INTERVIEW DETAILS"),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(),
                        ),
                        Text("Interview Time"),
                        Text("11:00 AM - 4:00 PM"),
                        Text("Monday to Sunday"),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Contact Person"),
                        Text("Dinesh")
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.all(10),
                    color: Colors.blue,
                    child: const ListTile(
                      leading: Icon(
                        Icons.message_outlined,
                        color: ThemeColors.darkBlueColor,
                      ),
                      title: Text(
                          "Dont pay any money to HR if not mentioned in job details."),
                    ),
                  ),
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(color: Colors.red))),
                          icon: const Icon(
                            Icons.warning_amber,
                          ),
                          label: const Text("Report Job")),
                      OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ThemeColors.darkBlueColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    color: ThemeColors.darkBlueColor)),
                          ),
                          icon: const Icon(
                            Icons.play_arrow_outlined,
                          ),
                          label: const Text("Interview Tips"))
                    ],
                  )
                ]),
              ),
              const Column(
                children: [
                  CircleAvatar(),
                  Text(
                    "LIBERIUM GLOBAL RESOURCES PRIVATE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("""
    LIBERIUM, is a fast-growing Human resource management, skilling and training company that has come up with innovative workforce solutions that effectively connects people potential to business requirements of organizations.
    
    We provide basic, yet critical services around lateral hiring, temporary staffing, training, remunerations processing and human resource business process outsourcing and ensure a quality service by imparting better hiring, quick back-filling, soft skill training, better understanding of customer needs, absolute adherence to compliance, quick turnaround time on associate/customer queries, extending legal support to safe-guard customers’ interests, beside other general service elements.
    """),
                  Divider(
                    thickness: 7,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Company Profile"),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Established Profile"),
                      Text("No. of Employees")
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text("Industry type"), Text("Perks & Benefits")],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Interview address")
                ],
              )
            ]))
          ],
        ),
      ),
    );
  }
}
