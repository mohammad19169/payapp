import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../themes/colors.dart';
import '../../../widgets/app_bar_widget.dart';
import 'screens/category_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';

class PODFactoryScreen extends StatelessWidget {
  const PODFactoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // AppBarWidget()
          AppBar(
        title: const Text('Print on Demand',
            style: TextStyle(
                fontSize: 18,
                color: ThemeColors.darkBlueColor,
                fontWeight: FontWeight.bold)),
        toolbarHeight: 40,

        // size: 50,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),

    //  drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
           /* Container(
              height: 55,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search our catalogue of great products',
                  prefixIcon: Icon(
                    Icons.search,
                    color: ThemeColors.darkBlueColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),*/
            BannerSlider(),
            // Popular Restaurants

// Popular Restaurants
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('All Categories',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.darkBlueColor)),
              ),
            ),

            PodCategorySection(),
          ],
        ),
      ),
      // Bottom Navigation Bar
     /* bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),*/
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String imageUrl;
  final String label;
  final String id;

  const CategoryWidget(
      {super.key, required this.imageUrl, required this.label, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PODCategoryScreen(
            categoryName: label,
            categoryId: id,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 80,
                  width: 75,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const ItemWidget(
      {super.key, required this.name, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Column(children: [
          Container(
            height: 140,
            width: 120,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey,
                blurStyle: BlurStyle.normal,
              )
            ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Text(name)
        ]));
  }
}

class PodCategorySection extends StatefulWidget {
  const PodCategorySection({super.key});

  @override
  State<PodCategorySection> createState() => _PodCategorySectionState();
}

class _PodCategorySectionState extends State<PodCategorySection> {
  bool _isLoading = true;
  List<CategoryData> _categories = [];
  final bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    // _checkConnectivity();
    // Connectivity().onConnectivityChanged.listen((result) {
    //   setState(() {
    //     _isConnected = (result != ConnectivityResult.none);
    //   });
    //   if (_isConnected) {
    //     _fetchCategories();
    //   }
    // });
  }

  Future<void> _fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      String apiUrl = 'https://xyzabc.sambhavapps.com/v1/pod/categories';
      try {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {'Authorization': 'Bearer $token'},
        );
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body)["data"];
          print(data);
          setState(() {
            _categories = data
                .map((category) => CategoryData.fromJson(category))
                .toList();
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load categories');
        }
      } catch (e) {
        print('Error: $e');
        // Handle error scenarios
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Error fetching categories');
      }
    } else {
      // Handle case where token is not found
    }
  }

  // Future<void> _checkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     setState(() {
  //       _isConnected = false;
  //     });
  //   }
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : !_isConnected
              ? const Center(
                  child: Text('No internet connection'),
                )
              : GridView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                      childAspectRatio: 0.9),
                  children: List.generate(_categories.length, (index) {
                    return CategoryWidget(
                      imageUrl: _categories[index].imageUrl,
                      label: _categories[index].label,
                      id: _categories[index].id,
                    );
                  }),
                ),
    );
  }
}

class CategoryData {
  final String imageUrl;
  final String label;

  final String id;

  CategoryData({required this.imageUrl, required this.label, required this.id});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
        imageUrl: json['cat_img'], label: json['cat_name'], id: json['id']);
  }
}

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final List<Map<String, dynamic>> _banners = [];
  bool _isLoading = true;
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchBanners() async {
    print("Fetching banners");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('Bearer token not found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://xyzabc.sambhavapps.com/v1/pod/banners'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          List<Map<String, dynamic>> banners = List<Map<String, dynamic>>.from(
              data['data'].map((item) => {
                    'banner': item['banner'],
                    'title': item['title'],
                    'id': item['id']
                  }));
          setState(() {
            _banners.addAll(banners);
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load banners');
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching banners: $e');
    }
  }

  // void _updateConnectionStatus(ConnectivityResult result) {
  //   if (result != ConnectivityResult.none) {
  //     _fetchBanners();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(8),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _banners.isNotEmpty
              ? CarouselSlider.builder(
                  itemCount: _banners.length,
                  itemBuilder: (context, index, realIndex) {
                    print("Banners length : ${_banners.length}");
                    print(index);
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: _banners[index]['banner']!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                  ),
                )
              : const SizedBox(),
    );
  }
}
