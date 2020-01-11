import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/components/play_video.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/core/app_config.dart';

class Splash extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) { 
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);   
    return new Scaffold(      
      body: new SafeArea(
        top: false,
        bottom: false,        
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _Splash(),
        )
      ),
    );
  }
}

class _Splash extends StatefulWidget {  
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<_Splash> {
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
                  child: new Container(
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.6), 
                          BlendMode.darken
                        ),
                        image: new AssetImage(
                          mobileLayout ? "assets/images/splash_image_iphone.png" : "assets/images/splash_image_ipad.png"
                        ),
                        fit: BoxFit.cover
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[  
                        new Center(  
                          child: new Column(
                            children: <Widget>[
                              new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => PlayVideo(
                                        videoURL: "https://player.vimeo.com/external/267109435.m3u8?s=cd0694bcbef847ac6168c72e71a6f5c9a090b44c&oauth2_token_id=1042420788",
                                      )
                                    ),
                                  );
                                },
                                child: new Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                                  child: new Image.asset(
                                    'assets/images/play.png',
                                    color: Colors.white,                                                                                                                  
                                  ), 
                                  width: mobileLayout ? 64 : 128,                                                   
                                )
                              ),
                              new Container(           
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 0.0
                                ),                            
                                child: new FlatButton(                                                                     
                                  child: new Text(
                                    'Let\'s Get Started',
                                    style: TextStyle(
                                      fontSize: mobileLayout ? 18 : 28, 
                                    ),
                                  ),
                                  textColor: dhfYellow, 
                                  onPressed: () { 
                                    Navigator.pushNamed(context, "/signin");                               
                                  },
                                ),
                              )                       
                            ],
                          )                                              
                        ),                                                
                      ],
                    )  
                  )
                )
              );
            }
          )
        );      
      } 
    );
  }
}
