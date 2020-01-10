import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/conversation/conversation_actions.dart';
import 'package:gomotive/conversation/conversation_network.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/utils/utils.dart';

class ConversationChat extends StatelessWidget {
  final int conversationId;
  final bool fromExternal;
  ConversationChat({
    this.conversationId,
    this.fromExternal: false,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ConversationChat(
          conversationId: this.conversationId,
          fromExternal: this.fromExternal,
        ),
      ),
    );
  }
}

class _ConversationChat extends StatefulWidget {
  final int conversationId;
  final bool fromExternal;
  _ConversationChat({
    this.conversationId,
    this.fromExternal,
  });
  
  @override
  _ConversationChatState createState() => new _ConversationChatState();
}

class _ConversationChatState extends State<_ConversationChat> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _chatController = new TextEditingController();
  var _getChatListAPI, _clearChatListActionCreator, _postChatAPI;  
  List<Map> _chatList;
  Map _paginateInfo, _conversationObj;

  ScrollController _controller;

  _getChatMessages(int pageNumber) {
    var params = new Map();
    params["page"] = pageNumber;
    params["conversation_id"] = widget.conversationId;
    _getChatListAPI(context, params);                
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
        if(_paginateInfo.containsKey("total_pages") && (_paginateInfo["page"]+1) < _paginateInfo["total_pages"]){
          _getChatMessages(_paginateInfo["page"] + 1);
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
        _getChatListAPI = stateObject["getChatList"];
        _clearChatListActionCreator = stateObject["clearChatListActionCreator"];
        _postChatAPI = stateObject["postChat"];
        _getChatMessages(0);        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();     
        returnObject["getChatList"] = (BuildContext context, Map params) =>
            store.dispatch(getChatList(context, params)); 
        returnObject["postChat"] = (BuildContext context, Map params) =>
            store.dispatch(postChat(context, params)); 
        returnObject["clearChatListActionCreator"] = () =>
            store.dispatch(ChatListClearActionCreator()); 
        returnObject["chatList"] = store.state.conversationState.chatList;  
        returnObject["paginateInfo"] = store.state.conversationState.paginateInfo;
        returnObject["conversationObj"] = store.state.conversationState.conversationObj;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _chatList =stateObject["chatList"];
        _paginateInfo = stateObject["paginateInfo"];
        _conversationObj = stateObject["conversationObj"];
        if(_chatList != null && _conversationObj != null) {           
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
                  this._clearChatListActionCreator();
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: new Text(
                _conversationObj != null && _conversationObj.containsKey("name") ? _conversationObj["name"] : "",   
                style: TextStyle(
                  color: Colors.black87
                )                        
              ),              
              actions: <Widget>[
              ],
            ),            
            body: new SafeArea(
              bottom: false,
              child: Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Row(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            width: MediaQuery.of(context).size.width*.9,
                            child: new TextField(
                              controller: _chatController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(                                          
                                  borderSide: const BorderSide(
                                    color: Colors.black12
                                  ),                                          
                                ),                          
                              ),
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            width: MediaQuery.of(context).size.width*.1,
                            child: new GestureDetector(                              
                              onTap:() {
                                if(_chatController.text != "") {
                                  Map params = new Map();
                                  params["message"] =_chatController.text;
                                  params["conversation_id"] = widget.conversationId;
                                  this._postChatAPI(context, params);
                                  _chatController.text = "";
                                }
                              },
                              child: new Image.asset(
                                'assets/images/send.png',
                                color: primaryColor
                              ),
                            )
                          )
                        ],
                      )                      
                    ),
                    new Expanded(
                      child: new ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: _chatList.length,
                        itemBuilder: (context, i) {
                          if(_chatList[i]["user"]["id"] == selectedUser["id"]) {
                            return new Container(                            
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),                            
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[                                
                                  new Expanded(                                
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                                      decoration: new BoxDecoration(
                                        border: new Border.all(
                                          color: Colors.lightGreenAccent,                                        
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0) //                 <--- border radius here
                                        ),
                                      ),
                                      child: new Container(
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            new Text(
                                              _chatList[i]["message"]
                                            ),
                                            new Text(
                                              Utils.convertDateStringToDisplayStringDateAndTime(_chatList[i]["created_date"]),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12
                                              )
                                            )
                                          ]
                                        )
                                      )                                        
                                    )
                                  ),
                                  new Container(
                                    child: new Avatar(
                                      name: _chatList[i]["user"]["name"],
                                      url: _chatList[i]["user"]["avatar_url_tb"],
                                      maxRadius: 15,
                                    )
                                  ),
                                ],
                              )
                            );
                          } else {
                            return new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    child: new Avatar(
                                      name: _chatList[i]["user"]["name"],
                                      url: _chatList[i]["user"]["avatar_url_tb"],
                                      maxRadius: 15,
                                    )
                                  ),
                                  new Expanded(                                
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                                      decoration: new BoxDecoration(
                                        border: new Border.all(
                                          color: Colors.lightBlueAccent,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0) //                 <--- border radius here
                                        ),
                                      ),                                    
                                      child: new Container(
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            new Text(
                                              _chatList[i]["message"]
                                            ),
                                            new Text(
                                              Utils.convertDateStringToDisplayStringDateAndTime(_chatList[i]["created_date"]),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12
                                              )
                                            )
                                          ]
                                        )
                                      )                                        
                                    )
                                  )
                                ],
                              )
                            );
                          }
                        }
                      )
                    )
                  ]                
                )             
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
