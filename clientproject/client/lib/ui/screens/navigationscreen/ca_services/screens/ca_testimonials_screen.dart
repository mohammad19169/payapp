import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payapp/data/api/api_client.dart';
import 'package:payapp/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CaTestimonials extends StatefulWidget {
  final List<dynamic> testimonials;
  const CaTestimonials({Key? key,required this.testimonials}) : super(key: key);

  @override
  State<CaTestimonials> createState() => _CaTestimonialsState();
}

class _CaTestimonialsState extends State<CaTestimonials> {

  final bool _isLoading = true;
  final int _currentTestimonialIndex = 0;
  late CarouselController _carouselController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
  }



  void _startAutoScrollTimer() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
     // _carouselController.n();
    });
  }

  void _cancelAutoScrollTimer() {
    _autoScrollTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(width:60,height:1,color:const Color(0xffD0CFCE)),
              const SizedBox(width:15),
              const Text(
                "Testimonials",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeColors.darkBlueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width:15),
              Container(width:60,height:1,color:const Color(0xffD0CFCE)),
            ],
          ),
        ),
        const SizedBox(height: 20),
       _buildTestimonialsCarousel(),
      ],
    );
  }

/*  Widget _buildShimmerCarousel() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Shimmer(
              duration: Duration(seconds: 2),
              interval: Duration(seconds: 2),
              color: Colors.grey[300]!,
              enabled: true,
              direction: ShimmerDirection.fromLTRB(),
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }*/

  Widget _buildTestimonialsCarousel() {
    return widget.testimonials.isNotEmpty
        ? Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onTap: () {
                        // Cancel auto-scroll when carousel is tapped
                        _cancelAutoScrollTimer();
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // carouselController: _carouselController,
                        itemCount: widget.testimonials.length,
                        itemBuilder: (context, index) {
                          final testimonial = widget.testimonials[index];
                          return _buildTestimonialItem(testimonial, index);
                        },
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   left: 0,
                  //   right: 0,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: List.generate(
                  //       _testimonials.length,
                  //       (index) => GestureDetector(
                  //         onTap: () {
                  //           _carouselController.animateToPage(index);
                  //           _cancelAutoScrollTimer(); // Cancel auto-scroll on tap
                  //         },
                  //         child: Container(
                  //           width: 8,
                  //           height: 8,+
                  //           margin: EdgeInsets.symmetric(horizontal: 4),
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: _currentTestimonialIndex == index
                  //                 ? Colors.blue
                  //                 : Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          )
        : const CircularProgressIndicator();
  }

  Widget _buildTestimonialItem(Map<String, dynamic> testimonial, int index) {
    final String type = testimonial['type'] ?? '';
    final String videoUrl = testimonial['video'] ?? '';

    if (type == 'youtube') {
      final String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
      return Column(
        children: [
          Container(
              width: 200,
              margin: const EdgeInsets.all(12),
              child: YoutubeVideoPlayerOsamaTwo(videoId: videoId)),
          const SizedBox(height: 10),
          widget.testimonials[index].containsKey('title')
              ? Text(
                  widget.testimonials[index]['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox(),
        ],
      );
    } else if (type == 'server') {
      final String videoId = YoutubePlayer.convertUrlToId(testimonial['video'] ) ?? '';
     // final String thumbnailUrl = testimonial['video'] ?? '';
      return Column(
        children: [
          Container(
            width: 200,
            margin: const EdgeInsets.all(8),
            child:  YoutubeVideoPlayerOsamaTwo(videoId: videoId)
          ),
          const SizedBox(height: 10),
          widget.testimonials[index].containsKey('title')
              ? Text(
            widget.testimonials[index]['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
              : const SizedBox(),
        ],
      );
    } else {
      return Container();
    }
  }
}

class ServerVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const ServerVideoPlayer({super.key, 
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  @override
  _ServerVideoPlayerState createState() => _ServerVideoPlayerState();
}

class _ServerVideoPlayerState extends State<ServerVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying = true;
        });
        // Add logic to switch to full screen mode or any other action
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0), // Adding border radius

            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : Image.network(
                    widget.thumbnailUrl,
                    loadingBuilder: (context, child, loadingProgress) =>
                        const CircularProgressIndicator(),
                    errorBuilder: (context, url, error) =>
                        const Center(child: Text("Unknown Error")),
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class YoutubeVideoPlayerOsamaTwo extends StatefulWidget {
  final String videoId;

  const YoutubeVideoPlayerOsamaTwo({super.key, required this.videoId});

  @override
  State<YoutubeVideoPlayerOsamaTwo> createState() =>
      _YoutubeVideoPlayerOsamaTwoState();
}

class _YoutubeVideoPlayerOsamaTwoState
    extends State<YoutubeVideoPlayerOsamaTwo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add logic to switch to full screen mode
      },
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
