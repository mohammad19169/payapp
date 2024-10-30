import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payapp/config/apiconfig.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/core/components/app_decoration.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/ca_service_subcategory_screen.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/order_success_status.dart';

import '../../../../../core/animations/shimmer_animation.dart';
import '../../../../../models/ca_models/home_services_model.dart';
import '../screens/ca_service_categor_info_screen.dart';
import '../screens/ca_service_history.dart';

Widget buildCAServiceCategoryItem(
  context, {
  required CAHomeServicesDataModel model,
  VoidCallback? callback,
}) {
  print(model.id);
  return InkWell(
    borderRadius: appBorderRadius,
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CaSubCategoryScreen(
          categoryId: model.id,
          categorName: model.catName,
        ),
      ));
    },
    child: Container(
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: NetworkImage(
                model.cat_img,
              ),
              height: 45,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return const ShimmerAnimation(
                    width: 50,
                    height: 40,
                  );
                } else {
                  return child;
                }
              },
              errorBuilder: (context, error, stackTrace) => const Stack(
                children: [
                  ShimmerAnimation(
                    width: 50,
                    height: 40,
                  ),
                  Text(
                    'something is wrong!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            model.catName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ThemeColors.darkBlueColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

//
Widget buildHistoryCategoryItem(context, {required String title}) {
  return InkWell(
    onTap: () => RouteConfig.navigateToRTL(context, const CaServiceHistory()),
    borderRadius: appBorderRadius,
    child: Container(
      padding: const EdgeInsets.all(3),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Iconsax.document_cloud,
            size: 40,
            color: ThemeColors.primaryBlueColor,
          ),
          Text(
            title,

            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ThemeColors.darkBlueColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
