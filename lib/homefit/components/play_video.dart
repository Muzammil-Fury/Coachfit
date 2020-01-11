import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gomotive/homefit/components/video_app.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:redux/redux.dart';

class PlayVideo extends StatelessWidget {
  final String videoURL; 
  PlayVideo({
    this.videoURL,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        left: false,
        right: false,
        child: _PlayVideo(
          videoURL: this.videoURL,
        ),
      ),
    );
  }
}

class _PlayVideo extends StatefulWidget {
  final String videoURL; 
  _PlayVideo({
    this.videoURL,
  });

  @override
  _PlayVideoState createState() => new _PlayVideoState();
}

class _PlayVideoState extends State<_PlayVideo> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {             
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();           
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight,
        // ]);      
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: IconButton(                  
              icon: Icon(
                GomotiveIcons.back,
                size: 40.0,
                color: dhfYellow,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),                
                    width: 228,
                    child:Image.asset(
                      "assets/images/homefit_logo.png"
                    ),
                  ),                    
                ],
              )

            ),     


            
                     
            actions: <Widget>[],
          ),
          body: new LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        new VideoApp(
                          videoUrl: widget.videoURL,
                          autoPlay: false,
                        ),
                        new Container(           
                          padding: EdgeInsets.symmetric(
                            vertical: 64.0, horizontal: 0.0
                          ),        
                          child: new MaterialButton(
                            height: 50.0, 
                            minWidth: 120.0,
                            color: dhfYellow,
                            child: new Text(
                              'Let\'s Get Started',
                              textScaleFactor: 1.5,
                            ),
                            textColor: Colors.black87, 
                            onPressed: () {
                              Navigator.pushNamed(context, "/signin");
                            },
                          ),                                              
                        )                       
                      ],
                    )                    
                  ),
                ),
              );
            },
          ),
        );        
      }
    );
  }
}
