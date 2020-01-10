import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/message/message_network.dart';
import 'package:gomotive/message/message_actions.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _MessageList(),
      ),
    );
  }
}

class _MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => new _MessageListState();
}

class _MessageListState extends State<_MessageList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  var _getMessageListApi, _selectMessageActionCreator;
  List<Map> _messageList;
  Map _paginateInfo;

  ScrollController _controller;

  _fetchNews(int pageNumber) {
    var params = new Map();
    params["page"] = pageNumber;
    _getMessageListApi(context, params);
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
        _getMessageListApi = stateObject["getMessageList"];
        _selectMessageActionCreator = stateObject["selectMessageActionCreator"];
        _fetchNews(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getMessageList"] = (BuildContext context, Map params) =>
            store.dispatch(getMessageList(context, params));
        returnObject["selectMessageActionCreator"] = (Map messageInfo, int listIndex) =>
            store.dispatch(SelectMessageActionCreator(messageInfo, listIndex));                    
        returnObject["messageList"] = store.state.messageState.messageList;
        returnObject["paginateInfo"] = store.state.messageState.paginateInfo;        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _messageList = stateObject["messageList"];        
        _paginateInfo = stateObject["paginateInfo"];
        if(_messageList != null) {
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
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                "My Messages",             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
              ],
            ),            
            body: new SafeArea(
              bottom: false,
              child: _messageList.length > 0
                ? Container(
                    child: new ListView.builder(
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: _messageList.length,
                      itemBuilder: (context, i) {
                        return new GestureDetector(
                          onTap: () {
                            _selectMessageActionCreator(_messageList[i], i);
                            Navigator.of(context).pushNamed("/message/view");                        
                          },
                          child: new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),                        
                            decoration: new BoxDecoration(
                              border: new Border(
                                bottom: new BorderSide(
                                  color: Colors.black12
                                ),
                              ),                              
                            ),
                            child: new Column(                           
                              children: <Widget>[ 
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      width: MediaQuery.of(context).size.width*0.2,
                                      child: new Avatar(
                                        name: _messageList[i]["sender"]["name"],
                                        url: _messageList[i]["sender"]["avatar_url_tb"],
                                        maxRadius: 30,
                                      )
                                    ),
                                    new Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                            child: new Text(
                                              _messageList[i]["subject"]
                                            )
                                          ),
                                          new Container(
                                            child: new Text(
                                              Utils.convertDateStringToDisplayStringDateAndTime(
                                                _messageList[i]["sent_datetime"]
                                              ),
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12.0,
                                              )
                                            )
                                          ),                                      
                                        ],
                                      )                                
                                    ),
                                    _messageList[i]["read_datetime"] == null ?
                                      new Container(                                    
                                        width: MediaQuery.of(context).size.width*0.1,
                                        child: new Icon(
                                          Icons.star,
                                          color: Colors.green,
                                        )
                                      )
                                    : new Container(),
                                  ],
                                )                                                                                                                              
                              ]                            
                            )
                          ),
                        );
                      },
                    )
                )
                : new Container(
                  child: new Center(
                    child: new Text("You have not received any messages")
                  )
                ),
              )
            );
        } else {
          return new Container();
        }
      }
    );
  }
}
