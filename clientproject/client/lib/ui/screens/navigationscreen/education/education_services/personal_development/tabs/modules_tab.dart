import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../../../../themes/colors.dart';

class ModulesTab extends StatefulWidget {
  final String courseId;

  const ModulesTab({super.key, required this.courseId});

  @override
  State<ModulesTab> createState() => _ModulesTabState();
}

class _ModulesTabState extends State<ModulesTab> {
  Set<int> extended = {};
  Set<List<bool>> enabled = {};
  List<bool> va = [];
  bool isLoading = true;
  var modules = [];
  @override
  void initState() {
    super.initState();
    _fetchModules();
    print(modules);
  }

  Future<void> _fetchModules() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var apiUrl = Uri.parse(
          'https://xyzabc.sambhavapps.com/v1/education/pd/module/course/${widget.courseId}');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        setState(() {
          modules = decodedResponse["data"];
        });
      } else {
        print('API Request Failed with Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error calling API: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: modules.length,
      itemBuilder: (context, index) {
        return buildModuleItem(index, context, modules[index]);
      },
    );
  }

  Widget buildModuleItem(int index, BuildContext context, var module) {
    double? h = extended.contains(index) ? null : 70;
    bool isExtended = false;
    void stablished() {
      if (extended.contains(index)) {
        Timer(const Duration(milliseconds: 500), () {
          enabled.contains([]);
        });
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.cyan,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: SizedBox(
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: ThemeColors.darkBlueColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: ThemeColors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    module["title"],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(
                      () {
                        if (extended.contains(index)) {
                          extended.remove(index);
                        } else {
                          extended.add(index);
                        }
                      },
                    );
                    stablished();
                  },
                  child: Icon(
                    extended.contains(index)
                        ? Icons.keyboard_double_arrow_up
                        : Icons.keyboard_double_arrow_down,
                    color: ThemeColors.darkBlueColor,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            if (extended.contains(index))
              Column(
                children: [
                  const SizedBox(height: 5),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ...module["video"].map((x) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  x["type"] == "free"
                                      ? Icons.play_circle_outline
                                      : Icons.lock_outlined,
                                  size: 25,
                                  color: x["type"] == "free"
                                      ? ThemeColors.darkBlueColor
                                      : Colors.redAccent,
                                ),
                                onPressed: () {
                                  if (x["type"] == "free") {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return VideoScreen(
                                          videoUrl: x["video"],
                                          title: x["title"],
                                        );
                                      },
                                    ));
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  x["title"],
                                  style: const TextStyle(
                                    color: ThemeColors.bluePrise,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Text(
                              //   '23:33 h',
                              //   style: TextStyle(
                              //     fontSize: 14.0,
                              //     color: Colors.grey,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            indent: .5,
                          ),
                        ],
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoScreen({Key? key, required this.videoUrl, required this.title})
      : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _playYoutubeVideo(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        onReady: () {
          // Do something when the player is ready.
        },
      ),
      builder: (context, player) {
        return Scaffold(
            appBar: AppBarWidget(title: widget.title),
            body: Center(child: player));
      },
    );
  }

  void _playYoutubeVideo(String videoUrl) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }
}
