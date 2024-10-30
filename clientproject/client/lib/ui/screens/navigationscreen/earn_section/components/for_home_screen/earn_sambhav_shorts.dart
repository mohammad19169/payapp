import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:payapp/ui/screens/navigationscreen/ca_services/screens/ca_testimonials_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/src/player/youtube_player.dart';

class EarnSambhavShorts extends StatefulWidget {
  const EarnSambhavShorts({
    Key? key,
  }) : super(key: key);

  @override
  State<EarnSambhavShorts> createState() => _EarnSambhavShortsState();
}

class _EarnSambhavShortsState extends State<EarnSambhavShorts> {
  List<dynamic> shorts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShorts();
  }

  Future<void> _fetchShorts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth-token');

    final response = await http.get(
      Uri.parse('https://xyzabc.sambhavapps.com/v1/earn/shorts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          shorts = decodedResponse['data'];
          _isLoading = false;
        } else {
          _isLoading = false;
          throw Exception(
              'Failed to load shorts: ${decodedResponse['status']}');

        }
      });
    } else {
      _isLoading = false;
      setState(() {

      });
      throw Exception('Failed to load shorts');

    }
  }

  @override
  Widget build(BuildContext context) {
    // _fetchShorts();
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
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
        _isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 320,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: shorts.length,
                  itemBuilder: (context, index) {
                    return buildShortItem(context, index);
                  },
                ),
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  GestureDetector buildShortItem(BuildContext context, int index) {
    final short = shorts[index];
    final String videoId = YoutubePlayer.convertUrlToId(short['video']) ?? '';
    return GestureDetector(
      onTap: () {
     //   _watchShort(short['video']);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 320,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
        ),

        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: YoutubeVideoPlayerOsamaTwo(videoId: videoId)))

    );
  }

  void _watchShort(String videoUrl) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text("Short Video"),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data:
                          "Hello <iframe src='$videoUrl' frameborder='0'></iframe>",
                      //Optional parameters:
                    ),
                  ),
                )));
  }
}
