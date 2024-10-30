import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../../../../../themes/colors.dart';
import '../../../../widgets/app_bar_widget.dart';

class ProceedToPayWithRechargePlan extends StatefulWidget {
  const ProceedToPayWithRechargePlan({super.key,
  required this.price,
    required this.planType,
    required this.validity,
    required this.planDesc,
    required this.talkTime,
    required this.contactName,required this.contactNumber

  });
  final String price,planType,talkTime,validity,planDesc;
  final String contactName;
  final String contactNumber;

  @override
  State<ProceedToPayWithRechargePlan> createState() => _ProceedToPayWithRechargePlanState();
}

class _ProceedToPayWithRechargePlanState extends State<ProceedToPayWithRechargePlan> {
  String body = "";
  String callback = "https://webhook.site/b7ad762c-b0e7-4772-a603-c9ec045b6b54";
  String checksum = "";

  Map<String, String> headers = {};
  List<String> environmentList = <String>['SANDBOX', 'PRODUCTION'];
  bool enableLogs = true;
  Object? result;
  String environmentValue = 'SANDBOX';
  String appId = "";
  String merchantId = "PGTESTPAYUAT86";
  String packageName = "com.sambhavapps.sambhav";
  String saltKey="96434309-7796-489d-8924-ab56988a6076";
  int saltIndex=1;
  String apiEndPoint = "/pg/v1/pay";


  int convertDecimalToInteger(double value) {
    return (value * 100).round();
  }
  @override
  void initState() {
    phonepeInit();
    body=getCheckSum().toString();
    super.initState();
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogs)
        .then((val) => {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  Future startTransaction()async{
    body =  getCheckSum().toString();
    print(body);
    PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName).then((response) => {
      setState(() {
        if (response != null)
        {
          String status = response['status'].toString();
          String error = response['error'].toString();
          if (status == 'SUCCESS')
          {
            result= "Flow Completed - Status: Success!";
          }
          else {
            result= "Flow Completed - Status: $status and Error: $error";
          }
        }
        else {
          result= "Flow Incomplete";
        }
      })
    }).catchError((error) {
      // handleError(error)
      return <dynamic>{};
    });
  }

  String generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    return String.fromCharCodes(Iterable.generate(
      length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  String getCheckSum()  {
    RegExp regExp = RegExp(r'₹\s?(\d+)');
    print((regExp.firstMatch(widget.price)!.group(1)).toString());
    final data = {
      "merchantId": merchantId,
      "merchantTransactionId": generateRandomString(18),
      "merchantUserId": "MUID123",/// user email/userId
      "amount": (int.parse((regExp.firstMatch(widget.price)!.group(1)??"0"))*100),
      "callbackUrl": callback,
      "mobileNumber": "9999999999",
      "paymentInstrument": {
        "type": "PAY_PAGE"
      }
    };
    String base64Body = base64.encode(utf8.encode(json.encode(data)));

    checksum =
    '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey))
        .toString()}###$saltIndex';

    return base64Body;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      widget.contactName,
                                      style: GoogleFonts.poppins(),
                                    ),
                                    Text(
                                      widget.contactNumber,
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

                  Container(
                    width:double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),


                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.price,style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                        const SizedBox(height:8),
                        Text(
                          "TalkTime :  ${widget.talkTime}",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),

                        Text("Validity : ${widget.validity}",style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.grey),),
                        const SizedBox(height:8),
                        Text(widget.planType,style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.grey),),
                        const SizedBox(height:8),
                        Text(widget.planDesc,style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.grey),),

                      ],),
                  ),
                  const SizedBox(height: 20,),
                  Material(
                    color: ThemeColors.primaryBlueColor,
                    borderRadius: BorderRadius.circular(1000),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(1000),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.white24,
// splashColor: ,
                      onTap: () {
                        startTransaction();
                      },
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
    );/*Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              margin:EdgeInsets.symmetric(horizontal: 15,vertical:10),

              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffABB2BE),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Column(
                children: [
                  SizedBox(height:8),
                   Text(
                    widget.price,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w500),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Change Plan",
                      style: TextStyle(
                          color: Color(0xff1877F2),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height:10),
                  Container(
                    padding:EdgeInsets.symmetric(horizontal: 15,vertical:25),
                    decoration: BoxDecoration(
                        color: const Color(0xffABB2BE).withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                         bottomLeft:  Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        )
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Validity",
                              style: TextStyle(
                                  color: Color(0xffABB2BE),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.validity,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height:15),
                        Text(
                          widget.planType,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),


                        SizedBox(height:10),
                        Text(
                          widget.planDesc,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),

            Padding(
              padding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
              child: GestureDetector(
                onTap: () {

                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff1877F2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child:  Center(
                    child: Text(
                      "Pay",
                      style: TextStyle(
                          color:Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));*/
  }

  void handleError(error) {
    result=error;
  }
}
