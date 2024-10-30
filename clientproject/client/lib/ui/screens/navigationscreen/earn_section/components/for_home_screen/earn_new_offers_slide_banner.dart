import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/animations/shimmer_animation.dart';
import '../../../../../../core/views/kslistviewbuilder.dart';
import '../../../../../../provider/earn_providers/earn_screen_provider.dart';
import '../widgets/offer_widget.dart';

class EarnNewOffersSlideBannerConsumer extends StatelessWidget {
  const EarnNewOffersSlideBannerConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EarnScreenProvider>(builder: (context, gmoProvider, child) {
      return gmoProvider.offersForAll != null &&
              gmoProvider.offersForAll!.newOffers.isNotEmpty
          ? Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:  Row(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(width:50,height:1,color:const Color(0xffD0CFCE)),
                      const SizedBox(width:10),
                      const Text(
                        "New Offers",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF08398b),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width:10),
                      Container(width:50,height:1,color:const Color(0xffD0CFCE)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 210,
                  child: KSListView(
                    scrollDirection: Axis.horizontal,
                    separateSpace: 14,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    itemCount: gmoProvider.offersForAll!.newOffers.isEmpty
                        ? 10
                        : gmoProvider.offersForAll!.newOffers.length,
                    itemBuilder: (context, index) {
                      return gmoProvider.offersForAll!.newOffers.isEmpty
                          ? const ShimmerAnimation(
                              height: 190,
                              width: 130,
                              radius: 15,
                            )
                          : EarnNewOfferWidget(
                              earnOfferModel:
                                  gmoProvider.offersForAll!.newOffers[index],
                            );
                    },
                  ),
                ),
              ],
            )
          : Container();
    });
  }
}
