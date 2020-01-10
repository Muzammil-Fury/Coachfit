import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

typedef void EndOfVideo();

class VideoApp extends StatefulWidget {

  final VideoAppState _videoAppState = VideoAppState();

  final String videoUrl;
  final EndOfVideo endOfVideo;
  final bool autoPlay;

  VideoApp({
    this.videoUrl,
    this.endOfVideo,
    this.autoPlay
  });

  @override
  State<StatefulWidget> createState() => _videoAppState;
  
}

class VideoAppState extends State<VideoApp> {
  
  bool _eovReached = false;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  VoidCallback listener;

  VideoAppState() {
    listener = () {
      if(_videoPlayerController.value.initialized) {
        Duration duration = _videoPlayerController.value.duration;
        Duration position = _videoPlayerController.value.position;
        if (duration.inSeconds - position.inSeconds == 1) {
          if(!_eovReached) {
            _eovReached = true;
            widget.endOfVideo();
          }
        }
      }
    };
  }

  initialize(){    
    if(_videoPlayerController != null && _videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    }
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl
    ); 
    if(_chewieController != null) {
      _chewieController.dispose();
    }   
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      autoInitialize: false,      
    );  
    _videoPlayerController.addListener(listener);    
    _videoPlayerController.initialize();
  }

  @override
  void initState() {    
    super.initState();  
    try {  
      this.initialize();      
    }catch(e){}
  }

  @override
  void didUpdateWidget(VideoApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this.mounted){
      if(oldWidget.videoUrl != widget.videoUrl) {
        try {  
          this.initialize();
        }catch(e){}
      }
    }
  }

  
  @override
  void dispose() {    
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {         
    if(widget.autoPlay) {
      _videoPlayerController.play();
    }
    return new Container(
      child: new Center(
        child: new Chewie(
          controller: _chewieController,
        )        
      ),
    );    
  }
}