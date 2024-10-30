import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payapp/constants.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/models/sambhavtubemodel.dart';
import 'package:payapp/ui/screens/navigationscreen/education/education_services/sambhavtube/videoplayscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../config/apiconfig.dart';
import '../../../themes/colors.dart';
import '../app_bar_widget.dart';

class SambhavTubeWidgetTile extends StatefulWidget {
  final SambhavTubeModel video;

  const SambhavTubeWidgetTile({Key? key, required this.video})
      : super(key: key);

  @override
  State<SambhavTubeWidgetTile> createState() => _SambhavTubeWidgetTileState();
}

class _SambhavTubeWidgetTileState extends State<SambhavTubeWidgetTile> {
  // final Map video;
  @override
  Widget build(BuildContext context) {
    bool isLiked = false;
    int likeCount = 100;

    return Container(
      height: 300,
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // Handle click event

          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return SambhavTubeVideoScreen(
                video: Video(
                    title: widget.video.title,
                    video: widget.video.video,
                    channelName: widget.video.user_name,
                    channelLogo: widget.video.user_logo,
                    videoId: widget.video.id));
          }));
          printThis('Widget clicked!');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.video.thumbnail,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                    ),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   right: 10,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 8, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.7),
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //     child: const Text('10:31',
                  //         style: TextStyle(color: Colors.white, fontSize: 10)),
                  //   ),
                  // ),
                  // Positioned(
                  //   top: 10,
                  //   left: 10,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.remove_red_eye, color: Colors.white, size: 15,),
                  //         SizedBox(width: 3,),
                  //         Text('100', style: TextStyle(color: Colors.white, fontSize: 10)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // const SizedBox(height: 8),
            // SizedBox(
            //   width: MediaQuery
            //       .of(context)
            //       .size
            //       .width - 20,
            //   child: Text(
            //     widget.video.title,
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                    backgroundImage: NetworkImage('https://picsum.photos/200')),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.video.user_name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                          '${widget.video.likes} likes • ${widget.video.views} views ',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                // IconButton(
                //   icon: Icon(
                //       true ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined),
                //   color: true ? Colors.blue : Colors.black,
                //   onPressed: () {},
                // ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                // IconButton(
                //     onPressed: () {},
                //     icon: isLiked
                //         ? Icon(Icons.favorite, color: Colors.red)
                //         : Icon(Icons.favorite_border, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:chewie/chewie.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class SambhavTubeVideoScreen extends StatefulWidget {
  final Video video;

  const SambhavTubeVideoScreen({super.key, required this.video});

  @override
  _SambhavTubeVideoScreenState createState() => _SambhavTubeVideoScreenState();
}

class _SambhavTubeVideoScreenState extends State<SambhavTubeVideoScreen> {
  int likes = 0;
  int dislikes = 0;
  int views = 0;
  bool liked = false;
  bool disliked = false;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  double? _aspectRatio;
  bool isLoading = true;
  List relatedVideos = [];
  List<dynamic> comments = [];
  final TextEditingController commentController = TextEditingController();
  String? authToken;

  Future<void> _fetchVideos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var apiUrl = Uri.parse('https://xyzabc.sambhavapps.com/v1/st/video');

      var response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print(decodedResponse);
        var responseData = decodedResponse["data"];
        setState(() {
          relatedVideos = responseData;
          isLoading = false;
          print(relatedVideos);
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAspectRatio();
      _videoPlayerController =
          VideoPlayerController.network(widget.video.video);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        // aspectRatio: _aspe,
        autoPlay: true,
        looping: true,
        // allowMuting: false,
        // allowPlaybackSpeedChanging: false,
        placeholder: Container(
          color: Colors.grey,
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
        // deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      );
      fetchComments();
      loadToken();
      fetchViewCount();
      _fetchVideos();
    });
    //
    // _videoPlayerController = VideoPlayerController.network(widget.video.video);
    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,
    //   aspectRatio: 300 / 250,
    //   looping: false,
    //   additionalOptions: (context) {
    //     return <OptionItem>[
    //       OptionItem(
    //         onTap: () => debugPrint('My option works!'),
    //         iconData: Icons.chat,
    //         title: 'Share',
    //       ),
    //     ];
    //   },
    //   cupertinoProgressColors: ChewieProgressColors(
    //     playedColor: Colors.red,
    //     handleColor: Colors.blue,
    //     backgroundColor: Colors.grey,
    //     bufferedColor: Colors.lightGreen,
    //   ),
    // );
    // Simulate fetching view count from server
  }

  void _initializeAspectRatio() {
    setState(() {
      _aspectRatio = MediaQuery.of(context).size.width * 0.98 / 250;
    });
  }

  void fetchViewCount() {
    // Simulate fetching view count from server
    // In a real application, you would fetch the view count from an API
    setState(() {
      views = 1000; // Set initial view count
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Increment view count when the video screen is displayed
    incrementViewCount();

    return Scaffold(
      // appBar: AppBarWidget(
      //   title: widget.video.title,
      //   channelName: widget.video.channelName,
      //   channelLogo: widget.video.channelLogo,
      //   size: 55,
      // ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
            title: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundImage: NetworkImage(
                      "https://storage.googleapis.com/cms-storage-bucket/1e32341162e45fcf94a3.png"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.title,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        Text(widget.video.channelName,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            )),
                        const SizedBox(width: 10),
                        Text(
                          '•  $views views',
                          style: const TextStyle(fontSize: 14, color: Colors.brown),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // bottom: bottom,
            titleTextStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * .045,
                color: ThemeColors.primaryBlueColor,
                fontWeight: FontWeight.bold),
            titleSpacing: 5,
            // actions: actions,
            leading: InkWell(
              borderRadius: BorderRadius.circular(1000),
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8, left: 12),
                child: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  size: 35,
                  color: ThemeColors.primaryBlueColor,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 250,
              // width: MediaQuery
              //     .of(context)
              //     .size
              //     .width *
              //     0.98, // Set height to 200 pixels
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          ),

          // Spacer
          const SizedBox(height: 10),

          // UI for likes, dislikes, comments, views
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    color: liked ? Colors.blue : null,
                    onPressed: () {
                      setState(() {
                        if (!liked) {
                          likes++;
                          if (disliked) {
                            dislikes--;
                            disliked = false;
                          }
                          liked = true;
                        } else {
                          likes--;
                          liked = false;
                        }
                      });
                    },
                  ),
                  const Text("500 likes")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_down_outlined),
                    color: disliked ? Colors.red : null,
                    onPressed: () {
                      setState(() {
                        if (!disliked) {
                          dislikes++;
                          if (liked) {
                            likes--;
                            liked = false;
                          }
                          disliked = true;
                        } else {
                          dislikes--;
                          disliked = false;
                        }
                      });
                    },
                  ),
                  const Text("300 dislikes")
                ],
              ),

              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      // Implement comment functionality
                      _showCommentDialog();
                    },
                  ),
                  const Text("112 comments")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                        "assets/icons/share-1-svgrepo-com.svg",
                        color: Colors.blue,
                        height: 27,
                        width: 27),
                    onPressed: () {
                      // Implement comment functionality
                      _showCommentDialog();
                    },
                  ),
                  const Text("320 shares")
                ],
              ),
              // Text('Comments: $comments'),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                child: const Divider(
                  height: 2,
                )),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text("Related videos",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18,
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins")),
          ),
          Expanded(
              child: ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 100),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: relatedVideos.length,
                  itemBuilder: (context, i) {
                    return SambhavTubeWidgetTile(
                      video: SambhavTubeModel(
                        id: relatedVideos[i]["id"],
                        title: relatedVideos[i]["title"],
                        description: relatedVideos[i]["description"],
                        thumbnail: relatedVideos[i]["thumbnail"],
                        user_id: relatedVideos[i]["user"]["id"],
                        video: relatedVideos[i]["video"],
                        tubecategory_id: relatedVideos[i]["category"],
                        user_logo: relatedVideos[i]["user"]["logo"] ?? "",
                        user_name: relatedVideos[i]["user"]["name"] ?? "",
                        likes: relatedVideos[i]["like"].toString() ?? "",
                        views: relatedVideos[i]["views"].toString() ?? "",
                      ),
                    );
                  })),

          // Expanded(
          //     child: ListView.builder(
          //   itemCount: 50,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Container(
          //       margin: EdgeInsets.only(bottom: 5),
          //       child: ListTile(
          //         leading: CircleAvatar(
          //           backgroundColor: Colors.black,
          //           foregroundImage: NetworkImage(
          //               "https://storage.googleapis.com/cms-storage-bucket/1e32341162e45fcf94a3.png"),
          //         ),
          //         style: ListTileStyle.list,
          //         onTap: () {},
          //         title: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("Username",
          //                 style: TextStyle(
          //                     fontSize: 14,
          //                     color: Colors.brown,
          //                     fontWeight: FontWeight.w600)),
          //             Text("Sample comment $index",
          //                 style: TextStyle(
          //                     fontSize: 14, fontWeight: FontWeight.w400))
          //           ],
          //         ),
          //         trailing: Text(
          //           "2h ago",
          //           style: TextStyle(fontSize: 12, color: Colors.grey),
          //         ),
          //       ),
          //     );
          //   },
          // ))
          // Other crucial UI elements can be added here
        ],
      ),
    );
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('token');
      print("Token : $authToken");
    });
  }

  void incrementViewCount() {
    // Increment view count when the video screen is displayed
    setState(() {
      views++;
    });
  }

  String getFetchCommentsUrl() {
    return "https://xyzabc.sambhavapps.com/v1/st/video/comment/${widget.video.videoId}";
  }

  String getAddCommentUrl() {
    return "https://xyzabc.sambhavapps.com/v1/st/video/comment/add";
  }

  void fetchComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');
      print("Token : $authToken");
      var response = await http.get(
        Uri.parse(getFetchCommentsUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"];
        setState(() {
          comments = data[
              "comments"]; // Update this line based on your API response structure
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void addComment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      var response = await http.post(Uri.parse(getAddCommentUrl()),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode({
            'videoId': widget.video.videoId,
            'comment': commentController.text
          }) // Adjust based on your API requirement
          );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        fetchComments(); // Refresh comments list after adding new comment
        commentController.clear();
      } else {
        throw Exception('Failed to post comment');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(5),
          title: Column(
            children: [
              // Text("Comments"),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Add comment here...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: addComment,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 300,
            width: 400,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    ...List.generate(
                      comments.length,
                      (index) {
                        var comment = comments[index];
                        return ListTile(
                          leading: const CircleAvatar(),
                          // Consider adding an image based on user data
                          title: Text(comment['postedby']['name']),
                          // Adjust according to your API response
                          subtitle: Text(comment[
                              'comment']), // Adjust according to your API response
                        );
                      },
                    )
                  ]),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

// Video class
class Video {
  final String title;
  final String video;
  final String videoId;
  final String channelName;
  final String channelLogo;

  Video(
      {required this.title,
      required this.video,
      required this.channelName,
      required this.channelLogo,
      required this.videoId});
}
