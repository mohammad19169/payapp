import 'package:flutter/material.dart';
import 'package:payapp/themes/colors.dart';

import '../../../../widgets/app_bar_widget.dart';

class TrainingScreen extends StatelessWidget {
  final List<Map<String, String>> webinars = [
    {
      'title': 'Know Everything About \'My Team\' Feature',
      'date': '2023-07-21',
      'duration': '2:4'
    },
    {
      'title': 'Amazing Features of BankSathi App',
      'date': '2023-07-21',
      'duration': '7:30'
    },
    {
      'title': 'How to Add leads on BankSathi App',
      'date': '2023-07-21',
      'duration': '3:24'
    },
  ];

   TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Training',
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const ListTile(
            leading: Icon(Icons.event_busy),
            title: Text('No new training available'),
            subtitle:
                Text('We will be live soon. Please  come back after sometime.'),
          ),
          const Divider(),
          ...webinars.map((webinar) {
            return Card(
              child: ListTile(
                leading: Container(
                  color: Colors.green,
                  width: 60,
                ),
                title: Text(
                  webinar['title']!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: ThemeColors.darkBlueColor),
                ),
                subtitle: Text(
                    'Date: ${webinar['date']}   Duration: ${webinar['duration']}'),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
