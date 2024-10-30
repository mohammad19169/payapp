// import 'package:flutter/material.dart';
// import 'package:payapp/provider/pod_provider/pod_provider.dart';
// import 'package:payapp/themes/colors.dart';
// import 'package:payapp/ui/screens/print_on_demand_service/screens/image_viewer_widget.dart';
// import 'package:payapp/ui/screens/print_on_demand_service/widgets/box_transformation.dart';
// import 'package:payapp/ui/widgets/app_bar_widget.dart';
// import 'package:provider/provider.dart';
//
// class PODFactoryScreen extends StatefulWidget {
//   const PODFactoryScreen({super.key});
//
//   @override
//   State<PODFactoryScreen> createState() => _PODFactoryScreenState();
// }
//
// class _PODFactoryScreenState extends State<PODFactoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => PODProvider(),
//       child: Consumer<PODProvider>(
//         builder: (context, provider, child) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             resizeToAvoidBottomInset: true,
//             appBar: const AppBarWidget(title: 'Your POD Factory', size: 55),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   AddActionHeader(provider: provider),
//                   FactoryWidget(provider: provider),
//                   AfterDesignActions(provider: provider),
//                 ],
//               ),
//             ),
//             floatingActionButton: FloatingActionButton(
//               mini: false,
//               shape: const CircleBorder(),
//               onPressed: () => provider.openBottomSheet(context),
//               child: const Icon(
//                 Icons.add,
//                 color: ThemeColors.white,
//                 size: 30,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// final GlobalKey stackKey = GlobalKey();
// class FactoryWidget extends StatelessWidget {
//   const FactoryWidget({
//     super.key,
//     required this.provider,
//   });
//
//   final PODProvider provider;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 500,
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(
//           width: 1,
//           color: ThemeColors.darkBlueColor,
//         ),
//       ),
//       alignment: Alignment.center,
//       child: RepaintBoundary(
//         key: stackKey,
//         child: Stack(
//           children: [
//             const ImageViewerWidget(
//                 assetPath: 'assets/pod_service/men-black-plain-t-shirt.jpg'),
//             if (provider.imageFile != null)
//               ImageBoxTransform(
//                 imageFile: provider.imageFile!,
//               ),
//             if (provider.zefyController.document.length > 0)
//               ImageBoxTransform(
//                 controller: provider.zefyController,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AddActionHeader extends StatelessWidget {
//   const AddActionHeader({
//     super.key,
//     required this.provider,
//   });
//
//   final PODProvider provider;
//
//   @override
//   Widget build(BuildContext context) {
//     List<PODAddActionModel> addActions = [
//       PODAddActionModel(
//         actionName: 'Add Image',
//         actionIcon: Icons.image,
//         action: provider.pickImage,
//       ),
//       PODAddActionModel(
//         actionName: 'Add Text',
//         actionIcon: Icons.edit,
//         action: () => provider.addTextToDesign(context),
//       ),
//       PODAddActionModel(
//         actionName: 'Add Sticker',
//         actionIcon: Icons.sticky_note_2_outlined,
//         action: () {},
//       ),
//     ];
//     return Container(
//       color: ThemeColors.darkBlueColor.withOpacity(.4),
//       width: MediaQuery.of(context).size.width,
//       height: 50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(
//           addActions.length,
//           (index) => TextButton.icon(
//             onPressed: addActions[index].action,
//             label: Text(
//               addActions[index].actionName,
//               style: const TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             icon: Icon(
//               addActions[index].actionIcon,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AfterDesignActions extends StatelessWidget {
//   const AfterDesignActions({
//     super.key,
//     required this.provider,
//   });
//
//   final PODProvider provider;
//
//   @override
//   Widget build(BuildContext context) {
//     List<PODAddActionModel> finalActions = [
//       PODAddActionModel(
//         actionName: 'Capture Edited Image',
//         actionIcon: Icons.camera,
//         action: () => provider
//             .captureEditedImage(stackKey),
//       ),
//       PODAddActionModel(
//         actionName: 'Download',
//         actionIcon: Icons.download_for_offline_outlined,
//         action: () => provider.saveEditedImageWithWatermark(stackKey),
//       ),
//     ];
//     return Container(
//       color: ThemeColors.darkBlueColor.withOpacity(.4),
//       width: MediaQuery.of(context).size.width,
//       height: 50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: List.generate(
//           finalActions.length,
//           (index) => TextButton.icon(
//             onPressed: finalActions[index].action,
//             label: Text(
//               finalActions[index].actionName,
//               style: const TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             icon: Icon(
//               finalActions[index].actionIcon,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
