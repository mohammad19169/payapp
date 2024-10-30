import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/view/screens/digital_payment/add_to_cart.dart';
import 'package:payapp/view/screens/digital_payment/detail_product_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text("All Products",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const AddToCartScreen()));
                  },
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 1, color: Colors.black.withOpacity(0.5))),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white, // Selected label color
                    unselectedLabelColor: Colors.grey.shade500,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding:
                        const EdgeInsets.only(top:5 , bottom: 5, left: 6, right: 6),
                    labelStyle: const TextStyle(
                      fontSize: 14, // Font size for selected label
                      fontWeight:
                          FontWeight.w500, // Font weight for selected label
                    ),
                    indicator: BoxDecoration(
                      color:
                          const Color(0xFF0080FF).withOpacity(0.7), // Indicator color
                      borderRadius:
                          BorderRadius.circular(50.0), // Rounded indicator
                    ),
                    tabs: const [
                      Tab(text: 'Gold'),
                      Tab(text: 'Silver'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Expanded(
                  child: TabBarView(children: [
                    ProductList(),
                    ProductList(),
                  ]),
                )
              ],
            ),
          )),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 15,
      children: List.generate(10, (index) {
        return Column(
          children: [
            GestureDetector(
              onTap:(){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => const DetailProductScreen()));
              },
              child: Container(

                  decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width:1,color: const Color(0xFF0080FF).withOpacity(0.5),)
                  ),
                  child: Column(
                    children: [


                      Image.asset("assets/images/gold.jpg",
                          height: 80, width: 60),
                      Text("DG 1 Gram Gold 24K (99.9%)!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      const SizedBox(height: 2),
                      Text(
                        "₹ 759.5",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0080FF).withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      ),

                      Text(
                        "(Making Charges)",
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF0080FF).withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                     /* Text(
                        "(Making Charges)",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0080FF).withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const AddToCartScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ).copyWith(
                          backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (states) => Colors.transparent,
                          ),
                          elevation: MaterialStateProperty.all(
                              0), // Remove button shadow
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxWidth: 100,
                              minHeight: 60,
                            ),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Color(0xFF0080FF).withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),*/

                    ],
                  )),
            )
          ],
        );
      }),
    );
  }
}
