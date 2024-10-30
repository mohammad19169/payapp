import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/view/screens/digital_payment/add_to_cart.dart';
import 'package:payapp/view/screens/digital_payment/buy_gold_screen.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text("DC 2gm Gold Bar",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ],
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            items: [
              Image.asset("assets/images/gold.jpg", height: 200, width: 200),
              Image.asset("assets/images/gold_bar.jpg",
                  height: 200, width: 200),
              Image.asset("assets/images/gold-coin.jpg",
                  height: 250, width: 250),
            ],
            options: CarouselOptions(
              height: 250,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Text("DC 2Gram Gold Bar 24K (99.9%)",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          const SizedBox(height: 5),
          Text("₹ 2000 (Making Charges)",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF0080FF).withOpacity(0.7),
                fontWeight: FontWeight.w400,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 25),
                child: Text("Product Details",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Model",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                        Text("DG24MB",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Divider(color: const Color(0xFF0080FF).withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Metal Purity",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                        Text("24 Karat",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Divider(color: const Color(0xFF0080FF).withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Weight",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                        Text("227.5",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left:12.0,right:12,top:8,bottom:8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle '+' tap
                            },
                            child: const Icon(Icons.add, size: 22),
                          ),
                          const SizedBox(width:8),
                          Container(width: 1,height:12, color: Colors.grey.shade400),
                          const SizedBox(width:8),
                          const Text(
                            '1', // Replace with your number
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width:8),
                          Container(width: 1,height:12, color: Colors.grey.shade400),
                          const SizedBox(width:8),
                          GestureDetector(
                            onTap: () {
                              // Handle '-' tap
                            },
                            child: const Icon(Icons.remove, size: 22),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const AddToCartScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ).copyWith(
                            backgroundColor:
                            WidgetStateProperty.resolveWith<Color>(
                                  (states) => Colors.transparent,
                            ),
                            elevation: WidgetStateProperty.all(
                                0), // Remove button shadow
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: const Color(0xFF0080FF).withOpacity(0.7),width:1)
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(
                                maxWidth: 150,
                                minHeight: 50,
                              ),
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: const Color(0xFF0080FF).withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width:15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const BuyGoldScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 5),
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
                             maxWidth: 150,
                                minHeight: 50,
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
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
