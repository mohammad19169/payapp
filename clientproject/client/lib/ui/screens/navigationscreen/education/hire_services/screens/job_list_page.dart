import 'package:flutter/material.dart';
import 'package:payapp/themes/colors.dart';

import '../components/job_card_widget.dart';
import '../components/offer_banner_widget.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text("Wallet Balance"),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "₹0",
                    style: TextStyle(
                        color: ThemeColors.darkBlueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                width: 140,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    child: Text("RECHARGE")),
              )
            ],
          ),
        ),
        OfferBanner(),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            width: 160,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.support_agent_outlined,
                  color: ThemeColors.darkBlueColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Call Customer Support",
                  style:
                      TextStyle(color: ThemeColors.darkBlueColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        JobCard(
          title: 'Customer Relations',
          location: 'Anand Vihar, Delhi / NCR',
          responses: 0,
          leads: 21344,
          status: 'Not Active',
          postedDate: '30th September 22',
        ),
        JobCard(
          title: 'PHP + LARAVEL & VUE',
          location: 'Indirapuram - Ghaziabad, Delhi / NCR',
          responses: 0,
          leads: 3828,
          status: 'Not Active',
          postedDate: '11th June 22',
        ),
      ],
    );
  }
}
