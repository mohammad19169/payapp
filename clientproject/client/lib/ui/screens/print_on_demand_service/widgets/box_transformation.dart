// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_box_transform/flutter_box_transform.dart';
// import 'package:zefyrka/zefyrka.dart';
//
// class ImageBoxTransform extends StatefulWidget {
//   const ImageBoxTransform({super.key, this.imageFile, this.controller});
//
//   final File? imageFile;
//   final ZefyrController? controller;
//
//   @override
//   State<ImageBoxTransform> createState() => _ImageBoxTransformState();
// }
//
// class _ImageBoxTransformState extends State<ImageBoxTransform> {
//   late Rect rect = Rect.fromCenter(
//     center: MediaQuery.of(context).size.center(Offset.zero),
//     width: 100,
//     height: 100,
//   );
//
//   Set<HandlePosition> visibleHandles = {
//     HandlePosition.top,
//     HandlePosition.bottom,
//     HandlePosition.right,
//     HandlePosition.left,
//     HandlePosition.topRight,
//     HandlePosition.topLeft,
//     HandlePosition.bottomRight,
//     HandlePosition.bottomLeft,
//   };
//   Set<HandlePosition> nonVisibleHandles = {HandlePosition.none};
//
//   bool interactive = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           interactive = !interactive;
//         });
//       },
//       child: Stack(
//         children: [
//           TransformableBox(
//             rect: rect,
//             visibleHandles:
//                 interactive ? visibleHandles : nonVisibleHandles,
//             draggable: interactive,
//             resizable: interactive,
//             clampingRect: Offset.zero & MediaQuery.sizeOf(context),
//             onChanged: (result, event) {
//               setState(() {
//                 rect = result.rect;
//               });
//             },
//             contentBuilder: (context, rect, flip) {
//               return widget.imageFile != null
//                   ? DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: interactive? Theme.of(context).colorScheme.primary:Colors.transparent,
//                         ),
//                         image: DecorationImage(
//                           image: FileImage(widget.imageFile!),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     )
//                   : widget.controller!.document.length > 0
//                       ? DecoratedBox(
//                           decoration: const BoxDecoration(),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: ZefyrEditor(
//                               controller: widget.controller!,
//                               autofocus: false,
//                               readOnly: interactive,
//
//                             ),
//                           ),
//                         )
//                       : const SizedBox();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
