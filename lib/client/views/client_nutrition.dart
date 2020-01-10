import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/text_tap.dart';
import 'package:gomotive/core/app_config.dart';

class ClientNutrition extends StatelessWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  ClientNutrition({
    this.id,
    this.type,
    this.displayProgramTitle,
    this.fromExternal: false,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientNutrition(
          id: id,
          type: type,
          displayProgramTitle: displayProgramTitle,
          fromExternal: fromExternal,
        ),
      ),
    );
  }
}

class _ClientNutrition extends StatefulWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  _ClientNutrition({
    this.id,
    this.type,
    this.displayProgramTitle,
    this.fromExternal,
  });

  @override
  _ClientNutritionState createState() => new _ClientNutritionState();
}

class _ClientNutritionState extends State<_ClientNutrition> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  
  var _getNutritionListAPI, 
      _clearProgramObjectActionCreator;
  Map _programObj;  



  List<Widget> _displayNutritionAndGuidance() {
    List<Widget> _list = new List<Widget>();    
    if(_programObj["action_type"] == "view_treatment") {
      Column c = new Column(  
        crossAxisAlignment: CrossAxisAlignment.start,      
        children: _displayTodaysHabit(
          _programObj["type"], 
          _programObj["name"], 
          Utils.parseList(_programObj,"nutrition"),       
          Utils.parseList(_programObj,"guidance"),
        )         
      );
      _list.add(c);
    } else if(_programObj["action_type"] == "display_payment") {
      Container c = new Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
        child: new Center(
          child: Text(
            _programObj["mobile_display_text"]
          ),
        )
      );
      _list.add(c);
    }
    return _list;
  }

  List<Widget> _displayTodaysHabit(
    String type, 
    String name, 
    List<Map> nutrition,
    List<Map> guidance
  ) {
    List<Widget> _list = new List<Widget>();
    if(widget.displayProgramTitle) {
      Container programType = new Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[300]
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            type == "engagement" ?
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Icon(
                  GomotiveIcons.game_plan,
                  color: Colors.white,
                )
              )
            : new Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Icon(
                  GomotiveIcons.group,
                  color: Colors.white,
                ),
              ),
            new Flexible(
              child: new Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              )
            )
          ],        
        )
      );
      _list.add(programType);
    }
    if(nutrition.length > 0 || guidance.length > 0) {
      for(int i=0; i<nutrition.length; i++) {
        Container _nutritionContainer = new Container(        
          color: Colors.blueGrey[100], 
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[  
              new Container(      
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),   
                child: new Icon(
                  GomotiveIcons.nutrition,
                ),          
              ),
              new Flexible(
                child: new Text(
                  nutrition[i]["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16
                  )
                )
              )
            ],        
          )
        );
        _list.add(_nutritionContainer);  
        if(nutrition[i]["description"] != null) {
          Container _nutritionContainerNotes = new Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: new Text(
              nutrition[i]["description"],
            )        
          );
          _list.add(_nutritionContainerNotes);
        }
        for(int j=0; j<nutrition[i]["attachments"].length;j++) {
          Container _attachmentContainer = new Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: new TextTap(
              nutrition[i]["attachments"][j]["attachment_name"], 
              "web",
              nutrition[i]["attachments"][j]["attachment_url"],
              textColor: Colors.blue
            ),
          );
          _list.add(_attachmentContainer);
        }
      }
      for(int i=0; i<guidance.length; i++) {
        Container _guidanceContainer = new Container(        
          color: Colors.blueGrey[100], 
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[  
              new Container(      
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),   
                child: new Icon(
                  GomotiveIcons.guidance,
                ),          
              ),
              new Flexible(
                child: new Text(
                  guidance[i]["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16
                  )
                )
              )
            ],        
          )
        );
        _list.add(_guidanceContainer);
        if(guidance[i]["description"] != null) {
          Container _guidanceContainerNotes = new Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: new Text(
              guidance[i]["description"],
            )        
          );
          _list.add(_guidanceContainerNotes);
        }
        for(int j=0; j<guidance[i]["attachments"].length;j++) {
          Container _attachmentContainer = new Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: new TextTap(
              guidance[i]["attachments"][j]["attachment_name"], 
              "web",
              guidance[i]["attachments"][j]["attachment_url"],
              textColor: Colors.blue
            ),
          );
          _list.add(_attachmentContainer);
        }        
      }
    } else {
      Container descContainer1 = new Container(
        padding: EdgeInsets.fromLTRB(16, 64, 16, 0),
        child: new Center(
          child: new Text(
            "There are no nutrition & guidance documents assigned for this program.",
            style: TextStyle(
              fontSize: 15.0
            ),
            textAlign: TextAlign.center,
          ),
        )
      );
      _list.add(descContainer1);
    }
    return _list;
  }


  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getNutritionListAPI = stateObject["getNutritionAndGuidanceList"];  
        _clearProgramObjectActionCreator = stateObject["clearProgramObject"];      
        Map params = new Map();
        params["fetch_type"] = widget.type;
        params["id"] = widget.id;
        _getNutritionListAPI(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getNutritionAndGuidanceList"] = (BuildContext context, Map params) =>
            store.dispatch(getNutritionAndGuidanceList(context, params));                
        returnObject["clearProgramObject"] = () =>
          store.dispatch(ProgramObjectClearActionCreator()
        );                         
        returnObject["programObj"] = store.state.clientState.programObj;       
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _programObj = stateObject["programObj"];   
        if(_programObj != null && _programObj.keys.length > 0) {          
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  this._clearProgramObjectActionCreator();
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                "Nutrition & Guidance",             
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
                        children: _displayNutritionAndGuidance()
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
