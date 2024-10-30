import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/core/views/kslistviewbuilder.dart';
import 'package:payapp/core/views/searchview.dart';
import 'package:payapp/models/contacts_model.dart';
import 'package:payapp/provider/rechargeServiceProvider.dart';
import 'package:payapp/ui/screens/navigationscreen/homescreen/rechargeservices/mobile/operatoramountscreen.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:payapp/ui/widgets/nopermissionwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../../../../../models/CircleWisePlanLists.dart';
import '../../../../../dialogs/loaderdialog.dart';
import '../../../../../widgets/headingtile.dart';
import '../../../../../widgets/searchwidget.dart';
import 'all_recharge_packages_list.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({Key? key}) : super(key: key);

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {

  final rechargeServiceProvider = RechargeServicesProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printThis("this");

  }

  List<ContactsModel> filterList=[];
  List<ContactsModel> noMatchNumbers=[];
  bool isFilterEnable=false;
  String filterNumber="";


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: rechargeServiceProvider,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue.shade50,
        appBar: AppBarWidget(title: "Mobile Recharge",
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Consumer<RechargeServicesProvider>(builder: (context, rechargeServiceProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField<ContactsModel>(
                  searchInputDecoration:SearchInputDecoration(
                      filled: true,
                    hintStyle: GoogleFonts.poppins(color: Colors.grey,fontSize: 15),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1000),),

                  ) ,
                  onSearchTextChanged: (query) {
                    if(query==""){
                      setState(() {
                        isFilterEnable=false;
                        noMatchNumbers=[];
                      });
                    }
                    else{
                       filterList = rechargeServiceProvider.contacts
                          .where((element) =>
                      (element.name.toLowerCase().contains(query.toLowerCase()) || element.number.contains(query)))
                          .toList();
                     setState(() {

                     });
                       if(filterList.isEmpty){
                         if(query.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(query) && query.length == 10){
                           setState(() {
                             isFilterEnable=true;
                             noMatchNumbers.add(ContactsModel(name: "New User", number: query));
                           });
                           print(noMatchNumbers.length);
                         }
                         else{
                           setState(() {
                             isFilterEnable=true;
                             noMatchNumbers=[];
                           });
                         }
                       }
                    }
                    return null;

                  },
                  onTap: () async {
                  },
                  /// widget to show when suggestions are empty
                  hint: 'Search by Name or Number',

                  itemHeight: 50,
                  scrollbarDecoration: ScrollbarDecoration(),
                  suggestionStyle: const TextStyle(fontSize: 24, color: Colors.white),

                suggestionState: Suggestion.expand, suggestions: const [],
                ),
              );
            }),
          ),
          ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),

                    child: Consumer<RechargeServicesProvider>(builder: (context, rechargeServiceProvider, child) {
                      if(rechargeServiceProvider.result!=null&&(rechargeServiceProvider.result!.isPermanentlyDenied || rechargeServiceProvider.result!.isDenied)){
                        return const NoPermissionWidget();
                      }
                      return rechargeServiceProvider.contacts.isEmpty?
                          const Center(child: CircularProgressIndicator()):
                      (filterList.isNotEmpty )?KSListView(
                        itemCount: filterList.length,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        scrollDirection: Axis.vertical,separateSpace: 5,
                        itemBuilder: (context, index) {
                          return index==0?const HeadingTile(title: "All Contacts"):
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: ()async{
                                showLoaderDialog(context);
                                /* Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AllRechargePackagesList()));*/

                                List<CircleWisePlanLists>? circleList  = await rechargeServiceProvider.getCircleData(mobileNumber: "6390971282");
                                //await rechargeServiceProvider.getMobileRechargePlans(mobileNumber: "6390971282");
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AllRechargePackagesList(circleList: circleList??[],
                                    contactName:filterList[index-1].name,
                                      contactNumber:filterList[index-1].number ,
                                    )));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                height: 60,
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(filterList[index-1].name.substring(0,2).toUpperCase(),style:GoogleFonts.poppins(color: Colors.white)),
                                      ),

                                    ),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(filterList[index-1].name,style: GoogleFonts.poppins(),),
                                          Text(filterList[index-1].number,style: GoogleFonts.poppins(),),
                                        ],),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ):(filterList.isEmpty && isFilterEnable)?  KSListView(
                        itemCount: noMatchNumbers.length,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        scrollDirection: Axis.vertical,separateSpace: 5,
                        itemBuilder: (context, index) {

                         return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: ()async{
                                showLoaderDialog(context);
                                /* Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AllRechargePackagesList()));*/

                                List<CircleWisePlanLists>? circleList  = await rechargeServiceProvider.getCircleData(mobileNumber: "6390971282");
                                //await rechargeServiceProvider.getMobileRechargePlans(mobileNumber: "6390971282");
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AllRechargePackagesList(circleList: circleList??[],
                                      contactName:noMatchNumbers[0].name,
                                      contactNumber:noMatchNumbers[0].number ,
                                    )));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                height: 60,
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(noMatchNumbers[0].number.substring(0,2).toUpperCase(),style:GoogleFonts.poppins(color: Colors.white)),
                                      ),

                                    ),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(noMatchNumbers[0].name,style: GoogleFonts.poppins(),),
                                          Text(noMatchNumbers[0].number,style: GoogleFonts.poppins(),),
                                        ],),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ):

                      KSListView(
                        itemCount: rechargeServiceProvider.contacts.length+1,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        scrollDirection: Axis.vertical,separateSpace: 5,
                        itemBuilder: (context, index) {
                          return index==0?const HeadingTile(title: "All Contacts"):
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: ()async{
                                showLoaderDialog(context);
                               /* Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AllRechargePackagesList()));*/

                                List<CircleWisePlanLists>? circleList  = await rechargeServiceProvider.getCircleData(mobileNumber: "6390971282");
                                //await rechargeServiceProvider.getMobileRechargePlans(mobileNumber: "6390971282");
                                Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AllRechargePackagesList(circleList: circleList??[],  contactName:rechargeServiceProvider.contacts[index-1].name,
                                    contactNumber:rechargeServiceProvider.contacts[index-1].number ,)));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                height: 60,
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(rechargeServiceProvider.contacts[index-1].name.substring(0,2).toUpperCase(),style:GoogleFonts.poppins(color: Colors.white)),
                                      ),

                                    ),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(rechargeServiceProvider.contacts[index-1].name,style: GoogleFonts.poppins(),),
                                          Text(rechargeServiceProvider.contacts[index-1].number,style: GoogleFonts.poppins(),),
                                        ],),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchChild(contact) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.number),
    );
  }
}
