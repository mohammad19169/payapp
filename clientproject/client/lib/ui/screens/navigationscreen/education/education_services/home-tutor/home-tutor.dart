import 'package:flutter/material.dart';

import '../../../../../widgets/app_bar_widget.dart';
import '../../shared_widgets/educate_yourself_banner.dart';
import '../../shared_widgets/find_service_search_bar.dart';
import '../../shared_widgets/tutors_carousel_banner.dart';
import '../../shared_widgets/tutors_categories_builder.dart';


class HomeTutor extends StatelessWidget {
  const HomeTutor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarWidget(title: 'Home Tutor', size: 55),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EducateYourselfBanner(),
            const FindServiceSearchBar(),
            TutorsCarouselBanners(imgList: imgList),
            const TutorsCategoriesBuilder(),
          ],
        ),
      ),
    );
  }
}
