import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/view/screens/digital_payment/gold_payment.dart';

import 'detail_product_screen.dart';

class BuyGoldScreen extends StatefulWidget {
  const BuyGoldScreen({super.key});

  @override
  State<BuyGoldScreen> createState() => _BuyGoldScreenState();
}

class _BuyGoldScreenState extends State<BuyGoldScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:2,
      child: SafeArea(child:Scaffold(
          backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
               const Icon(
                Icons.arrow_back_ios,size: 18,
              ),
              const SizedBox(width: 5),
              Text("Buy Gold",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ],
          ),
        ),
          body: Padding(
            padding: const EdgeInsets.only(left:16.0,right:16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 115,
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0080FF).withOpacity(0.2),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
                  ),
                  child:Column(children: [
                    const SizedBox(height:25),
                    Text("Current Gold Price in India",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600)),
                    const SizedBox(height:5),
                    Text("24K 99.9% Purity",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600)),
                    const SizedBox(height:5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("₹ 1000/gm",
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        const SizedBox(width:25),
                        Text("₹ 1000/gm",
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF80FF80))),
                      ],
                    ),
                  ],)
                ),
                const SizedBox(height:25),
                Text("Buy Gold",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                const SizedBox(height:15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width:1,color:Colors.black.withOpacity(0.5))
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    labelColor:  Colors.white, // Selected label color
                    unselectedLabelColor:
                    Colors.grey.shade500,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: const EdgeInsets.only(top:6,bottom:6),
                    indicatorPadding: const EdgeInsets.only(top:5,bottom:5,left:6,right:6),
                    labelStyle: const TextStyle(
                      fontSize: 14, // Font size for selected label
                      fontWeight: FontWeight.w500, // Font weight for selected label
                    ),
                    indicator: BoxDecoration(
                      color: const Color(0xFF0080FF).withOpacity(0.7), // Indicator color
                      borderRadius: BorderRadius.circular(50.0), // Rounded indicator
                    ),
                    tabs: const [
                      Tab(text: 'Buy in Rupees'),
                      Tab(text: 'Buy in Grams'),
                    ],
                  ),
                ),
                const SizedBox(height:25),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '₹ 21,000',
                    hintStyle: TextStyle(color: Colors.black), // Optional: Customize hint text color
                    border: UnderlineInputBorder(),
                    suffixText: '0.56 gms',
                    suffixStyle: TextStyle(color: Colors.black), // Optional: Customize suffix text color
                  ),
                ),
                const SizedBox(height:5),
                Text(
                  'Inclusive of 7.3% of GST',
                  style: TextStyle(
                    fontSize: 12,
                    color:Colors.grey.shade600,// You can change the font size
                    fontStyle: FontStyle.italic, // Set the text to italic
                  ),
                ),
                const SizedBox(height:15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CompletePaymentPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) => Colors.transparent,
                    ),
                    elevation: WidgetStateProperty.all(0), // Remove button shadow
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                     color:const Color(0xFF0080FF).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 60,
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),),),
    );
  }
}
