import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/models/subjectmodel.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/notes/screens/select_chapter_screen.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../../../provider/education_providers/student_providers/student_notes_provider.dart';

final List<String> demoSubjects = [
  'Subject one',
  'Subject two',
  'Subject three',
  'Subject four',
  'Subject five',
  'Subject six',
  'Subject seven',
  'Subject eight',
  'Subject nine',
  'Subject ten',
];

class SelectSubjectScreen extends StatefulWidget {
  const SelectSubjectScreen(
      {super.key, required this.classNumber, required this.classId});

  final String classNumber;

  final String classId;

  @override
  State<SelectSubjectScreen> createState() => _SelectSubjectScreenState();
}

class _SelectSubjectScreenState extends State<SelectSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return StudentNotesProvider()..getSubjects(classId: widget.classId);
      },
      child: Consumer<StudentNotesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
           backgroundColor: const Color(0xffF7F7F7),
            appBar: AppBarWidget(title: widget.classNumber, size: 55),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ConditionalBuilder(
                  condition: !provider.isLoadingSubjects,
                  fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBar(
                        elevation: WidgetStateProperty.all(1),
                        hintText: 'Search for a specific subject',
                        hintStyle: WidgetStateProperty.all(
                          const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Lottie.asset(
                            'assets/lottie/search_icon.json',
                            height: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (provider.subjectsList.isNotEmpty)
                        const Text(
                          'Select Subject',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ThemeColors.darkBlueColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 10),
                      ConditionalBuilder(
                        condition: provider.subjectsList.isNotEmpty,
                        fallback: (context) => Center(
                          child: Column(
                            children: [
                              SizedBox(
                                child: Lottie.asset(
                                    'assets/lottie/not_found.json'),
                              ),
                              const Text(
                                'No subjects Found!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ThemeColors.darkBlueColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        builder: (context) => GridView.builder(
                          itemBuilder: (context, index) =>
                              buildSubjectContainer(
                            subject: provider.subjectsList[index],
                            onTap: () => RouteConfig.navigateToRTL(
                              context,
                              SelectChapterScreen(
                                classNumber: widget.classNumber,
                                subject: provider.subjectsList[index].name,
                                subjectId: provider.subjectsList[index].id,
                              ),
                            ),
                          ),
                          itemCount: provider.subjectsList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 1),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InkWell buildSubjectContainer(
      {required VoidCallback onTap, required SubjectModel subject}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: ThemeColors.lightBlueCard,
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              child: Image.network(
                subject.logo,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ThemeColors.darkBlueColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const Text(
            //   '32 Chapters',
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     color: Colors.grey,
            //     fontSize: 14.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            //  const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
