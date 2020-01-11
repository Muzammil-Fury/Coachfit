import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
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

  // bool wasLandscape = false;
  // bool leaveFullscreen = false;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  VoidCallback listener;

  VideoAppState() {
    listener = () {
      if(_videoPlayerController.value.initialized) {
        Duration duration = _videoPlayerController.value.duration;
        Duration position = _videoPlayerController.value.position;
        if (duration.inSeconds - position.inSeconds < 3) {
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
      allowedScreenSleep: false,
      allowFullScreen: true,
      // uncomment line below to make video fullscreen when play button is hit
      // fullScreenByDefault : true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,   
      ],
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      autoInitialize: false,      
    );  

    if(widget.autoPlay) {
      _videoPlayerController.play();
    }

    // start add-on section
    // _chewieController.addListener((){
      
    //   // manually entering fullscreen on landscape
    //   // bool _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    //   // if(_isLandscape && !wasLandscape && !leaveFullscreen ){
    //   //   wasLandscape = true;
    //   //   _chewieController.enterFullScreen();
    //   // }

    //   // manually setting orientation on fullscreen
    //   if(_chewieController.isFullScreen){
    //     SystemChrome.setPreferredOrientations([
    //       // DeviceOrientation.portraitUp,
    //       // DeviceOrientation.portraitDown,
    //       DeviceOrientation.landscapeRight,
    //       DeviceOrientation.landscapeLeft
    //     ]);
    //   }
    //   else{
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //       DeviceOrientation.landscapeRight,
    //       DeviceOrientation.landscapeLeft
    //     ]);
    //   }

    // });
    // end add-on section

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
        }catch(e){
          
        }
      }
    }
  }

  
  @override
  void dispose() {    
    _videoPlayerController.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {     
    return new Container(
      child: new Center(
        child: new Chewie(
          controller: _chewieController,
        )        
      ),
    );    
  }
}