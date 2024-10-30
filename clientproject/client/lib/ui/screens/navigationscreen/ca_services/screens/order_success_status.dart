import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payapp/themes/colors.dart';

import '../../../../../core/components/print_text.dart';
import '../../../../widgets/glass_effect.dart';

class OrderSuccessStatus extends StatefulWidget {
  const OrderSuccessStatus({super.key});

  @override
  State<OrderSuccessStatus> createState() => _OrderSuccessStatusState();
}

class _OrderSuccessStatusState extends State<OrderSuccessStatus> {
  bool isPending = true;

  bool isDownloading = false;

  void download() {
    setState(() {
      isDownloading = true;
    });
    printThis(isDownloading.toString());
    Timer(const Duration(seconds: 15), () {
      setState(() {
        isDownloading = false;
        printThis(isDownloading.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.darkBlueColor,
      //appBar: AppBarWidget(title: 'Success status',size: 55,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/success.json',
                      reverse: true,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Order Placed Successfully',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GlassEffectedContainer(
                        colors: [
                          Colors.lightBlue.withOpacity(.5),
                          Colors.lightBlue.withOpacity(.25),
                        ],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: Text(
                                'Download your docs',
                                style: GoogleFonts.poppins(
                                  color: ThemeColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'GST Submission Confirmation Final',
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: ThemeColors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => download(),
                                          child: Lottie.asset(
                                              'assets/lottie/download_banner.json',
                                              animate: isDownloading ? true : false,
                                              width: 70,
                                              height: 70,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                      const SizedBox()),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'INVOICE From MCA Final',
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: ThemeColors.white,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => download(),
                                          child: Lottie.asset(
                                              'assets/lottie/download_banner.json',
                                              width: 70,
                                              height: 70,
                                              animate: isDownloading ? true : false,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                      const SizedBox()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
