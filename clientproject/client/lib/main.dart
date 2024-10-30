import 'dart:async';
import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:payapp/controller/auth_controller.dart';
import 'package:payapp/controller/cart_controller.dart';
import 'package:payapp/controller/localization_controller.dart';
import 'package:payapp/controller/location_controller.dart';
import 'package:payapp/controller/splash_controller.dart';
import 'package:payapp/controller/theme_controller.dart';
import 'package:payapp/controller/wishlist_controller.dart';
import 'package:payapp/data/api/api_client.dart';
import 'package:payapp/data/model/body/notification_body.dart';
import 'package:payapp/helper/responsive_helper.dart';
import 'package:payapp/helper/route_helper.dart';
import 'package:payapp/provider/accountManagerProvider.dart';
import 'package:payapp/provider/caservicesprovider/ca_services_provider.dart';
import 'package:payapp/provider/earn_providers/earn_screen_provider.dart';
import 'package:payapp/provider/education_providers/community_provider.dart';
import 'package:payapp/provider/education_providers/education_provider.dart';
import 'package:payapp/provider/loginSignUpProvider.dart';
import 'package:payapp/provider/parent_provider/parent_provider.dart';
import 'package:payapp/provider/setingsProvider.dart';
import 'package:payapp/provider/walletProvider.dart';
import 'package:payapp/theme/dark_theme.dart';
import 'package:payapp/theme/light_theme.dart';
import 'package:payapp/ui/screens/demo/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/hiveDatabase.dart';
import 'firebase_options.dart';
import 'package:payapp/util/app_constants.dart';
import 'package:payapp/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:payapp/view/screens/home/widget/cookies_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await HiveDataBase.init();
  final loginSignUpProvider = LoginSignUpProvider();
  SharedPreferences sharedPreferences=  await SharedPreferences.getInstance();
  loginToken = sharedPreferences.getString(AppConstants.authToken)??"";
  final user = await loginSignUpProvider.initUser();
  // if (GetPlatform.isWeb) {
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //     apiKey: 'AIzaSyDFN-73p8zKVZbA0i5DtO215XzAb-xuGSE',
  //     appId: '1:1000163153346:web:4f702a4b5adbd5c906b25b',
  //     messagingSenderId: 'G-L1GNL2YV61',
  //     projectId: 'ammart-8885e',
  //   ));
  //
  //   MetaSEO().config();
  // }
  print(user);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Map<String, Map<String, String>> languages = await di.init();

  NotificationBody? body;
  try {
    if (GetPlatform.isMobile) {
      // final RemoteMessage? remoteMessage =
      //     // await FirebaseMessaging.instance.getInitialMessage();
      // if (remoteMessage != null) {
      //   body = NotificationHelper.convertNotification(remoteMessage.data);
      // }
      // await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "380903914182154",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ParentProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => EarnScreenProvider(),
    ),
    ChangeNotifierProvider.value(
      value: loginSignUpProvider,
    ),
    ChangeNotifierProvider(
      create: (context) => CaServicesProvider()..getCAHomeServices(),
    ),
    ChangeNotifierProvider(
      create: (context) => AccountManagerProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => WalletProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => EductionFormProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CommunityProvider(),
    ),
  ], child: MyApp(languages: languages, body: body)));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;

  const MyApp({Key? key, required this.languages, required this.body})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() async {
    if (GetPlatform.isWeb) {
      await Get.find<SplashController>().initSharedData();
      if (Get.find<LocationController>().getUserAddress() != null &&
          Get.find<LocationController>().getUserAddress()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }
      Get.find<CartController>().getCartData();
    }
    Get.find<SplashController>()
        .getConfigData(loadLandingData: GetPlatform.isWeb)
        .then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          if (Get.find<SplashController>().module != null) {
            await Get.find<WishListController>().getWishList();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  // theme: themeController.darkTheme ? themeController.darkColor == null ? dark() : dark(color
                  //     : themeController.darkColor!) : themeController.lightColor == null ? light()
                  //     : light(color: themeController.lightColor!),

                  theme: themeController.darkTheme ? dark() : light(),
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode),
                  initialRoute: GetPlatform.isWeb
                      ? RouteHelper.getInitialRoute()
                      : RouteHelper.getSplashRoute(widget.body),
                  getPages: RouteHelper.getAllRoutes(languages: widget.languages, body: widget.body),
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, widget) => Material(
                    child: Stack(children: [
                      widget!,
                      GetBuilder<SplashController>(builder: (splashController) {
                        if (!splashController.savedCookiesData &&
                            !splashController.getAcceptCookiesStatus(
                                splashController.configModel != null
                                    ? splashController.configModel!.cookiesText!
                                    : '')) {
                          return ResponsiveHelper.isWeb()
                              ? const Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CookiesView())
                              : const SizedBox();
                        } else {
                          return const SizedBox();
                        }
                      })
                    ]),
                  ),
                );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
