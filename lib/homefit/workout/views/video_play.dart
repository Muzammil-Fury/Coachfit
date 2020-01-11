import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gomotive/homefit/components/video_app.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/core/app_state.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:redux/redux.dart';

class VideoPlay extends StatelessWidget {
  final String videoURL;
  final String videoType;
  final int workoutId;
  final String workoutName;
  VideoPlay({
    this.videoURL,
    this.videoType,
    this.workoutId,
    this.workoutName
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _VideoPlay(
            videoURL: this.videoURL,
            videoType: this.videoType,
            workoutId: this.workoutId,
            workoutName: this.workoutName
          ),
        )        
      ),
    );
  }
}

class _VideoPlay extends StatefulWidget {
  final String videoURL;
  final String videoType;
  final int workoutId;
  final String workoutName;
  _VideoPlay({
    this.videoURL,
    this.videoType,
    this.workoutId,
    this.workoutName
  });

  @override
  _VideoPlayState createState() => new _VideoPlayState();
}

class _VideoPlayState extends State<_VideoPlay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _trackActivities;

  _endOfVideo() async {
    if(widget.videoType == "workout") {
      int responseValue = await Utils.confirmDialog(context, "Confirm?", "Did you finish this workout?", "Yes, I Did", "No");
      if(responseValue == 1) {
        Map params = new Map();
        params["workout_id"] = widget.workoutId;
        Map activityObj = new Map();
        activityObj['key'] = "workout";
        activityObj['name'] = widget.workoutName;
        params['activity_obj'] = activityObj;
        _trackActivities(context, params);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return new Scaffold(
      key: _scaffoldKey,
      body: new LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: new VideoApp(
                videoUrl: widget.videoURL, 
                autoPlay: true,
                endOfVideo: ()  {
                  this._endOfVideo();
                },
              ),                    
            ),
          );
        },
      ),
    );
  }

  Widget _drawSmallerDeviceWidget() {  
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft
    // ]);    
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            widget.workoutName
          )
        ),
        leading: IconButton(                  
          icon: Icon(
            GomotiveIcons.back,
            size: 30.0,
            color: dhfYellow,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          
        ],
      ),
      body: new LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: new VideoApp(
                videoUrl: widget.videoURL, 
                autoPlay: true,                
                endOfVideo: ()  {
                  this._endOfVideo();
                },
              ),                    
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      //   DeviceOrientation.landscapeRight,
      //   DeviceOrientation.landscapeLeft
      // ]);  
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _trackActivities = stateObject['trackActivities'];        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["trackActivities"] = (BuildContext context, Map params) =>
          store.dispatch(trackActivities(context, params));          

        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        if(mobileLayout) {
          return this._drawSmallerDeviceWidget();
        } else {
          return this._drawLargerDeviceWidget();
        }        
      },  
    );
  }
}
