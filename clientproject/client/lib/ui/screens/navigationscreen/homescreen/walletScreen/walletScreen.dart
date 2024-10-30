import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payapp/provider/loginSignUpProvider.dart';
import 'package:payapp/provider/walletProvider.dart';
import 'package:payapp/ui/screens/navigationscreen/homescreen/payout/payoutForm.dart';
import 'package:provider/provider.dart';
import '../../../../../data/model/body/notification_body.dart';
import '../../../../../themes/colors.dart';
import 'Widgets/recentActivityTile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key, required this.languages, required this.body})
      : super(key: key);

  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  double balance=0;
  List<dynamic> transactionList=[];
  bool isLoadingTransData=true;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    // TODO: implement initState
    super.initState();
    final userProvider =
    Provider.of<LoginSignUpProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    if (userProvider.userModel != null) {
      walletProvider.getWalletDetails(userId: userProvider.userModel!.id);
      getTransactions();
      balance=double.parse(userProvider.userModel!.balance);

    }
  }

  Future getTransactions()async{
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
   transactionList = await  walletProvider.getAllTransactionDetails();
    setState(() {
      isLoadingTransData=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffF7F7F7),
        body:isLoadingTransData?const Center(child:CircularProgressIndicator()): Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios,
                      size: 16, color: ThemeColors.primaryBlueColor),
                  const SizedBox(width: 8),
                  Text(
                    "Wallet".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.primaryBlueColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              /*  Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(3, 3),
                      color: const Color(0xff2057A6).withOpacity(0.2),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: "Pending",
                    ),
                    Tab(
                      text: "Withdraw",
                    ),
                    Tab(
                      text: "Confirmed",
                    ),
                  ],
                  labelStyle: GoogleFonts.poppins(),
                  labelColor: ThemeColors.primaryBlueColor,
                  splashBorderRadius: BorderRadius.circular(10),
                  indicator: const CvTabIndicator(
                    indicatorHeight: 4,
                    indicatorColor: ThemeColors.primaryBlueColor,
                    indicatorSize: CvTabIndicatorSize.normal,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.grey,
                ),
              ),*/
              const SizedBox(
                height: 10,
              ),

              Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Balance",
                            style: TextStyle(
                              fontSize: 18,
                              color: ThemeColors.blueColor1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "₹ ${balance.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 24,
                              color: ThemeColors.blueColor1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Image.asset("assets/images/wallet_add.jpg",height:150,width:180,)
                    ],
                  )),
              const SizedBox(height:15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>  const PayoutForm(showForm: true,)));
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
                      color: ThemeColors.blueColor1,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 125,
                        minHeight: 50,
                      ),
                      child: const Text(
                        "Deposit",
                        style: TextStyle(
                          color: Colors.white,
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
                            builder: (context) =>  const PayoutForm(showForm: true,)));
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
                      color:ThemeColors.blueColor1,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 125,
                        minHeight: 50,
                      ),
                      child: const Text(
                        "Withdraw",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],),
              const SizedBox(height:16),
              const Text(
                "Transaction",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeColors.blueColor1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height:16),
            Expanded(
              child: ListView.builder(
                  itemCount: transactionList.length,
                  itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      transactionList[index]['mode'],
                      style: const TextStyle(
                          color: ThemeColors.darkBlueColor, fontWeight: FontWeight.w600),
                    ),
                  //  leading: CircleAvatar(child: Image.network(datas[index].imagePath)),
                    subtitle: Text(
                      transactionList[index]['details'] ?? transactionList[index]['type'],
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      const SizedBox(
                        height: 10,
                      ),
                      DefaultTextStyle(
                        style: TextStyle(color:  transactionList[index]['type'] !='credit'  ? Colors.red : Colors.green),
                        child: Text.rich(
                          TextSpan(
                            text: transactionList[index]['type'] !='credit' ? transactionList[index]['amount'].toString() : "+${transactionList[index]['amount'].toString()}",
                            style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                     // Text("${datas[index].date} ${datas[index].time}")
                    ]),
                  ),
                );
              }),
            )

              /*Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    PendingWalletPage(),
                    PendingWalletPage(),
                    PendingWalletPage(),
                    // WithdrawWalletPage(
                    //   languages: widget.languages,
                    //   body: widget.body,
                    // ),
                    // ConfirmedWalletPage(),
                  ],
                ),
              ),*/
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //
              //         Expanded(
              //
              //           child: Container(
              //             height: 100,
              //
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15),
              //               boxShadow: [
              //                 BoxShadow(
              //                     color: Colors.black.withOpacity(.1), blurRadius: 10)
              //               ],
              //             ),
              //             child: Material(
              //               borderRadius: BorderRadius.circular(15),
              //               color: Colors.white,
              //               child: InkWell(
              //                 borderRadius: BorderRadius.circular(15),
              //                 highlightColor: Colors.transparent,
              //                 splashColor: Colors.black.withOpacity(.05),
              //                 onTap: (){
              //                 },
              //                 child: Padding(
              //                   padding: EdgeInsets.all(10),
              //                   child: Column(
              //                     children: [
              //                       Expanded(child:Consumer<WalletProvider>(builder: (context,walletProvider,child){
              //                         return walletProvider.loading?ShimmerAnimation(height: 20,width: 100,):Center(
              //                           child: Text(
              //                             walletProvider.walletModel!.balance.toString(),
              //                             style: TextStyle(
              //                               fontSize: 24,
              //                               color: ThemeColors.blueColor,
              //                               fontWeight: FontWeight.w700,
              //                             ),
              //                           ),
              //                         );
              //                       }),),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       Text(
              //                         "Balance",
              //                         style: TextStyle(color: Colors.black, fontSize: 15),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Expanded(
              //
              //           child: Container(
              //             height: 100,
              //
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15),
              //               boxShadow: [
              //                 BoxShadow(
              //                     color: Colors.black.withOpacity(.1), blurRadius: 10)
              //               ],
              //             ),
              //             child: Material(
              //               borderRadius: BorderRadius.circular(15),
              //               color: Colors.white,
              //               child: InkWell(
              //                 borderRadius: BorderRadius.circular(15),
              //                 highlightColor: Colors.transparent,
              //                 splashColor: Colors.black.withOpacity(.05),
              //                 onTap: (){
              //                 },
              //                 child: Padding(
              //                   padding: EdgeInsets.all(10),
              //                   child: Column(
              //                     children: [
              //                       Expanded(child: Consumer<WalletProvider>(builder: (context,walletProvider,child){
              //                         return walletProvider.loading?ShimmerAnimation(height: 20,width: 100,):Center(
              //                           child: Text(
              //                             walletProvider.walletModel!.pending.toString(),
              //                             style: TextStyle(
              //                               fontSize: 24,
              //                               color: ThemeColors.blueColor,
              //                               fontWeight: FontWeight.w700,
              //                             ),
              //                           ),
              //                         );
              //                       }),),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       Text(
              //                         "Pending",
              //                         style: TextStyle(color: Colors.black, fontSize: 15),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Expanded(
              //
              //           child: Container(
              //             height: 100,
              //
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15),
              //               boxShadow: [
              //                 BoxShadow(
              //                     color: Colors.black.withOpacity(.1), blurRadius: 10)
              //               ],
              //             ),
              //             child: Material(
              //               borderRadius: BorderRadius.circular(15),
              //               color: Colors.white,
              //               child: InkWell(
              //                 borderRadius: BorderRadius.circular(15),
              //                 highlightColor: Colors.transparent,
              //                 splashColor: Colors.black.withOpacity(.05),
              //                 onTap: (){
              //                 },
              //                 child: Padding(
              //                   padding: EdgeInsets.all(10),
              //                   child: Column(
              //                     children: [
              //                       Expanded(child: Consumer<WalletProvider>(builder: (context,walletProvider,child){
              //                         return walletProvider.loading?ShimmerAnimation(height: 20,width: 100,):Center(
              //                           child: Text(
              //                             walletProvider.walletModel!.confirmed.toString(),
              //                             style: TextStyle(
              //                               fontSize: 24,
              //                               color: ThemeColors.blueColor,
              //                               fontWeight: FontWeight.w700,
              //                             ),
              //                           ),
              //                         );
              //                       }),),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       Text(
              //                         "Confirmed",
              //                         style: TextStyle(color: Colors.black, fontSize: 15),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              // //         Column(
              // //           crossAxisAlignment: CrossAxisAlignment.start,
              // //           children: [
              // //             Text(
              // //               "Wallet Balance",
              // //               style: TextStyle(
              // //                 fontSize: 20,
              // //                 fontWeight: FontWeight.w400,
              // //               ),
              // //             ),
              // //             SizedBox(
              // //               height: 5,
              // //             ),
              // //             Consumer<WalletProvider>(builder: (context,walletProvider,child){
              // //   return walletProvider.loading?ShimmerAnimation(height: 20,width: 100,):Text(
              // //     walletProvider.walletModel!.balance.toString(),
              // //     style: TextStyle(
              // //       fontSize: 24,
              // //       color: ThemeColors.blueColor,
              // //       fontWeight: FontWeight.w700,
              // //     ),
              // //   );
              // // }),
              // //             const SizedBox(height: 10,),
              // //             Text(
              // //               "Pending",
              // //               style: TextStyle(
              // //                 fontSize: 20,
              // //                 fontWeight: FontWeight.w400,
              // //               ),
              // //             ),
              // //             SizedBox(
              // //               height: 5,
              // //             ),
              // //             Consumer<WalletProvider>(builder: (context,walletProvider,child){
              // //               return walletProvider.loading?ShimmerAnimation(height: 20,width: 100,):Text(
              // //                 walletProvider.walletModel!.pending.toString(),
              // //                 style: TextStyle(
              // //                   fontSize: 24,
              // //                   color: ThemeColors.blueColor,
              // //                   fontWeight: FontWeight.w700,
              // //                 ),
              // //               );
              // //             }),
              // //             const SizedBox(height: 10,),
              // //             Text(
              // //               "Confirmed",
              // //               style: TextStyle(
              // //                 fontSize: 20,
              // //                 fontWeight: FontWeight.w400,
              // //               ),
              // //             ),
              // //             SizedBox(
              // //               height: 5,
              // //             ),
              // //             Consumer<WalletProvider>(builder: (context,walletProvider,child){
              // //               return walletProvider.loading?ShimmerAnimation(height: 20,width: 100,):Text(
              // //                 walletProvider.walletModel!.confirmed.toString(),
              // //                 style: TextStyle(
              // //                   fontSize: 24,
              // //                   color: ThemeColors.blueColor,
              // //                   fontWeight: FontWeight.w700,
              // //                 ),
              // //               );
              // //             })
              // //
              // //           ],
              // //         ),
              // //         Icon(
              // //           Iconsax.wallet,
              // //           size: 40,
              // //         )
              //       ],
              //     ),
              //   ),
              //   Material(
              //     borderRadius: BorderRadius.circular(15),
              //     color: ThemeColors.blueColor,
              //     child: InkWell(
              //       borderRadius: BorderRadius.circular(15),
              //       highlightColor: Colors.transparent,
              //       splashColor: Colors.white.withOpacity(.2),
              //       onTap: () async {
              //         final walletProvider = Provider.of<WalletProvider>(context,listen: false);
              //         await walletProvider.getBanks().then((value) {
              //           final list = value as List;
              //           if(list.isEmpty){
              //             Navigator.push(context, CupertinoPageRoute(
              //                 fullscreenDialog: true,
              //                 builder: (context)=> const AddBankForm()));
              //           }
              //           else{
              //             Navigator.push(context, CupertinoPageRoute(
              //                 fullscreenDialog: true,
              //                 builder: (context)=> const SelectBankScreen()));
              //           }
              //         }).onError((error, stackTrace) => showScaffold(context, "$error"));
              //
              //
              //
              //
              //         // Withdrawal
              //         // final walletProvider = Provider.of<WalletProvider>(context,listen: false);
              //         // walletProvider.addBank(bankModel: bankModel)
              //       },
              //       child: Container(
              //         width: MediaQuery.of(context).size.width*.6,
              //         padding: const EdgeInsets.all(15),
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(15),
              //             ),
              //         child: const Center(
              //           child: Text(
              //             "WithDrawal",
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              //   const SizedBox(height: 10,),
              //
              //   Expanded(
              //
              //       child: Consumer<WalletProvider>(builder: (context,walletProvider,child){
              //         return walletProvider.loading? const Center(child: CircularProgressIndicator()):ListView.separated(
              //             padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              //             itemBuilder: (_, index) {
              //               return WalletTransactionTile(amount: walletProvider.walletModel!.transactions[index].amount.toString(),date: walletProvider.walletModel!.transactions[index].date.toString(),message: walletProvider.walletModel!.transactions[index].message.toString(),);
              //             },
              //             separatorBuilder: (_, index) {
              //               return const SizedBox(height: 15,);
              //             },
              //             itemCount: walletProvider.walletModel!.transactions.length);
              //       }),
              //
              //
              //
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
