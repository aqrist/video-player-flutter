import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:kartunku_app/helper/key.dart';
import 'dart:convert';

import 'package:kartunku_app/pages/player_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Future<List<VideoInfo>> fetchVideoInfo(String playlistId) async {
    final response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      return items.map<VideoInfo>((item) {
        return VideoInfo(
          videoId: item['snippet']['resourceId']['videoId'].toString(),
          title: item['snippet']['title'].toString(),
          thumbnailUrl:
              item['snippet']['thumbnails']['medium']['url'].toString(),
          channelName: items[0]['snippet']['channelTitle'].toString(),
          playlistName: items[0]['snippet']['title'].toString(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load video info');
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tontonan Kartunku',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: playlistIds.length,
        itemBuilder: (context, index) {
          final playlistId = playlistIds[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Test Playlist',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder<List<VideoInfo>>(
                future: fetchVideoInfo(playlistId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final videoInfoList = snapshot.data;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height /
                          2.5, // Set an appropriate height
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: videoInfoList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the VideoPlayerPage with the selected videoId
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerPage(
                                            videoId:
                                                videoInfoList[index].videoId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            videoInfoList![index].thumbnailUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    videoInfoList[index].title,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoInfo {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String playlistName;

  VideoInfo({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.playlistName,
  });
}
