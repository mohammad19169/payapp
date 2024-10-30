import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerOsama extends StatefulWidget {
   YoutubeVideoPlayerOsama({super.key, this.videoUrl});

   String? videoUrl;

  @override
  State<YoutubeVideoPlayerOsama> createState() => _YoutubeVideoPlayerOsamaState();
}

class _YoutubeVideoPlayerOsamaState extends State<YoutubeVideoPlayerOsama> {
  late YoutubePlayerController controller;

  @override
  void initState() {
     String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl??'https://youtu.be/YMx8Bbev6T4');
    controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
