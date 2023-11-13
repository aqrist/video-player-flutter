import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatelessWidget {
  final String videoId;

  const PlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: ListView(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              // You can perform any actions here when the video is ready to play.
            },
          ),
        ],
      ),
    );
  }
}
