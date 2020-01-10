import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/conversation/views/conversation_chat.dart';
import 'package:gomotive/core/app_config.dart';

class PractitionerAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerAlerts(),
      ),
    );
  }
}

class _PractitionerAlerts extends StatefulWidget {
  @override
  _PractitionerAlertsState createState() => new _PractitionerAlertsState();
}

class _PractitionerAlertsState extends State<_PractitionerAlerts> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _unreadMessageCount;
  List<Map> _unreadChats;

  List<Widget> _unreadChatUserMessages() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_unreadChats.length; i++) {
      GestureDetector _container = new GestureDetector(                      
        onTap:() {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new ConversationChat(
                conversationId: _unreadChats[i]["id"],
              ),
            ),
          );
        },
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: new Avatar(
                  name: _unreadChats[i]["name"],
                  // url: _unreadChats[i]["image_url"],
                  url: null,
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(_unreadChats[i]["name"],)
                    ),
                    new Container(
                      child: new Text(
                        _unreadChats[i]["not_viewed_count"].toString() + " new messages",
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 12.0,
                        )
                      )
                    ),                                              
                  ],
                )                              
              ),
            ]
          ),
        )
      );
      _list.add(_container);
    }
    return _list;
  }
 
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getPractitionerHomePageDetails"] = (BuildContext context, Map params) =>
            store.dispatch(getHomePageDetails(context, params));
        returnObject["unreadMessageCount"] = store.state.practitionerState.unreadMessageCount;
        returnObject["unreadChats"] = store.state.practitionerState.unreadChats;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _unreadMessageCount = stateObject["unreadMessageCount"];        
        _unreadChats = stateObject["unreadChats"];
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
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              'Alerts',             
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
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          child: new Center(
                            child: new FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              onPressed: () {
                                Navigator.of(context).pushNamed("/practitioner/email_all_clients");
                              },
                              child: new Text(
                                "Email All Clients",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              color: primaryColor,
                              textColor: primaryTextColor,
                            ),
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          child: new Center(
                            child: new FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              onPressed: () {
                                Navigator.of(context).pushNamed("/message/list");
                              },
                              child: new Text(
                                "You have " + _unreadMessageCount.toString() + " unread messages",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              color: primaryColor,
                              textColor: primaryTextColor,
                            ),
                          )
                        ),
                        new Container(    
                          width: MediaQuery.of(context).size.width,   
                          decoration: BoxDecoration(
                            color: Colors.blueGrey
                          ),                       
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: new Container(                                  
                            child: new Text(
                              "New Chat Messages",
                              textAlign: TextAlign.center,
                              style: TextStyle(  
                                color: Colors.white,                                  
                              ),
                            )
                          ),                              
                        ),
                        _unreadChats != null && _unreadChats.length > 0
                        ? new Container(
                            child: new Column(
                              children: _unreadChatUserMessages(),
                            )                            
                          )                        
                        : new Container(
                            padding:EdgeInsets.symmetric(vertical: 32.0, horizontal: 0.0),
                            child: new Center(
                              child: new Text(
                                "You have no new chat messages from your clients"
                              ),
                            )
                          ),                        
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
