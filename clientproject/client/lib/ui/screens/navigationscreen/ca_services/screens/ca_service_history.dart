import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/provider/loginSignUpProvider.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/order_success_status.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/caservicesprovider/ca_services_provider.dart';

class CaServiceHistory extends StatefulWidget {
  const CaServiceHistory({Key? key}) : super(key: key);

  @override
  State<CaServiceHistory> createState() => _CaServiceHistoryState();
}

class _CaServiceHistoryState extends State<CaServiceHistory> {


  void seeOrders( ){
    Timer(const Duration(milliseconds: 600), (){
      RouteConfig.navigateTo(context, const OrderSuccessStatus());
    });
  }


  @override
  void initState() {
    super.initState();

    seeOrders();

    final userProvider =
        Provider.of<LoginSignUpProvider>(context, listen: false);
    final caServiceProvider =
        Provider.of<CaServicesProvider>(context, listen: false);
    if (userProvider.userModel != null) {
      caServiceProvider.isLoading = true;
      caServiceProvider.getServiceHistory(userId: userProvider.userModel!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "History",
        size: 55,
      ),
      body: Consumer<CaServicesProvider>(
          builder: (context, caServiceProvider, child) {
        return caServiceProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : caServiceProvider.serviceHistory.isEmpty
                ? const Center(
                    child: Text(
                      "Not Available",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    itemBuilder: (_, index) {
                      return Container(
                          height: 70,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10)
                              ]),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        caServiceProvider
                                            .serviceHistory[index].title,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Text(
                                        DateFormat('yyyy-MM-dd ').format(
                                          DateTime.parse(caServiceProvider
                                              .serviceHistory[index].date),
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                    "₹ ${caServiceProvider.serviceHistory[index].amount}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17))
                              ]));
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                    itemCount: caServiceProvider.serviceHistory.length);
      },),
    );
  }
}
