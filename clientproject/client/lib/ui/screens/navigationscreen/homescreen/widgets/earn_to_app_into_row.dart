import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payapp/ui/screens/navigationscreen/homescreen/sambhav_home_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../config/hiveConfig.dart';
import '../../../../../core/animations/slide_animation.dart';
import '../../../../../core/services/hiveDatabase.dart';
import '../../../../../provider/setingsProvider.dart';
import '../../../../../view/base/not_logged_in_screen.dart';
import '../../../../dialogs/loaderdialog.dart';
import '../../../../widgets/box_button_widget.dart';
import '../accountmanager/accountmanager.dart';

class EarnToAppIntroRow extends StatelessWidget {
  const EarnToAppIntroRow({
    super.key,
    required this.widget,
  });

  final SambhavHomeScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SlideAnimation(
          fromRight: .4,
          child: BoxButtonWidget(
            pngIconPath: "assets/images/homescreen/rupee.png",
            title: "Earn",
            onTap: () async {
              Box box = await HiveDataBase.openBox(boxName: HiveConfig.user);
              final user = await HiveDataBase.getSingleItem(
                  key: HiveConfig.user, box: box);
              if (user == null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotLoggedInScreen(
                    callBack: (success) {
                      if (success) {
                        widget.navController.sink.add(1);

                        widget.pageController.animateToPage(
                          1,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ));
              } else {
                widget.navController.sink.add(1);

                widget.pageController.animateToPage(
                  1,
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
        SlideAnimation2(
          fromTop: .4,
          child: BoxButtonWidget(
            pngIconPath: 'assets/images/homescreen/add_fund.png',
            iconData: Icons.support_agent_outlined,
            title: "Account MGR",
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const AccountManagerScreen()));
            },
          ),
        ),
        SlideAnimation2(
          fromBottom: .4,
          child: BoxButtonWidget(
            pngIconPath: 'assets/images/homescreen/add_fund.png',
            title: 'Ca Services',
            iconData: Iconsax.medal_star,
            onTap: () async {
              Box box = await HiveDataBase.openBox(boxName: HiveConfig.user);
              final user = await HiveDataBase.getSingleItem(
                  key: HiveConfig.user, box: box);
              if (user == null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotLoggedInScreen(
                    callBack: (success) {
                      if (success) {
                        widget.navController.sink.add(2);

                        widget.pageController.animateToPage(
                          2,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ));
              } else {
                widget.navController.sink.add(2);

                widget.pageController.animateToPage(
                  2,
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
        Consumer<SettingsProvider>(builder: (_, settingsProvider, child) {
          return SlideAnimation2(
            fromTop: .4,
            child: BoxButtonWidget(
              pngIconPath: 'assets/images/homescreen/add_fund.png',
              iconData: Iconsax.video,
              title: 'App Intro',
              onTap: () async{
                 String videoLink=await settingsProvider.getIntroVideo();

                if (videoLink != "") {
                  showVideoDialog(context,
                      videoUrl: videoLink);
                }
              },
            ),
          );
        })
      ],
    );
  }
}
