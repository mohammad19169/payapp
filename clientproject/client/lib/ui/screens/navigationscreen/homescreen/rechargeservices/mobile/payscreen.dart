import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/models/contacts_model.dart';
import 'package:payapp/models/rechargeservicesmodels/mobile/plansmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../../provider/rechargeServiceProvider.dart';
import '../../../../../../themes/colors.dart';
import '../../../../../widgets/app_bar_widget.dart';


class PayScreen extends StatefulWidget {
  final PlanModel planModel;
  final PlansModel plansModel;
  final ContactsModel contactsModel;
  final RechargeServicesProvider rechargeServicesProvider;
  const PayScreen({Key? key,required this.planModel,required this.plansModel, required this.contactsModel,required this.rechargeServicesProvider}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.rechargeServicesProvider,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue.shade50,
        appBar: const AppBarWidget(
          title: "Pay",
          size: 55,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                                        widget.contactsModel.name,
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Text(
                                        widget.contactsModel.number,
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
                    Consumer<RechargeServicesProvider>(builder: (context, rechargeServiceProvider, child) {
                      return Container(
                        width:double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),


                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("₹ ${widget.planModel.price}",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                            Text("TalkTime : ${widget.planModel.talkTime}",style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.grey),),
                            Text("Validity : ${widget.planModel.validity}",style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.grey),),
                            Text(widget.planModel.packageDescription,style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.grey),),

                          ],),
                      );
                    }),
                    const SizedBox(height: 20,),
                    Material(
                      color: ThemeColors.primaryBlueColor,
                      borderRadius: BorderRadius.circular(1000),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(1000),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.white24,
// splashColor: ,
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000)),
                          child: Center(
                            child: Text(
                              "Proceed To Pay",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
