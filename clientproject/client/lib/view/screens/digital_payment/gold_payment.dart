import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/view/screens/digital_payment/payment_success.dart';

class CompletePaymentPage extends StatefulWidget {
  const CompletePaymentPage({super.key});

  @override
  State<CompletePaymentPage> createState() => _CompletePaymentPageState();
}

class _CompletePaymentPageState extends State<CompletePaymentPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
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
                Text("Complete Payment",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text("Order Summary",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                const SizedBox(height: 25),
                Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16,top:12,bottom:8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                  border: Border.all(width:1,color:const Color(0xFF0080FF).withOpacity(0.5))
                  ),
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quantity",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                        Text("1 gm",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(color:const Color(0xFF0080FF).withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                        Text("₹ 759.5",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(color:const Color(0xFF0080FF).withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax (3.00%)",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                        Text("₹ 227.5",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(color:const Color(0xFF0080FF).withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount Payable",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        Text("₹ 20000",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const SuccessGoldScreen()));
                      },
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
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            minHeight: 60,
                          ),
                          child: const Text(
                            " Proceed to Pay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
