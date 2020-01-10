import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/core/app_config.dart';

class EducationContentView extends StatelessWidget {
  final Map content; 
  EducationContentView({
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EducationContentView(
          content: this.content,
        ),
      ),
    );
  }
}

class _EducationContentView extends StatefulWidget {
  final Map content; 
  _EducationContentView({
    this.content,
  });

  @override
  _EducationContentViewState createState() => new _EducationContentViewState();
}

class _EducationContentViewState extends State<_EducationContentView> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
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
          appBar: new AppBar(
            leading: IconButton(                  
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 40.0,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              widget.content["name"],             
              style: TextStyle(
                color: Colors.black87
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
                    child: new VideoApp(
                      videoUrl: widget.content["video_url"],
                      autoPlay: false,
                    ),
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
