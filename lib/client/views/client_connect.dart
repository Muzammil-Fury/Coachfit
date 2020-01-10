import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/conversation/views/conversation_chat.dart';
import 'package:gomotive/utils/dialog.dart';

class ClientConnect extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientConnect(
        ),
      ),
    );
  }
}

class _ClientConnect extends StatefulWidget {
  
  @override
  _ClientConnectState createState() => new _ClientConnectState();
}

class _ClientConnectState extends State<_ClientConnect> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  List<Map> _practitioners;
  Map _businessPartner;
  int _unreadMessageCount, _intakeFormCount;

  List<Widget> _listPractitioners() {
    List<Widget> _list = new List<Widget>();
    Widget _title = new Container(
      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: new Center(
        child: new Text(
          "Associated Practitioners",
          style: TextStyle(
            fontSize: 18.0
          ),
        ),        
      )
    );
    _list.add(_title);
    for(int i=0; i<_practitioners.length; i++){
      Widget _practitioner = new Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: new Center(
          child: new GestureDetector(
            onTap: () {
              if(_practitioners[i]["id"] != selectedUser["id"]){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ConversationChat(
                      conversationId: _practitioners[i]["conversation_id"],
                    ),
                  ),
                );
              } else {
                CustomDialog.alertDialog(context, "Your own account", "This is your own account. Conversation has been disabled.");
              }
            },
            child: new Stack(
              children: <Widget>[
                new Avatar(
                  url: _practitioners[i]["avatar_url_tb"],
                  name: _practitioners[i]["name"],
                  maxRadius: 64,
                ),
                new Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.brightness_1,
                        size: 40.0, 
                        color: primaryColor                              
                      ),
                      new Positioned(
                        top: 10.0,
                        right: 12.0,                        
                        child: new Center(                          
                          child: new Text(
                            _practitioners[i]["unread_chat_count"].toString(),
                            style: new TextStyle(
                              color: primaryTextColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        )
                      ),
                    ],
                  ),                
                ),
              ],
            ) 
          )
        )
      );
      _list.add(_practitioner);
    }
    return _list;
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
        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();        
        returnObject["practitioners"] = store.state.clientState.practitioners;
        returnObject["unreadMessageCount"] = store.state.clientState.unreadMessageCount;
        returnObject["intakeFormCount"] = store.state.clientState.intakeFormCount;
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _practitioners = stateObject["practitioners"];
        _unreadMessageCount = stateObject["unreadMessageCount"];
        _intakeFormCount = stateObject["intakeFormCount"];
        _businessPartner = stateObject["businessPartner"]; 
        if(_practitioners != null) {          
          return new Scaffold(
            key: _scaffoldKey,            
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                'Connect',             
                style: TextStyle(
                  color: Colors.black87
                )   
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
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(   
                            decoration: new BoxDecoration(
                              border: new Border(
                                bottom: new BorderSide(
                                  color: Colors.black12
                                ),
                              ),                              
                            ),       
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),     
                            child: new Center(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),     
                                    child: new FlatButton(
                                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed("/message/list");
                                      },
                                      child: new Text(
                                        "You have " + _unreadMessageCount.toString() + " unread messages",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      color: primaryColor,
                                      textColor: primaryTextColor,
                                    ),
                                  ),
                                  _businessPartner["client_engagement_type"] == "gameplan"
                                  ? new Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),     
                                      child: new FlatButton(
                                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed("/client/intakeforms");
                                        },
                                        child: new Text(
                                          "You need to submit " + _intakeFormCount.toString() + " Intake Forms ",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        color: primaryColor,
                                        textColor: primaryTextColor,
                                      ),

                                    )
                                  : new Container(),
                                ],
                              )             
                            )                                                                                      
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
                            child: new Column(
                              children: _listPractitioners()
                            )
                          )
                        ],
                      )
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
