import 'package:flutter/material.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/scholarships/screens/samb_sch_res_screen.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:payapp/ui/widgets/scholorshipwidgets/scholorshiptile.dart';
import 'package:provider/provider.dart';

import '../../../../../../../provider/education_providers/education_provider.dart';

class SambhavScholarshipsResults extends StatefulWidget {
  const SambhavScholarshipsResults({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SambhavScholarshipsResults> createState() => _SambhavScholarshipsResultsState();
}

class _SambhavScholarshipsResultsState extends State<SambhavScholarshipsResults> {
  @override
  void initState() {
    super.initState();
    final scholarshipProvider =
        Provider.of<EductionFormProvider>(context, listen: false);
    scholarshipProvider.getScholarships();
    scholarshipProvider.isLoadingCategorised = true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EductionFormProvider>(
      builder: (context, scholarshipProvider, child) {
        return Scaffold(
          appBar:  AppBarWidget(title: widget.title,size: 55),
          body: scholarshipProvider.isLoadingCategorised
              ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
            padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 100),
            physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
            itemCount: scholarshipProvider.scholarshipList.length,
            itemBuilder: (context, index) {
                return ScholarshipTile(
                  scholarship: scholarshipProvider.scholarshipList[index],
                  btnText: "View Result",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SambhavScholarshipsResultsScreen(),
                      ),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ScholarshipDetails(
                    //       isEnroll: false,
                    //       schDetail:
                    //       scholarshipProvider.scholarshipList[index],
                    //     ),
                    //   ),
                    // );
                  },
                );
            },
          ),
              ),
        );
      },
    );
  }
}
