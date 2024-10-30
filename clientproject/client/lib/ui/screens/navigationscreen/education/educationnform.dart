import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payapp/models/classes_and_exam_model.dart';
import 'package:payapp/models/usermodel.dart';
import 'package:payapp/provider/loginSignUpProvider.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/i_am_student/student_education_home_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/jobs/jobs.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/jobs/myjobspage.dart';
import 'package:provider/provider.dart';
import '../../../../provider/education_providers/education_provider.dart';
import 'education_services/components/selectionButton.dart';
import 'educationform.dart';



class EducationNewFormScreen extends StatefulWidget {
  const EducationNewFormScreen({Key? key}) : super(key: key);

  @override
  State<EducationNewFormScreen> createState() => _EducationNewFormScreenState();
}

class _EducationNewFormScreenState extends State<EducationNewFormScreen>
    with AutomaticKeepAliveClientMixin<EducationNewFormScreen> {
  final value = ValueNotifier<EducationType?>(null);
  final List<TeachingStyle> _teachingStyles = [];
  final teachingStyleNotifier = ValueNotifier<List<TeachingStyle>>([]);
  final classNotifier = ValueNotifier<ClassesModel?>(null);
  final boardNotifier = ValueNotifier<String?>(null);
  final showExams = ValueNotifier<bool>(false);
  final examsNotifier = ValueNotifier<List<ExamsModel>>([]);
  final List<ExamsModel> _selectedExamsList = [];

  @override
  void initState() {
    super.initState();
    final educationProvider = Provider.of<EductionFormProvider>(context,listen: false);
    educationProvider.getClasses();
    educationProvider.getBoards();
    print("Tuko");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EductionFormProvider(),
      child: Scaffold(
        // appBar: AppBarWidget(
        //   title: "Form",
        //   size: 55,
        // ),
        backgroundColor: Colors.blue.shade50,
        body: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<EducationType?>(
                          valueListenable: value,
                          builder: (context, educationType, child) {
                            return SelectionButton(
                              label: "I am a Student",
                              buttonColor:
                                  educationType == EducationType.student
                                      ? ThemeColors.primaryBlueColor
                                      : null,
                              textColor: educationType == EducationType.student
                                  ? Colors.white
                                  : null,
                              onTap: () {
                                value.value = EducationType.student;
                                final provider = Provider.of<LoginSignUpProvider>(context,listen: false);
                                final user = provider.userModel;
                                if(user!=null){
                                  if(user.educationType ==
                                      EducationType.student){
                                    Navigator.push(context, CupertinoPageRoute(builder: (context)=> const StudentEducationHomeScreen()));
                                  }
                                  else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const EducationFormScreen()));
                                  }
                                }
                              },
                            );
                          }),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: ValueListenableBuilder<EducationType?>(
                          valueListenable: value,
                          builder: (context, educationType, child) {
                            return SelectionButton(
                              label: "I am a Teacher",
                              buttonColor:
                                  educationType == EducationType.teacher
                                      ? ThemeColors.primaryBlueColor
                                      : null,
                              textColor: educationType == EducationType.teacher
                                  ? Colors.white
                                  : null,
                              onTap: () {
                                // value.value = EducationType.teacher;
                                // // Navigator.push(context, CupertinoPageRoute(builder: (context)=>TeacherDashBoard()));
                                // final provider = Provider.of<LoginSignUpProvider>(context,listen: false);
                                // final user = provider.userModel;
                                // if(user!=null){
                                //   print(user.educationType);
                                //   if(user.educationTypeTeacher ==
                                //               EducationType.teacher){
                                //     Navigator.push(context, CupertinoPageRoute(builder: (context) => const TeacherScreen()));
                                //   }else{
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //             const EducationFormScreen()));
                                //   }
                                // }

                              },
                            );
                          }),
                    ),
                    
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectionButton(
                              label: "Get Jobs",
                              buttonColor: null,
                              textColor: null,
                              onTap: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const JobsScreen()));
                              },
                            ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: SelectionButton(
                              label: "I Want To Hire",
                              buttonColor: null,
                              textColor: null,
                              onTap: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyJobsList()));
                              },
                            ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// Consumer<EductionFormProvider>(
// builder: (context, educationProvider, child){
// if(educationProvider.classSelected&&!educationProvider.boardSelected){
// return SelectBoardScreen();
// }
// else if(educationProvider.classSelected&&educationProvider.boardSelected&&!educationProvider.competitiveSelected){
// return SelectCompetitiveScreenWidget();
// }
// else{
// return GridView.builder(
// itemCount: educationProvider.classes.length,shrinkWrap: true,
// padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 3,
// childAspectRatio: (1 / 1.3), crossAxisSpacing: 15,mainAxisSpacing: 15),
// itemBuilder: (BuildContext context, int index) {
// // for(var element in categoryProvider.adminCategories){
// //   if(categoryProvider.categories[index].id==element.categoryId){
// //     categoryProvider.categories[index].image = element.image;
// //   }
// // }
// return ClassesWidget(classesModel: educationProvider.classes[index],onTap: (){
//
// educationProvider.selectedClass = index;
// educationProvider.notifyListeners();
// print(educationProvider.selectedClass);
// }, selected: educationProvider.selectedClass!=null?index==educationProvider.selectedClass?true:false:false,);
// },);
// }
//
// }),
// Expanded(child: Container()),
// Consumer<EductionFormProvider>(
// builder: (context, educationProvider, child){
// return GradientButton(onTap: () async {
//
// if(educationProvider.selectedClass!=null&&!educationProvider.classSelected){
// educationProvider.classSelected = true;
// educationProvider.notifyListeners();
// }
// else if(!educationProvider.boardSelected&&educationProvider.selectedBoard!=null){
// var status = await showAlert(context);
// if(status){
// educationProvider.boardSelected = true;
// educationProvider.notifyListeners();
// }
// else{
// final userProvider = Provider.of<LoginSignUpProvider>(context,listen: false);
// if(userProvider.userModel!=null){
// Map <String ,dynamic> data = {
// "user_id":userProvider.userModel!.id,
// "class_id": educationProvider.classes[educationProvider.selectedClass!].id,
// "board":educationProvider.boards[educationProvider.selectedBoard!],
// "competitive":"0",
// };
// showLoaderDialog(context);
// await educationProvider.submitForm(data: data);
// // await userProvider.getUser();
// Navigator.pop(context);
// Navigator.pop(context);
// print("No Competitive Api Hit Here");
// //Hit the Api
// print("Hit The Api");
// }
//
// }
//
// }
// else if(!educationProvider.competitiveSelected){
// print("Competitive");
// final List<bool> checkingList =
// educationProvider.selectionList.where((element) => element==true).toList();
// if(checkingList.isNotEmpty){
// print("Competitive Done");
// final userProvider = Provider.of<LoginSignUpProvider>(context,listen: false);
// if(userProvider.userModel!=null){
// final List competitiveExams = [];
// for (int i = 0; i<educationProvider.exams.length; i++) {
// if(educationProvider.selectionList[i]){
// competitiveExams.add(educationProvider.exams[i].id);
// }
// }
// print(competitiveExams);
// Map <String ,dynamic> data = {
// "user_id":userProvider.userModel!.id,
// "class_id": educationProvider.classes[educationProvider.selectedClass!].id,
// "board":educationProvider.boards[educationProvider.selectedBoard!],
// "competitive":"1",
// "competitive_exams": competitiveExams
// };
// showLoaderDialog(context);
// await educationProvider.submitForm(data: data);
// // await userProvider.getUser();
// Navigator.pop(context);
// Navigator.pop(context);
//
// }
// }
// }
//
//
// },text: "Continue",);
// }),
//
// SizedBox(height: 40,),
