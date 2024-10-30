import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/core/views/kstabbarview.dart';
import 'package:payapp/models/contacts_model.dart';
import 'package:payapp/ui/screens/navigationscreen/homescreen/rechargeservices/mobile/categorisedplanswidget.dart';
import 'package:provider/provider.dart';

import '../../../../../../provider/rechargeServiceProvider.dart';
import '../../../../../widgets/app_bar_widget.dart';

class OperatorAmountScreen extends StatefulWidget {
  final ContactsModel contact;
  final RechargeServicesProvider rechargeServicesProvider;
  const OperatorAmountScreen({Key? key, required this.contact,required this.rechargeServicesProvider})
      : super(key: key);

  @override
  State<OperatorAmountScreen> createState() => _OperatorAmountScreenState();
}

class _OperatorAmountScreenState extends State<OperatorAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.rechargeServicesProvider,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue.shade50,
        appBar: const AppBarWidget(
          title: "Select a recharge plan",
          size: 55,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                 color: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://9to5google.com/wp-content/uploads/sites/4/2022/02/flutter-windows-promo.jpg?quality=82&strip=all&w=1600")),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.contact.name,
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    widget.contact.number,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.circular(1000)),
                        child: Center(

                          child:  Consumer<RechargeServicesProvider>(builder: (context, rechargeServiceProvider, child) {
                            return Text(
                              rechargeServiceProvider.plansModel!.operatorName,
                              style: GoogleFonts.poppins(),
                            );
                          }),
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                        height: 40,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.circular(1000)),
                        child: Center(
                          child:Consumer<RechargeServicesProvider>(builder: (context, rechargeServiceProvider, child) {
                            return Text(
                              rechargeServiceProvider.plansModel!.circleName,
                              style: GoogleFonts.poppins(),maxLines: 1,overflow: TextOverflow.ellipsis,
                            );
                          }),
                        ),
                      )),
                    ],
                  ),
                ),
                Expanded(

                  child:  Consumer<RechargeServicesProvider>(builder: (context, rechargeServiceProvider, child) {
                    return KsTabBarView(
                      initPosition: 0,
                      itemCount: rechargeServiceProvider.planCategories.length,
                      tabBuilder: (context, index) => Tab(
                        text: rechargeServiceProvider.planCategories[index],
                      ),
                      pageBuilder: (context, index) {

                        return Container(
                            color: Colors.blue.shade50,
                            child: CategorisedPlansWidget(plansModel: rechargeServiceProvider.plansModel!,category: rechargeServiceProvider.planCategories[index],contactsModel: widget.contact,rechargeServicesProvider: widget.rechargeServicesProvider));}
                        ,
                      onPositionChange: (index) {
                        printThis('current position: $index');
                        // initPosition = index;
                      },
                      onScroll: (position) => printThis('$position'),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SizedBox(
// height:MediaQuery.of(context).size.height*.25,
// child: Center(
// child: TextFormField(
// textAlign: TextAlign.center,maxLines: 1,
// // controller: mobileController,
// maxLength: 6,
// // validator: (value) =>
// // FormValidator.validateMobile(value),
// style: GoogleFonts.ubuntu(
// fontWeight: FontWeight.w500,
// fontSize: 50
// ),
//
// inputFormatters: [],
// keyboardType: TextInputType.number,
// cursorColor: ThemeColors.bluecolor,
// decoration: InputDecoration(
// isDense: true,
// counterText: "",
// // prefixIcon: const Padding(
// //   padding: EdgeInsets.all(8.0),
// //   child: Icon(
// //     Iconsax.mobile,
// //     size: 20,
// //     color: ThemeColors.blueColor,
// //   ),
// // ),
// filled: true,
// fillColor: Colors.white,
// contentPadding: const EdgeInsets.symmetric(
// vertical: 0, horizontal: 10),
// hintText: '0',
// hintStyle: GoogleFonts.ubuntu(
// fontWeight: FontWeight.w500,
// letterSpacing: 2),
// errorStyle: GoogleFonts.ubuntu(),
// enabledBorder: InputBorder.none,
// focusedBorder: InputBorder.none,
// border:  InputBorder.none,
// errorBorder: InputBorder.none,
// ),
// ),
// ),
// ),
// Material(
// color: ThemeColors.blueColor,
// borderRadius: BorderRadius.circular(1000),
// child: InkWell(
// borderRadius: BorderRadius.circular(1000),
// highlightColor: Colors.transparent,
// splashColor: Colors.white24,
// // splashColor: ,
// onTap: (){
//
// },
// child: Container(
// height: 50,
// width: 160,
// decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000)),
// child: Center(
// child: Text(
// "Proceed To Pay",
// style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: .5),
// ),
// ),
// ),
// ),
// ),
// SizedBox(height: 10,)
