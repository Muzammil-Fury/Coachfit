import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/news/news_network.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/news/views/news_view.dart';
import 'package:gomotive/practitioner/practitioner_utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class PractitionerNewsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerNewsList(),
      ),
    );
  }
}

class _PractitionerNewsList extends StatefulWidget {  

  @override
  _PractitionerNewsListState createState() => new _PractitionerNewsListState();
}

class _PractitionerNewsListState extends State<_PractitionerNewsList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String _pageName = "news";
  var _getNewsListApi;
  List<Map> _newsList;
  Map _paginateInfo;
  List<Map> _menuList;

  ScrollController _controller;

  _fetchNews(int pageNumber) {
    var params = new Map();
    params["page"] = pageNumber;
    _getNewsListApi(context, params);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
        if(_paginateInfo.containsKey("total_pages") && (_paginateInfo["page"]+1) < _paginateInfo["total_pages"]){
          _fetchNews(_paginateInfo["page"] + 1);
        }
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  
  @override
  void deactivate() { 
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getNewsListApi = stateObject["getNewsList"];
        _fetchNews(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getNewsList"] = (BuildContext context, Map params) =>
            store.dispatch(getNewsList(context, params));        
        returnObject["newsList"] = store.state.newsState.newsList;
        returnObject["paginateInfo"] = store.state.newsState.paginateInfo;   
        returnObject["menuList"] = store.state.practitionerState.menuItems;     
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _newsList = stateObject["newsList"]; 
        _menuList = stateObject["menuList"];       
        _paginateInfo = stateObject["paginateInfo"];
        if(_newsList != null && _menuList != null) {
          int _currentIndex = PractitionerUtils.getCurrentIndex(_menuList, _pageName);
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home/route');
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                'News',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: PractitionerUtils.buildNavigationMenuBar(_menuList, _pageName),
              onTap: (int index) {
                PractitionerUtils.menubarTap(
                  context, _menuList, _pageName, index
                );
              },
            ),            
            body: new SafeArea(
              bottom: false,
              child: Container(
                child: new ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  itemCount: _newsList.length,
                  itemBuilder: (context, i) {
                    return new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new NewsView(
                              newsId: _newsList[i]["id"], 
                              fromExternal: false,                              
                            ),
                          ),
                        );
                      },
                      child: new Container(
                        decoration: new BoxDecoration(
                          border: new Border(
                            bottom: new BorderSide(
                              color: Colors.black12
                            ),
                          ),                              
                        ),
                        child: new Row(    
                          children: <Widget>[
                            new Container (
                              width: 100,
                              height: 80,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: new Thumbnail(
                                url: _newsList[i]["cover_media"] != null ? _newsList[i]["cover_media"]["thumbnail_url"] : "",
                                defaultImage: "assets/images/generic_news.jpg"
                              ),
                            ),
                            new Expanded(
                              child: Container(
                                child: new Text(_newsList[i]["title"])
                              ),
                            ),
                          ]
                        ),
                      ),
                    );
                  },
                ),
              )
            )
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
