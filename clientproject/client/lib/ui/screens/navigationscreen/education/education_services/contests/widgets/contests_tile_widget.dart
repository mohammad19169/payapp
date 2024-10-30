import 'package:flutter/material.dart';
import 'package:payapp/models/contest_model.dart';
import 'package:payapp/themes/colors.dart';

class ContestTileWidget extends StatelessWidget {
  final ContestModel contest;
  final Function()? onTap;

  final String? label;

  const ContestTileWidget({Key? key, required this.contest, this.onTap, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.cyanAccent.withOpacity(.5),
          // image: const DecorationImage(
          //   fit: BoxFit.cover,
          //   image: AssetImage(
          //     'assets/images/educationscreen/students_lead_header.png',
          //   ),
          // ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${contest.awards_description}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Award: ${contest.awards_description}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Fee: 💲${contest.fee}',
              style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15.0),
            Align(alignment: Alignment.bottomRight,
              child:  ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                ),
                child:  Text(
                  label??'Participate Now',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
