import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import '../../../../../themes/colors.dart';
import '../../../../widgets/app_bar_widget.dart';
import 'product_page_screen.dart';

class Mug {
  final String name;
  final List colors;
  final List size;
  final List ratings;
  final List imageUrls;
  final String price;
  final String discountPrice;
  final String description;
  final String shortDescription;
  final String thumbnail;
  final String productId;

  // final String categoryId;

  Mug(
      {required this.description,
      required this.shortDescription,
      required this.thumbnail,
      required this.colors,
      required this.size,
      required this.ratings,
      required this.productId,
      // required this.categoryId,
      required this.name,
      required this.imageUrls,
      required this.price,
      required this.discountPrice});

  // {
  // "data": {
  // "category": {
  // "cat_name": "T-shirt",
  // "cat_img": "https://ramximgs.sambhavapps.com//Image/1715095268093.png",
  // "id": "663a46f85706c1566b7dcf82"
  // },
  // "sub_category": "663a47c75706c1566b7dd02b",
  // "sub_category1": "663a48955706c1566b7dd09e",
  // "title": "dsd",
  // "images": [
  // "https://ramximgs.sambhavapps.com//upload-images/1715608734505-Splash-Screen-Social-Market.png"
  // ],
  // "thumbnail": "https://ramximgs.sambhavapps.com//upload-images/1715608721653-Logo-removebg-preview.png",
  // "product_description": "<p>ddsd</p>",
  // "short_description": "<p>sdsd</p>",
  // "old_price": "6564545456",
  // "new_price": "566546",
  // "size": [
  // "66407f81cd7ba88fef840af6",
  // "66407f74cd7ba88fef840acf"
  // ],
  // "colors": [
  // {
  // "color": "6640ae002f43c77f53d19e0e",
  // "media": [
  // "https://ramximgs.sambhavapps.com//upload-images/1715608745715-Splash-Screen-Social-Market.png"
  // ],
  // "price": "5999",
  // "title": "New",
  // "_id": "66421d0e19680505f4259656"
  // }
  // ],
  // "ratings": [],
  // "id": "66421d0e19680505f4259655"
  // },
  // "status": "success"
  // }
  factory Mug.fromJson(json) {
    print("Product name : ${json['title']}");
    print(json['title']);
    print(json['new_price']);
    print(json['old_price']);
    print(json['description']);
    print(json['shortDescription']);
    print(json['thumbnail']);
    print(json['colors']);
    print(json['size']);
    print(json['ratings']);
    print(json['title']);
    print(json['id']);
    Mug product = Mug(
      name: json['title'].toString() ?? "",
      imageUrls: json['images'],
      price: json['new_price'].toString() ?? "",
      discountPrice: json['old_price'].toString() ?? "",
      description: json["description"].toString() ?? "",
      shortDescription: json["shortDescription"].toString() ?? "",
      thumbnail: json["thumbnail"].toString() ?? "",
      colors: json["colors"],
      size: json["size"],
      ratings: ["ratings"],
      productId: json['id'].toString() ?? "",
      // categoryId: json['category']["id"].toString()
    );

    return product;
  }
}

class MugCard extends StatelessWidget {
  final Mug mug;

  const MugCard({super.key, required this.mug});

  @override
  Widget build(BuildContext context) {
    print(mug.imageUrls);
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductScreen(
            productModel: mug,
          ),
        ));
      },
      child: SizedBox(
        width: 200,
        child: Card(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      mug.imageUrls[0],
                      height: 120,
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(height: 3),
                  SizedBox(
                    height: 50,
                    child: Text(
                      mug.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(height: 10),
                  Text('₹${mug.discountPrice}',
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Container(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.2)),
                    child: Text(
                      '₹${mug.price}',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 18,
                          color: Colors.deepOrange),
                    ),
                  ),

                  // SizedBox(
                  //   height: 5,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PODCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const PODCategoryScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<PODCategoryScreen> createState() => _PODCategoryScreenState();
}

class _PODCategoryScreenState extends State<PODCategoryScreen> {
  List<dynamic> subcategories = [];
  List<Mug> products = [];
  bool isLoading = true;
  String errorMessage = '';
  // final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    fetchSubcategoriesAndProducts();
    // initConnectivity();
    // _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Future<void> initConnectivity() async {
  //   ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //     if (result == ConnectivityResult.none) {
  //       setState(() {
  //         errorMessage = 'No internet connection available.';
  //       });
  //     } else {
  //       fetchSubcategoriesAndProducts();
  //     }
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to get connectivity: ${e.toString()}';
  //     });
  //   }
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   if (result != ConnectivityResult.none) {
  //     fetchSubcategoriesAndProducts();
  //   }
  // }

  Future<void> fetchSubcategoriesAndProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        errorMessage = 'Authentication token not found.';
      });
      return;
    }

    // try {
    print("Fetching sub categories and products");
    print("category ID : ${widget.categoryId}");

    var subcategoryUrl = Uri.parse(
        'https://xyzabc.sambhavapps.com/v1/pod/subcategory/cat/${widget.categoryId}');
    var productsUrl = Uri.parse(
        'https://xyzabc.sambhavapps.com/v1/pod/product/cat/${widget.categoryId}');
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var subcategoryResponse = await http.get(subcategoryUrl, headers: headers);
    var productsResponse = await http.get(productsUrl, headers: headers);
    print(subcategoryResponse.statusCode);
    print(productsResponse.statusCode);

    print(subcategoryResponse.body);
    print(productsResponse.body);
    if (subcategoryResponse.statusCode == 200 &&
        productsResponse.statusCode == 200) {
      setState(() {
        subcategories = jsonDecode(subcategoryResponse.body)["data"];
        products = List<Mug>.from(jsonDecode(productsResponse.body)["data"]
            .map((model) => Mug.fromJson(model)));

        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data from server.');
    }
    // } catch (e) {
    //   print(e);
    //   setState(() {
    //     errorMessage = e.toString();
    //     isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 20)),
        foregroundColor: ThemeColors.darkBlueColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'All categories',
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
            ),
            if (isLoading)
              const CircularProgressIndicator()
            else if (errorMessage.isNotEmpty)
              ListTile(title: Text(errorMessage))
            else
              for (var subcategory in subcategories)
                ListTile(
                    title: Text(subcategory['cat_name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Get.to(() => PODSubCategoryScreen(
                            categoryId: subcategory['id'],
                            categoryName: subcategory['cat_name'],
                          ));
                    }),
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: fetchSubcategoriesAndProducts,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subcategories.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Get.to(() => PODSubCategoryScreen(
                                          categoryId: subcategories[index]
                                              ['id'],
                                          categoryName: subcategories[index]
                                              ['cat_name'],
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 120,
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Image.network(
                                                  subcategories[index]
                                                      ['cat_img'])),
                                        ),
                                        Text(subcategories[index]['cat_name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.69 / 1),
                              children: products
                                  .map((mug) => MugCard(mug: mug))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    )
          // ListView.builder(
          //             itemCount: products.length,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                 title: Text(products[index]['name']),
          //                 subtitle: Text('Price: ${products[index]['price']}'),
          //               );
          //             },
          //           ),
          ),
    );
  }

  @override
  void dispose() {
    // _connectivity.dispose();
    super.dispose();
  }
}

class PODSubCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const PODSubCategoryScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<PODSubCategoryScreen> createState() => _PODSubCategoryScreenState();
}

class _PODSubCategoryScreenState extends State<PODSubCategoryScreen> {
  List<dynamic> subcategories = [];
  List<Mug> products = [];
  bool isLoading = true;
  String errorMessage = '';
  // final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    fetchSubcategoriesAndProducts();
    // initConnectivity();
    // _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Future<void> initConnectivity() async {
  //   ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //     if (result == ConnectivityResult.none) {
  //       setState(() {
  //         errorMessage = 'No internet connection available.';
  //       });
  //     } else {
  //       fetchSubcategoriesAndProducts();
  //     }
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to get connectivity: ${e.toString()}';
  //     });
  //   }
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   if (result != ConnectivityResult.none) {
  //     fetchSubcategoriesAndProducts();
  //   }
  // }

  Future<void> fetchSubcategoriesAndProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        errorMessage = 'Authentication token not found.';
      });
      return;
    }

    try {
      print("Fetching sub categories and products");
      print("category ID : ${widget.categoryId}");

      var subcategoryUrl = Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/pod/sub1category/subcat/${widget.categoryId}');
      var productsUrl = Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/pod/product/subcat/${widget.categoryId}');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var subcategoryResponse =
          await http.get(subcategoryUrl, headers: headers);
      var productsResponse = await http.get(productsUrl, headers: headers);
      print(subcategoryResponse.statusCode);
      print(productsResponse.statusCode);

      print(subcategoryResponse.body);
      print(productsResponse.body);
      if (subcategoryResponse.statusCode == 200 &&
          productsResponse.statusCode == 200) {
        setState(() {
          subcategories = jsonDecode(subcategoryResponse.body)["data"];
          products = List<Mug>.from(jsonDecode(productsResponse.body)["data"]
              .map((model) => Mug.fromJson(model)));

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from server.');
      }
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 18)),
        foregroundColor: ThemeColors.darkBlueColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'All categories',
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
            ),
            if (isLoading)
              const CircularProgressIndicator()
            else if (errorMessage.isNotEmpty)
              ListTile(title: Text(errorMessage))
            else
              for (var subcategory in subcategories)
                ListTile(
                    title: Text(subcategory['cat_name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Get.to(() => PODSub1CategoryScreen(
                            categoryId: subcategory['id'],
                            categoryName: subcategory['cat_name'],
                          ));
                    }),
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: fetchSubcategoriesAndProducts,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subcategories.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Get.to(() => PODSubCategoryScreen(
                                          categoryId: subcategories[index]
                                              ['id'],
                                          categoryName: subcategories[index]
                                              ['cat_name'],
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 120,
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Image.network(
                                                  subcategories[index]
                                                      ['cat_img'])),
                                        ),
                                        Text(subcategories[index]['cat_name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.69 / 1),
                              children: products
                                  .map((mug) => MugCard(mug: mug))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    )),
    );
  }

  @override
  void dispose() {
    // _connectivity.dispose();
    super.dispose();
  }
}

class PODSub1CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const PODSub1CategoryScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<PODSub1CategoryScreen> createState() => _PODSub1CategoryScreenState();
}

class _PODSub1CategoryScreenState extends State<PODSub1CategoryScreen> {
  List<Mug> products = [];
  bool isLoading = true;
  String errorMessage = '';
  // final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    // initConnectivity();
    // _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Future<void> initConnectivity() async {
  //   ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //     if (result == ConnectivityResult.none) {
  //       setState(() {
  //         errorMessage = 'No internet connection available.';
  //       });
  //     } else {
  //       fetchSubcategoriesAndProducts();
  //     }
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to get connectivity: ${e.toString()}';
  //     });
  //   }
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   if (result != ConnectivityResult.none) {
  //     fetchSubcategoriesAndProducts();
  //   }
  // }

  Future<void> fetchSubcategoriesAndProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        errorMessage = 'Authentication token not found.';
      });
      return;
    }

    try {
      print("Fetching sub categories and products");
      print("category ID : ${widget.categoryId}");

      var productsUrl = Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/pod/product/sub1cat/${widget.categoryId}');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var productsResponse = await http.get(productsUrl, headers: headers);

      print(productsResponse.statusCode);

      print(productsResponse.body);
      if (productsResponse.statusCode == 200) {
        setState(() {
          products = List<Mug>.from(jsonDecode(productsResponse.body)["data"]
              .map((model) => Mug.fromJson(model)));

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from server.');
      }
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: widget.categoryName),
      body: RefreshIndicator(
          onRefresh: fetchSubcategoriesAndProducts,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.69 / 1),
                      children:
                          products.map((mug) => MugCard(mug: mug)).toList(),
                    )
          // ListView.builder(
          //             itemCount: products.length,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                 title: Text(products[index]['name']),
          //                 subtitle: Text('Price: ${products[index]['price']}'),
          //               );
          //             },
          //           ),
          ),
    );
  }

  @override
  void dispose() {
    // _connectivity.dispose();
    super.dispose();
  }
}
