import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payapp/config/route_config.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/required_docs.dart';
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/service_details_form.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../../config/apiconfig.dart';
import '../../../../../core/animations/shimmer_animation.dart';
import '../../../../../provider/caservicesprovider/ca_services_provider.dart';
import '../../../../../themes/colors.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String id;
  final String title;

  const ServiceDetailsScreen({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  void initState() {

    super.initState();
    final provider = Provider.of<CaServicesProvider>(context, listen: false);
    print("ID : ${widget.id}");
    print("Title : ${widget.title}");
    provider.getServiceForm(id: widget.id);
    provider.isLoadingForm = true;
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.title,
        size: 55,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.white,
          child: Consumer<CaServicesProvider>(
              builder: (context, caServiceProvider, child) {
            return caServiceProvider.isLoadingForm
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero(
                          //   tag: 'wertyuio',
                          //   child: Consumer<CaServicesProvider>(builder:
                          //       (context, caServiceProvider, child) {
                          //     return Container(
                          //       height: 220,
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 10, vertical: 10),
                          //       width: double.infinity,
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(20),
                          //         child: caServiceProvider.isLoading
                          //             ? const ShimmerAnimation()
                          //             : Image.network(
                          //                 Constants.forImg +
                          //                     caServiceProvider
                          //                         .serviceDetails!
                          //                         .bannerImage[0],
                          //                 loadingBuilder: (
                          //                   BuildContext context,
                          //                   Widget child,
                          //                   ImageChunkEvent?
                          //                       loadingProgress,
                          //                 ) {
                          //                   if (loadingProgress == null) {
                          //                     return child;
                          //                   }
                          //                   return const ShimmerAnimation();
                          //                 },
                          //                 errorBuilder: (context, error,
                          //                         stackTrace) =>
                          //                     const ShimmerAnimation(),
                          //                 fit: BoxFit.fill,
                          //               ),
                          //       ),
                          //     );
                          //   }),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Consumer<CaServicesProvider>(builder:
                                //     (context, caServiceProvider, child) {
                                //   return Container(
                                //     height: 170,
                                //     decoration: BoxDecoration(
                                //         borderRadius:
                                //             BorderRadius.circular(20),
                                //         color: Colors.redAccent
                                //             .withOpacity(0.3)),
                                //     child: ClipRRect(
                                //       borderRadius:
                                //           BorderRadius.circular(20),
                                //       child: caServiceProvider.isLoading
                                //           ? Center(
                                //               child:
                                //                   CircularProgressIndicator(
                                //               color: Colors.redAccent
                                //                   .withOpacity(.5),
                                //             ))
                                //           : AppVideo(
                                //               url: Constants.forImg +
                                //                   caServiceProvider
                                //                       .serviceDetails!
                                //                       .descriptionVideo,
                                //             ),
                                //     ),
                                //   );
                                // }),
                                // const SizedBox(
                                //   height: 30,
                                // ),
                                // Consumer<CaServicesProvider>(builder:
                                //     (context, caServiceProvider, child) {
                                //   return caServiceProvider.isLoading
                                //       ? const ShimmerAnimation(
                                //           height: 15,
                                //           radius: 1000,
                                //         )
                                //       : Text(
                                //           "₹ ${caServiceProvider.serviceDetails!.price}",
                                //           style: const TextStyle(
                                //               fontWeight: FontWeight.w600,
                                //               fontSize: 20),
                                //           textAlign: TextAlign.left,
                                //         );
                                // }),

                                Consumer<CaServicesProvider>(builder:
                                    (context, caServiceProvider, child) {
                                  return ListView(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    addAutomaticKeepAlives: true,
                                    children: List.generate(
                                        caServiceProvider.serviceDetails!
                                            .details.length, (index) {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(3, 3),
                                                color: const Color(0xff2057A6)
                                                    .withOpacity(0.2),
                                                blurRadius: 20.0,
                                              ),
                                            ],
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: Column(
                                          children: [
                                            Html(
                                              data: caServiceProvider
                                                  .serviceDetails!
                                                  .details[index],
                                              style: {
                                                "body": Style(
                                                  fontSize: FontSize(15),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              },
                                            ),
                                          ],
                                        ),
                                        // child: Column(
                                        //   children: [
                                        //     TextField(
                                        //       controller: _nameController,
                                        //       decoration: InputDecoration(labelText: caServiceProvider.servicespaymentList[index].lable),
                                        //     ),
                                        //
                                        //     // Add some spacing between fields
                                        //     SizedBox(height: 16),
                                        //
                                        //     // Text field for Email
                                        //     TextField(
                                        //       controller: _emailController,
                                        //       decoration: InputDecoration(labelText: 'required'),
                                        //     ),
                                        //     SizedBox(height: 16),
                                        //     TextField(
                                        //       controller: _emailController,
                                        //       decoration: InputDecoration(labelText: 'id'),
                                        //     ),
                                        //
                                        //   ],
                                        // ),
                                      );
                                    }),
                                  );
                                }),

                                // Consumer<CaServicesProvider>(builder:
                                //     (context, caServiceProvider, child) {
                                //   return caServiceProvider.isLoading
                                //       ? ShimmerAnimation(
                                //           height: 15,
                                //           radius: 1000,
                                //         )
                                //       : Text(
                                //           caServiceProvider
                                //               .serviceDetails!.title,
                                //           style: TextStyle(
                                //               fontWeight: FontWeight.w600,
                                //               fontSize: 20),
                                //           textAlign: TextAlign.left,
                                //         );
                                // }),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Consumer<CaServicesProvider>(builder:
                                //     (context, caServiceProvider, child) {
                                //   return caServiceProvider.isLoading
                                //       ? ShimmerAnimation(
                                //           height: 15,
                                //           radius: 1000,
                                //         )
                                //       : Text(
                                //           caServiceProvider
                                //               .serviceDetails!.fullDescription,
                                //           textAlign: TextAlign.justify,
                                //           style: TextStyle(
                                //               fontSize: 12, height: 1.5),
                                //         );
                                // }),
                                // SizedBox(
                                //   height: 20,
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  );
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ServiceDetailsForm(
                id: widget.id,
              );
            },
          ));
          // RouteConfig.navigateToRTL(
          //     context,
          //     RequiredDocsScreen(
          //       screenTitle: widget.title,
          //     ));
        },
        label: const Text(
          '      Continue To Payment      ',
          softWrap: true,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
