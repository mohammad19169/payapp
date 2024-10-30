import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:async';

import '../../../../../themes/colors.dart';
import './category_screen.dart';

class ProductScreen extends StatefulWidget {
  final Mug productModel;

  const ProductScreen({super.key, required this.productModel});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;
  String size = 'Small';
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    print("Hello POD");
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Product Details',
        size: 50,
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarouselSlider.builder(
              itemCount: widget.productModel.imageUrls.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.productModel.imageUrls[itemIndex],
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ),
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productModel.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text("Sizes : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  _buildSizeOption('S'),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildSizeOption('M'),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildSizeOption('L'),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildSizeOption('XL'),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text("Colors : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  _buildColorOption(Colors.black),
                  _buildColorOption(Colors.blue),
                  _buildColorOption(Colors.red),
                  _buildColorOption(Colors.green),
                  _buildColorOption(Colors.yellow),
                  _buildColorOption(Colors.orange),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                '₹${widget.productModel.price}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '₹${widget.productModel.discountPrice}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                '50% OFF',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 22,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.grey)),
                      icon: const Icon(
                        Icons.remove,
                      ),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                    ),
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 22,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.grey)),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => quantity++);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ImageEditScreen(
                        baseImageUrl: widget.productModel.imageUrls[0],
                      );
                    },
                  ));
                  // Add to cart logic
                },
                child: Text('Add To Cart'),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Divider(
            thickness: 3,
            color: Colors.grey.withOpacity(0.5),
          ),
          const Row(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.delivery_dining_outlined,
                  size: 38,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text("Estimated Delivery By : "),
              Text("3 May - 6 May",
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "10%",
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text("Cashback")
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "10 Lac+",
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text("Customers")
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "7 days",
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text("Replacement")
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Contact Us")
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return ChoiceChip(
      label: Text(size),
      selected: this.size == size,
      onSelected: (selected) {
        setState(() {
          this.size = size;
        });
      },
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class ImageEditScreen extends StatefulWidget {
  final String baseImageUrl;

  const ImageEditScreen({super.key, required this.baseImageUrl});

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  final _editorKey = GlobalKey<ProImageEditorState>();
  late StreamController _updateAppBarStream;

  @override
  void initState() {
    _updateAppBarStream = StreamController.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    _updateAppBarStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProImageEditor.network(
      widget.baseImageUrl,
      key: _editorKey,
      onImageEditingComplete: (byte) async {
        Navigator.pop(context);
      },
      onUpdateUI: () {
        _updateAppBarStream.add(null);
      },
      configs: ProImageEditorConfigs(
        cropRotateEditorConfigs: const CropRotateEditorConfigs(
          enabled: false,
        ),
        blurEditorConfigs: const BlurEditorConfigs(enabled: false),
        filterEditorConfigs: const FilterEditorConfigs(enabled: false),
        stickerEditorConfigs: StickerEditorConfigs(
          enabled: true,
          buildStickers: (setLayer) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Future pickImage() async {
                          try {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (image == null) return;
                            setLayer(Image.file(File(image.path)));
                          } on PlatformException catch (e) {
                            print('Failed to pick image: $e');
                          }
                        }

                        pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: ThemeColors.darkBlueColor,
                          foregroundColor: Colors.white),
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text("Add Custom Logo"))

                  // GridView.builder(
                  //   padding: const EdgeInsets.all(16),
                  //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  //     maxCrossAxisExtent: 150,
                  //     mainAxisSpacing: 10,
                  //     crossAxisSpacing: 10,
                  //   ),
                  //   itemCount: 21,
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index) {
                  //     Widget widget = ClipRRect(
                  //       borderRadius: BorderRadius.circular(7),
                  //       child: Image.network(
                  //         'https://picsum.photos/id/${(index + 3) * 3}/2000',
                  //         width: 120,
                  //         height: 120,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     );
                  //     return GestureDetector(
                  //       onTap: () => setLayer(widget),
                  //       child: MouseRegion(
                  //         cursor: SystemMouseCursors.click,
                  //         child: widget,
                  //       ),
                  //     );
                  //   },
                  // ),
                  ),
            );
          },
        ),
        customWidgets: ImageEditorCustomWidgets(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            actions: [
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      tooltip: 'Cancel',
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.close),
                      onPressed: _editorKey.currentState?.closeEditor,
                    );
                  }),
              const Spacer(),
              StreamBuilder(
                stream: _updateAppBarStream.stream,
                builder: (_, __) {
                  return IconButton(
                    tooltip: 'Undo',
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    icon: Icon(
                      Icons.undo,
                      color: _editorKey.currentState?.canUndo == true
                          ? Colors.white
                          : Colors.white.withAlpha(80),
                    ),
                    onPressed: _editorKey.currentState?.undoAction,
                  );
                },
              ),
              StreamBuilder(
                stream: _updateAppBarStream.stream,
                builder: (_, __) {
                  return IconButton(
                    tooltip: 'Redo',
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    icon: Icon(
                      Icons.redo,
                      color: _editorKey.currentState?.canRedo == true
                          ? Colors.white
                          : Colors.white.withAlpha(80),
                    ),
                    onPressed: _editorKey.currentState?.redoAction,
                  );
                },
              ),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      tooltip: 'Done',
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.done),
                      iconSize: 28,
                      onPressed: _editorKey.currentState?.doneEditing,
                    );
                  }),
            ],
          ),
          appBarPaintingEditor: AppBar(
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            actions: [
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _editorKey
                          .currentState?.paintingEditor.currentState?.close,
                    );
                  }),
              const SizedBox(width: 80),
              const Spacer(),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(
                        Icons.line_weight_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _editorKey.currentState?.paintingEditor
                          .currentState?.openLineWeightBottomSheet,
                    );
                  }),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        icon: Icon(
                          _editorKey.currentState?.paintingEditor.currentState
                                      ?.fillBackground ==
                                  true
                              ? Icons.format_color_reset
                              : Icons.format_color_fill,
                          color: Colors.white,
                        ),
                        onPressed: _editorKey.currentState?.paintingEditor
                            .currentState?.toggleFill);
                  }),
              const Spacer(),
              IconButton(
                tooltip: 'Custom Icon',
                padding: const EdgeInsets.symmetric(horizontal: 8),
                icon: const Icon(
                  Icons.bug_report,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      tooltip: 'Undo',
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: Icon(
                        Icons.undo,
                        color: _editorKey.currentState?.paintingEditor
                                    .currentState?.canUndo ==
                                true
                            ? Colors.white
                            : Colors.white.withAlpha(80),
                      ),
                      onPressed: _editorKey.currentState?.paintingEditor
                          .currentState?.undoAction,
                    );
                  }),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      tooltip: 'Redo',
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: Icon(
                        Icons.redo,
                        color: _editorKey.currentState?.paintingEditor
                                    .currentState?.canRedo ==
                                true
                            ? Colors.white
                            : Colors.white.withAlpha(80),
                      ),
                      onPressed: _editorKey.currentState?.paintingEditor
                          .currentState?.redoAction,
                    );
                  }),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      tooltip: 'Done',
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.done),
                      iconSize: 28,
                      onPressed: _editorKey
                          .currentState?.paintingEditor.currentState?.done,
                    );
                  }),
            ],
          ),
          appBarTextEditor: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            actions: [
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _editorKey
                          .currentState?.textEditor.currentState?.close,
                    );
                  }),
              const Spacer(),
              IconButton(
                tooltip: 'Custom Icon',
                padding: const EdgeInsets.symmetric(horizontal: 8),
                icon: const Icon(
                  Icons.bug_report,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      onPressed: _editorKey.currentState?.textEditor
                          .currentState?.toggleTextAlign,
                      icon: Icon(
                        _editorKey.currentState?.textEditor.currentState
                                    ?.align ==
                                TextAlign.left
                            ? Icons.align_horizontal_left_rounded
                            : _editorKey.currentState?.textEditor.currentState
                                        ?.align ==
                                    TextAlign.right
                                ? Icons.align_horizontal_right_rounded
                                : Icons.align_horizontal_center_rounded,
                      ),
                    );
                  }),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      onPressed: _editorKey.currentState?.textEditor
                          .currentState?.toggleBackgroundMode,
                      icon: const Icon(Icons.layers_rounded),
                    );
                  }),
              const Spacer(),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.done),
                      iconSize: 28,
                      onPressed: _editorKey
                          .currentState?.textEditor.currentState?.done,
                    );
                  }),
            ],
          ),
          appBarCropRotateEditor: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            actions: [
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _editorKey
                          .currentState?.cropRotateEditor.currentState?.close,
                    );
                  }),
              const Spacer(),
              IconButton(
                tooltip: 'Custom Icon',
                padding: const EdgeInsets.symmetric(horizontal: 8),
                icon: const Icon(
                  Icons.bug_report,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
                      onPressed: _editorKey
                          .currentState?.cropRotateEditor.currentState?.rotate,
                    );
                  }),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      key: const ValueKey('pro-image-editor-aspect-ratio-btn'),
                      icon: const Icon(Icons.crop),
                      onPressed: _editorKey.currentState?.cropRotateEditor
                          .currentState?.openAspectRatioOptions,
                    );
                  }),
              const Spacer(),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.done),
                      iconSize: 28,
                      onPressed: _editorKey
                          .currentState?.cropRotateEditor.currentState?.done,
                    );
                  }),
            ],
          ),
          appBarFilterEditor: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            actions: [
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _editorKey
                          .currentState?.filterEditor.currentState?.close,
                    );
                  }),
              const Spacer(),
              IconButton(
                tooltip: 'Custom Icon',
                padding: const EdgeInsets.symmetric(horizontal: 8),
                icon: const Icon(
                  Icons.bug_report,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              StreamBuilder(
                  stream: _updateAppBarStream.stream,
                  builder: (_, __) {
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: const Icon(Icons.done),
                      iconSize: 28,
                      onPressed: _editorKey
                          .currentState?.filterEditor.currentState?.done,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
