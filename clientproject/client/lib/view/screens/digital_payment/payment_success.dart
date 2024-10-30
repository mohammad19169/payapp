

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SuccessGoldScreen extends StatefulWidget {
  const SuccessGoldScreen({super.key});

  @override
  State<SuccessGoldScreen> createState() => _SuccessGoldScreenState();
}

class _SuccessGoldScreenState extends State<SuccessGoldScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text("Order Complete",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  textAlign: TextAlign.center,),
              ],
            ),
          ),
          body:SizedBox(
            width:MediaQuery.of(context).size.width,
            child: Column(

              children: [
                const Spacer(),
                Lottie.asset("assets/images/success-gold.json",
                    height: 250, width: 250),
                Text("Congratulations!",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                const SizedBox(height:8),
                Text("You purchased 7.56 grams\nof gold successfully",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600), textAlign: TextAlign.center,),

                const Spacer(),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) => Colors.transparent,
                    ),
                    elevation:
                    WidgetStateProperty.all(0), // Remove button shadow
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0080FF).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 100,
                        minHeight: 50,
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:10),
              ],),
          )
      ),
    );
  }
}
