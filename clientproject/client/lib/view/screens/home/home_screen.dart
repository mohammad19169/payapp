import 'package:payapp/controller/auth_controller.dart';
import 'package:payapp/controller/banner_controller.dart';
import 'package:payapp/controller/campaign_controller.dart';
import 'package:payapp/controller/category_controller.dart';
import 'package:payapp/controller/location_controller.dart';
import 'package:payapp/controller/notification_controller.dart';
import 'package:payapp/controller/item_controller.dart';
import 'package:payapp/controller/parcel_controller.dart';
import 'package:payapp/controller/store_controller.dart';
import 'package:payapp/controller/splash_controller.dart';
import 'package:payapp/controller/user_controller.dart';
import 'package:payapp/helper/responsive_helper.dart';
import 'package:payapp/helper/route_helper.dart';
import 'package:payapp/util/dimensions.dart';
import 'package:payapp/util/images.dart';
import 'package:payapp/util/styles.dart';
import 'package:payapp/view/base/item_view.dart';
import 'package:payapp/view/base/menu_drawer.dart';
import 'package:payapp/view/base/paginated_list_view.dart';
import 'package:payapp/view/base/web_menu_bar.dart';
import 'package:payapp/view/screens/home/theme1/theme1_home_screen.dart';
import 'package:payapp/view/screens/home/web_home_screen.dart';
import 'package:payapp/view/screens/home/widget/filter_view.dart';
import 'package:payapp/view/screens/home/widget/popular_item_view.dart';
import 'package:payapp/view/screens/home/widget/item_campaign_view.dart';
import 'package:payapp/view/screens/home/widget/popular_store_view.dart';
import 'package:payapp/view/screens/home/widget/banner_view.dart';
import 'package:payapp/view/screens/home/widget/category_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payapp/view/screens/home/widget/module_view.dart';
import 'package:payapp/view/screens/parcel/parcel_category_screen.dart';

class EcommerceHomeScreen extends StatefulWidget {
  const EcommerceHomeScreen({Key? key}) : super(key: key);

  static Future<void> loadData(bool reload) async {
    Get.find<LocationController>().syncZoneData();
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
    }
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
  }

  @override
  State<EcommerceHomeScreen> createState() => _EcommerceHomeScreenState();
}

class _EcommerceHomeScreenState extends State<EcommerceHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    EcommerceHomeScreen.loadData(false);
    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          Get.find<LocationController>().getUserAddress()!.latitude,
          Get.find<LocationController>().getUserAddress()!.longitude,
          false,
          updateInAddress: true);
    }
    Get.find<LocationController>()
        .navigateToLocationScreen(
        'home');
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("dat ais jjjjjjjjjjjjjjjj");
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,

        backgroundColor: Theme.of(context).colorScheme.surface,
        body: /*isTaxiBooking ? const RiderHomeScreen() :*/ isParcel
            ? const ParcelCategoryScreen()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (Get.find<SplashController>().module != null) {
                      await Get.find<LocationController>().syncZoneData();
                      await Get.find<BannerController>().getBannerList(true);
                      await Get.find<CategoryController>()
                          .getCategoryList(true);
                      await Get.find<StoreController>()
                          .getPopularStoreList(true, 'all', false);
                      await Get.find<CampaignController>()
                          .getItemCampaignList(true);
                      await Get.find<ItemController>()
                          .getPopularItemList(true, 'all', false);
                      await Get.find<StoreController>()
                          .getLatestStoreList(true, 'all', false);
                      await Get.find<ItemController>()
                          .getReviewedItemList(true, 'all', false);
                      await Get.find<StoreController>().getStoreList(1, true);
                      if (Get.find<AuthController>().isLoggedIn()) {
                        await Get.find<UserController>().getUserInfo();
                        await Get.find<NotificationController>()
                            .getNotificationList(true);
                      }
                    } else {
                      await Get.find<BannerController>().getFeaturedBanner();
                      await Get.find<SplashController>().getModules();
                      if (Get.find<AuthController>().isLoggedIn()) {
                        await Get.find<LocationController>().getAddressList();
                      }
                      await Get.find<StoreController>().getFeaturedStoreList();
                    }
                  },
                  child: ResponsiveHelper.isDesktop(context)
                      ? WebHomeScreen(
                          scrollController: _scrollController,
                        )
                      : (Get.find<SplashController>().module != null &&
                              Get.find<SplashController>().module!.themeId == 2)
                          ? Theme1HomeScreen(
                              scrollController: _scrollController,
                              splashController: splashController,
                              showMobileModule: showMobileModule,
                            )
                          : CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                // App Bar
                                SliverAppBar(
                                  floating: true,
                                  elevation: 0,
                                  automaticallyImplyLeading: false,
                                  backgroundColor:
                                      ResponsiveHelper.isDesktop(context)
                                          ? Colors.transparent
                                          : Theme.of(context)
                                              .colorScheme
                                              .surface,
                                  title: Center(
                                      child: Container(
                                    width: Dimensions.webMaxWidth,
                                    height: 50,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface,
                                    child: Row(children: [
                                      (splashController.module != null &&
                                              splashController
                                                      .configModel!.module ==
                                                  null)
                                          ? InkWell(
                                              onTap: () => splashController
                                                  .removeModule(),
                                              child: Image.asset(
                                                  Images.moduleIcon,
                                                  height: 22,
                                                  width: 22,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                          width: (splashController.module !=
                                                      null &&
                                                  splashController.configModel!
                                                          .module ==
                                                      null)
                                              ? Dimensions.paddingSizeExtraSmall
                                              : 0),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () =>
                                            Get.find<LocationController>()
                                                .navigateToLocationScreen(
                                                    'home'),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeSmall,
                                            horizontal: ResponsiveHelper
                                                    .isDesktop(context)
                                                ? Dimensions.paddingSizeSmall
                                                : 0,
                                          ),
                                          child: GetBuilder<LocationController>(
                                              builder: (locationController) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  locationController
                                                              .getUserAddress()!
                                                              .addressType ==
                                                          'home'
                                                      ? Icons.home_filled
                                                      : locationController
                                                                  .getUserAddress()!
                                                                  .addressType ==
                                                              'office'
                                                          ? Icons.work
                                                          : Icons.location_on,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    locationController
                                                        .getUserAddress()!
                                                        .address!,
                                                    style:
                                                        robotoRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color,
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(Icons.arrow_drop_down,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color),
                                              ],
                                            );
                                          }),
                                        ),
                                      )),
                                      InkWell(
                                        child:
                                            GetBuilder<NotificationController>(
                                                builder:
                                                    (notificationController) {
                                          return Stack(children: [
                                            Icon(Icons.notifications,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color),
                                            notificationController
                                                    .hasNotification
                                                ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor),
                                                      ),
                                                    ))
                                                : const SizedBox(),
                                          ]);
                                        }),
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getNotificationRoute()),
                                      ),
                                    ]),
                                  )),
                                  actions: const [SizedBox()],
                                ),

                                // Search Button
                                !showMobileModule
                                    ? SliverPersistentHeader(
                                        pinned: true,
                                        delegate: SliverDelegate(
                                            child: Center(
                                                child: Container(
                                          height: 50,
                                          width: Dimensions.webMaxWidth,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          child: InkWell(
                                            onTap: () => Get.toNamed(
                                                RouteHelper.getSearchRoute()),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 1,
                                                      blurRadius: 5)
                                                ],
                                              ),
                                              child: Row(children: [
                                                Icon(
                                                  Icons.search,
                                                  size: 25,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Expanded(
                                                    child: Text(
                                                  Get.find<SplashController>()
                                                          .configModel!
                                                          .moduleConfig!
                                                          .module!
                                                          .showRestaurantText!
                                                      ? 'search_food_or_restaurant'
                                                          .tr
                                                      : 'search_item_or_store'
                                                          .tr,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  ),
                                                )),
                                              ]),
                                            ),
                                          ),
                                        ))),
                                      )
                                    : const SliverToBoxAdapter(),

                                SliverToBoxAdapter(
                                  child: Center(
                                      child: SizedBox(
                                    width: Dimensions.webMaxWidth,
                                    child: !showMobileModule
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                const BannerView(
                                                    isFeatured: false),
                                                const CategoryView(),
                                                const PopularStoreView(
                                                    isPopular: true,
                                                    isFeatured: false),
                                                const ItemCampaignView(),
                                                const PopularItemView(
                                                    isPopular: true),
                                                const PopularStoreView(
                                                    isPopular: false,
                                                    isFeatured: false),
                                                const PopularItemView(
                                                    isPopular: false),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 15, 0, 5),
                                                  child: Row(children: [
                                                    Expanded(
                                                        child: Text(
                                                      Get.find<SplashController>()
                                                              .configModel!
                                                              .moduleConfig!
                                                              .module!
                                                              .showRestaurantText!
                                                          ? 'all_restaurants'.tr
                                                          : 'all_stores'.tr,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge),
                                                    )),
                                                    const FilterView(),
                                                  ]),
                                                ),
                                                GetBuilder<StoreController>(
                                                    builder: (storeController) {
                                                  return PaginatedListView(
                                                    scrollController:
                                                        _scrollController,
                                                    totalSize: storeController
                                                            .storeModel?.totalSize,
                                                    offset: storeController
                                                            .storeModel?.offset,
                                                    onPaginate: (int?
                                                            offset) async =>
                                                        await storeController
                                                            .getStoreList(
                                                                offset!, false),
                                                    itemView: ItemsView(
                                                      isStore: true,
                                                      items: null,
                                                      stores: storeController
                                                              .storeModel?.stores,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeExtraSmall
                                                            : Dimensions
                                                                .paddingSizeSmall,
                                                        vertical: ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeExtraSmall
                                                            : 0,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ])
                                        : ModuleView(
                                            splashController: splashController),
                                  )),
                                ),
                              ],
                            ),
                ),
              ),
      );
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
