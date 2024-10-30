import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';

import 'package:lottie/lottie.dart';

import '../../../../../../../themes/colors.dart';

class HomeWork extends StatefulWidget {
  const HomeWork({Key? key}) : super(key: key);

  @override
  State<HomeWork> createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: const AppBarWidget(title: "Home Work", size: 55),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          SizedBox(
            height: 300,
            child: Lottie.network(
                "https://lottie.host/0af03de1-a122-4e66-bd97-28de5c7cdf1b/yNQ9f5b84H.json",
                width: MediaQuery
                    .of(context)
                    .size
                    .width, fit: BoxFit.fill),

          ),
          ...List.generate(
            3,
                (index) => buildSingleHomeWork(size),
          ),
        ]),
      ),
    );
  }

  Widget buildSingleHomeWork(Size size) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 70,
              height: 70,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://ramximgs.sambhavapps.com/education/pd/1699581107765-50827917_1395512337293797_456388872754954240_n.png"),
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                "Homework Title 1 ",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: ThemeColors.darkBlueColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: ThemeColors.darkBlueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {

              },
              child: const Text(
                "Submit Now",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
