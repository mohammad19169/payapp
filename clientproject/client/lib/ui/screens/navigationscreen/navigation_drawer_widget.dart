import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/core/utils/helper/helper.dart';
import 'package:payapp/models/drawer_tile_model.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/components/supportWidgetForNavDrawer.dart';
import 'package:payapp/ui/screens/navigationscreen/profilescreen/termsconditions/termsconditions.dart';
import 'package:payapp/ui/screens/print_on_demand_service/pod_factory_screen.dart';
import 'package:payapp/view/screens/referral_screens/referral_main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/model/body/notification_body.dart';
import '../../../provider/loginSignUpProvider.dart';
import '../../../provider/setingsProvider.dart';
import '../../../view/screens/auth/sign_in_screen.dart';
import '../loginscreen/loginscreen.dart';
import 'homescreen/accountmanager/accountmanager.dart';
import 'homescreen/walletScreen/savedBankAccountScreen.dart';
import 'homescreen/walletScreen/walletScreen.dart';
import 'pod_services/print_on_demand_screen.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget(
      {Key? key, required this.languages, required this.body})
      : super(key: key);

  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  List<DrawerTileModel> drawerTiles = [
    DrawerTileModel(
      label: "Personal Manager",
      svgIcon: "",
      actionType: ActionType.accountManager,
      icon: Icons.person_2_outlined,
    ),
    DrawerTileModel(
      label: "Print on demand (POD)",
      svgIcon: "",
      actionType: ActionType.pOD,
      icon: Icons.design_services,
    ),
    DrawerTileModel(
      label: "Linked Bank Accounts ",
      svgIcon: "",
      // actionType: null,
      actionType: ActionType.myBankAccount,
      icon: Icons.account_balance_outlined,
    ),
    DrawerTileModel(
      label: "MPIN",
      svgIcon: "",
      actionType: null,
      icon: Icons.password_rounded,
    ),
    DrawerTileModel(
      label: "My Earnings",
      svgIcon: "",
      // actionType: null,
      actionType: ActionType.myEarnings,
      icon: Iconsax.money,
    ),
    DrawerTileModel(
      label: "My Referrals",
      svgIcon: "",
      actionType: ActionType.myReferrals,
      icon: Icons.share_sharp,
    ),
    DrawerTileModel(
      label: "Change Language",
      svgIcon: "",
      actionType: null,
      icon: Icons.language_outlined,
    ),
    DrawerTileModel(
      label: "Join Telegram",
      svgIcon: "",
      actionType: null,
      icon: Icons.telegram,
    ),
    DrawerTileModel(
      label: "Rate Us",
      svgIcon: "",
      actionType: null,
      icon: Icons.star_rate_outlined,
    ),
    DrawerTileModel(
      label: "About Sambhav App",
      svgIcon: "",
      actionType: ActionType.aboutApp,
      icon: Icons.info_outline,
    ),
    DrawerTileModel(
      label: "TDS Deduction Info",
      svgIcon: "",
      actionType: ActionType.tdsDeduction,
      icon: Icons.sticky_note_2_outlined,
    ),
    DrawerTileModel(
      label: "Privacy & Policy",
      svgIcon: "",
      actionType: ActionType.privacyPolicy,
      icon: Icons.policy,
    ),
    DrawerTileModel(
      label: "Support",
      svgIcon: "",
      actionType: ActionType.support,
      icon: Icons.support_agent_outlined,
    ),
    DrawerTileModel(
      label: "Terms & Conditions",
      svgIcon: "",
      actionType: ActionType.termsConditions,
      icon: Icons.document_scanner,
    ),
    DrawerTileModel(
      label: "Logout",
      svgIcon: "",
      actionType: ActionType.logout,
      icon: Icons.logout,
    ),
  ];

  _navigateToPage(BuildContext context, ActionType actionType) {
    Scaffold.of(context).closeDrawer();
    switch (actionType) {
      case ActionType.accountManager:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const AccountManagerScreen()));
        break;
      case ActionType.myReferrals:
        Navigator.push(
            context,
            CupertinoPageRoute(
                  builder: (context) => const ReferralMain()));
        break;
      case ActionType.myBankAccount:
        Navigator.push(
            context,
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => SelectBankScreen(
                      languages: widget.languages,
                      body: widget.body,
                    )));
        break;
      case ActionType.mpin:
        break;
      case ActionType.myEarnings:
        final loginSignupProvider =
            Provider.of<LoginSignUpProvider>(context, listen: false);
        if (loginSignupProvider.userModel != null) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => WalletScreen(
                        languages: widget.languages,
                        body: widget.body,
                      )));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) =>
                    const SignInScreen(exitFromApp: false, backFromThis: true),
              ));
        }
        break;
      case ActionType.myReferrals:
        break;
      case ActionType.changeLanguage:
        break;
      case ActionType.joinTelegram:
        break;
      case ActionType.rateUs:
        break;
      case ActionType.aboutApp:
        final provider = Provider.of<SettingsProvider>(context, listen: false);
        void openUrl() async {
          const url = 'https://sambhavapps.com/about-us/';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        openUrl();
        // TODO: Add about us screen
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TermsAndConditionsScreen(
        //               termsConditions: provider.settingsModel != null
        //                   ? provider.settingsModel!.aboutUs
        //                   : "",
        //               title: "About Us.",
        //             )));
        break;
      case ActionType.tdsDeduction:
        final provider = Provider.of<SettingsProvider>(context, listen: false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TermsAndConditionsScreen(
                      termsConditions: provider.settingsModel != null
                          ? provider.settingsModel!.tdsInfo
                          : "",
                      title: "TDS Deduction Info",
                    )));
        break;
      case ActionType.privacyPolicy:
        final provider = Provider.of<SettingsProvider>(context, listen: false);
        void openUrl() async {
          const url = 'https://sambhavapps.com/privacy-policy';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        openUrl();
        // TODO: Add privacy policy screen
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TermsAndConditionsScreen(
        //               termsConditions: provider.settingsModel != null
        //                   ? provider.settingsModel!.privacyPolicy
        //                   : "",
        //               title: "Privacy Policy",
        //             )));
        break;
      case ActionType.termsConditions:
        final provider = Provider.of<SettingsProvider>(context, listen: false);

        void openUrl() async {
          const url = 'https://sambhavapps.com/terms-and-conditions';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        openUrl();
        // TODO: Add terms and conditions screen
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TermsAndConditionsScreen(
        //               termsConditions: provider.settingsModel != null
        //                   ? provider.settingsModel!.privacyPolicy
        //                   : "",
        //               title: "Terms & Conditions",
        //             )));
        break;
      case ActionType.logout:
        final loginSignUpProvider =
            Provider.of<LoginSignUpProvider>(context, listen: false);
        loginSignUpProvider.logOutUser();
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    const SignInScreen(exitFromApp: false, backFromThis: true)),
            (route) => false);
        break;
      case ActionType.support:
        break;
      case ActionType.pOD:
        RouteConfig.navigateToLTR(context, const PODFactoryScreen());
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    final enableItems =
        drawerTiles.where((element) => element.actionType != null).toList();
    final disableItems =
        drawerTiles.where((element) => element.actionType == null).toList();
    drawerTiles = enableItems + disableItems;
    // drawerTiles.sort((a, b) => a.label.toString().compareTo(b.label.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:const Color(0xffF7F7F7),
      child: ListView(
        padding: EdgeInsets.zero,
        // shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            height: 175,
            decoration: const BoxDecoration(

              /*  gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff2057A6),
                Colors.blue,
              ],
            )*/),
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: const EdgeInsets.only(top:30),
                    height:60,width:60,
                      decoration: const BoxDecoration(
                      ),
                      child:Image.asset("assets/images/avatar.png",fit: BoxFit.cover,)),
             const  SizedBox(width:15),
                 const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(height:40),
                     Text("Arooj Ali",style: TextStyle( fontSize: 16,
                         fontWeight: FontWeight.w400,color: Color(0xff2D2A26)),textAlign: TextAlign.center,),
                     SizedBox(height:2),
                     Text("abc@gmail.com",style: TextStyle( fontSize: 14,
                         fontWeight: FontWeight.w400,color:  Color(0xff8B8B8B)),textAlign: TextAlign.center,),
                   ],)


                 /* ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Consumer<SettingsProvider>(
                      builder: (_, settingsProvider, child) {
                        if (settingsProvider.settingsModel != null) {
                          return Image.network(
                            settingsProvider.settingsModel!.appLogo,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width * .25,
                            width: MediaQuery.of(context).size.width * .25,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text(
                              "Sambhav",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const Text(
                          "Sambhav",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  )*/
                ],
              ),
            ),
          ),
          Column(
            children: List.generate(
                drawerTiles.length,
                (index) => drawerTiles[index].actionType == ActionType.support
                    ? SupportWidgetForNavDrawer(
                        label: drawerTiles[index].label,
                        icon: drawerTiles[index].icon,
                      )
                    : ListTile(
                        title: Text(drawerTiles[index].label,style: const TextStyle( fontSize: 16,
                          fontWeight: FontWeight.w400,color: Color(0xff2D2A26)),),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        horizontalTitleGap: 10,
                        iconColor:  const Color(0xff2D2A26),
                        style: ListTileStyle.drawer,
                        enabled: drawerTiles[index].actionType == null
                            ? false
                            : true,
                        leading: Icon(
                          drawerTiles[index].icon,
                          size: 18,
                        ),
                        onTap: () {
                          if (drawerTiles[index].actionType != null) {
                            _navigateToPage(
                                context, drawerTiles[index].actionType!);
                          } else {
                            showScaffold(context, "hello");
                          }
                        },
                      )),
          )
        ],
      ),
    );
  }
}
