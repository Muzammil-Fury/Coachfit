import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/news/news_network.dart';
import 'package:gomotive/news/news_actions.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class NewsView extends StatelessWidget {
  final int newsId;
  final bool fromExternal;
  NewsView({
    this.newsId,
    this.fromExternal: false,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _NewsView(
          newsId: this.newsId,
          fromExternal: this.fromExternal,
        ),
      ),
    );
  }
}

class _NewsView extends StatefulWidget {
  final int newsId;
  final bool fromExternal;
  _NewsView({
    this.newsId,
    this.fromExternal,
  });
  @override
  _NewsViewState createState() => new _NewsViewState();
}

class _NewsViewState extends State<_NewsView> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getNewsDetailsApi, _clearNewsObjectActionCreator;
  Map _news;  

  List _listNewsMediaItems() {
    List<Widget> mediaList = new List<Widget>();
    if(_news["media_items"] != null && _news["media_items"].length > 0) {
      Widget widget = new Container(
        color: Colors.black12,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        margin: EdgeInsets.symmetric(vertical:8.0, horizontal: 0.0),
        child: new Center(
          child: new Text(
            "Media Items",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black
            )
          )
        )
      );
      mediaList.add(widget);
      for(int i=0; i<_news["media_items"].length; i++) {
        if(_news["media_items"][i]["media_type"] == 1) {
          Widget widget = new Thumbnail(
            url: _news["media_items"][i]["thumbnail_url"],
          );
          mediaList.add(widget);
        } else {
          Widget widget =new VideoApp(
            videoUrl: _news["media_items"][i]['video_url'],
            autoPlay: false,
          );
          mediaList.add(widget);
        }
      }
    }
    return mediaList;
  }

  @override
  void initState() {    
    super.initState();
  }
  @override
  void dispose() {    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {  
        _getNewsDetailsApi = stateObject["getNewsDetails"];
        _clearNewsObjectActionCreator = stateObject["clearNewsObject"];
        Map params = new Map();
        params["id"] = widget.newsId;
        _getNewsDetailsApi(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getNewsDetails"] = (BuildContext context, Map params) =>
            store.dispatch(getNewsDetails(context, params));  
        returnObject["clearNewsObject"] = () =>
          store.dispatch(ClearNewsObjectActionCreator()
        );                  
        returnObject["news"] = store.state.newsState.newsObj;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _news = stateObject["news"];             
        if(_news != null) {
          var _displayDate;
          if(_news["start_date"] != null) {
            _displayDate = _news["start_date"];
          } else {
            _displayDate = _news["created_date"];
          }
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {
                    this._clearNewsObjectActionCreator();
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: new Text(
                _news["title"],             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
              ],
            ),     
            body: new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: new Container(
                      padding:EdgeInsets.fromLTRB(0, 0, 0, 64),   
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            child: new Center(                            
                              child: _news["cover_media"] != null && _news["cover_media"]["media_type"] == 1 ?
                                new Thumbnail(
                                  url: _news["cover_media"]["thumbnail_url"],
                                )
                              : new Container(),
                            )
                          ),                  
                          new Container(
                            child: new Center(                            
                              child: _news["cover_media"] != null && _news["cover_media"]["media_type"] == 2 ?                                
                                new VideoApp(
                                  videoUrl: _news["cover_media"]['video_url'],
                                  autoPlay: false,                                  
                                )
                              : new Container(),
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: new Text(
                              _news["title"],
                              style: TextStyle(
                                fontSize: 16.0,
                              )
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: new Text(
                              _news["author"]["name"],
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black38
                              )
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: new Text(
                              Utils.convertDateStringToDisplayStringDateAndTime(_displayDate),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black38
                              )
                            )
                          ),
                          new Container(
                            padding:EdgeInsets.fromLTRB(0, 8, 0, 8),
                            decoration: new BoxDecoration(
                              border: new Border(
                                bottom: new BorderSide(
                                  color: Colors.black12
                                ),
                              ),                              
                            ),
                          ),                          
                          new Html(
                            padding: EdgeInsets.all(8.0),
                            data: _news["content"]
                          ),
                          new Column(
                            children: _listNewsMediaItems(),
                          )
                        ],
                      ),                         
                    )
                  )
                );
              }
            )
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
