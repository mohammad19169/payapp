import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/models/contacts_model.dart';
import 'package:payapp/models/rechargeservicesmodels/mobile/plansmodel.dart';
import 'package:payapp/provider/rechargeServiceProvider.dart';
import 'package:payapp/ui/screens/navigationscreen/homescreen/rechargeservices/mobile/payscreen.dart';

class CategorisedPlansWidget extends StatefulWidget {
  final PlansModel plansModel;
  final String category;
  final ContactsModel contactsModel;
  final RechargeServicesProvider rechargeServicesProvider;

  const CategorisedPlansWidget(
      {Key? key,
      required this.plansModel,
      required this.category,
      required this.contactsModel,
      required this.rechargeServicesProvider})
      : super(key: key);

  @override
  State<CategorisedPlansWidget> createState() => _CategorisedPlansWidgetState();
}

class _CategorisedPlansWidgetState extends State<CategorisedPlansWidget>
    with AutomaticKeepAliveClientMixin<CategorisedPlansWidget> {
  final List<PlanModel> plans = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in widget.plansModel.plans) {
      if (element.planType == widget.category) {
        printThis(element.price);
        plans.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return plans.isEmpty
        ? Center(
            child: Text(
              "Not Available",
              style: GoogleFonts.poppins(fontSize: 20),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.black12.withOpacity(.05),
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    //Hit the verification Api
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayScreen(
                                  contactsModel: widget.contactsModel,
                                  planModel: plans[index],
                                  plansModel: widget.plansModel,
                                  rechargeServicesProvider:
                                      widget.rechargeServicesProvider,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),

                      // boxShadow: [
                      //   BoxShadow(
                      //     offset: Offset(0, 0),
                      //     color: Color(0xff2057A6).withOpacity(0.1),
                      //     blurRadius: 10,
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${plans[index].price}",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Icon(
                              Iconsax.arrow_right,
                            )
                          ],
                        ),
                        Text(
                          "TalkTime : ${plans[index].talkTime}",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                        Text(
                          "Validity : ${plans[index].validity}",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                        Text(
                          plans[index].packageDescription,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
