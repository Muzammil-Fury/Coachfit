import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/message/message_network.dart';
import 'package:gomotive/message/message_actions.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class MessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _MessageView(),
      ),
    );
  }
}

class _MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => new _MessageViewState();
}

class _MessageViewState extends State<_MessageView> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
    var _clearMessageActionCreator, _viewMessage;

  Map _messageObj;
  
  
  @override
  void deactivate() { 
    super.deactivate();
    _clearMessageActionCreator();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {  
        _clearMessageActionCreator = stateObject["clearMessageActionCreator"];
        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["viewMessage"] = (BuildContext context, Map params) =>
            store.dispatch(viewMessage(context, params));
        returnObject["clearMessageActionCreator"] = () =>
            store.dispatch(ClearMessageActionCreator());                    
        returnObject["messageObj"] = store.state.messageState.messageObj;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _messageObj = stateObject["messageObj"];  
        _viewMessage = stateObject["viewMessage"];
        if(_messageObj != null) {                    
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
                  if(_viewMessage != null) {    
                    Map params = new Map();
                    params["message_id"] = _messageObj["id"];
                    _viewMessage(context, params);
                  }
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                'Inbox',             
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                            color: Colors.black12
                          ),
                        ),                              
                      ),                      
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: new Row(
                        children: <Widget>[                          
                          new Container(
                            child: new Avatar(
                              name: _messageObj["sender"]["name"],
                              url: _messageObj["sender"]["avatar_url_tb"],
                              maxRadius: 30,
                            )
                          ),
                          new Container(                            
                            child: new Text(
                              _messageObj["sender"]["name"],
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.0,
                              )
                            )
                          ),                          
                        ],
                      )
                    ),
                    new Container(                      
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: new Text(
                        _messageObj["subject"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0
                        ),
                      )
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                            color: Colors.black12
                          ),
                        ),                              
                      ),
                      child: new Text(
                        Utils.convertDateStringToDisplayStringDateAndTime(_messageObj["sent_datetime"]),
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 12.0
                        ),
                      )
                    ),
                    new Container(
                      child: new Html(
                        padding: EdgeInsets.all(8.0),
                        data: _messageObj["body"]
                      ),
                    )
                  ],
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
