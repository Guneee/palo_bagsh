import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "yg4Mq5EAEzw",
    flags: const YoutubePlayerFlags(
      autoPlay: true,
    ),
  );
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBtnColor,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: [
              _top(height, width),
              Expanded(
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _top(double height, double width) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          Text(
            "Coca cola",
            style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.transparent,
            ),
          ),
        ],
      );
}
