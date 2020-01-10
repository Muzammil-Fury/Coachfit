import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/habit/habit_network.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class HabitTemplateList extends StatelessWidget {
  final int clientId;
  final int engagementId;
  HabitTemplateList({
    this.clientId,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _HabitTemplateList(
          clientId: this.clientId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _HabitTemplateList extends StatefulWidget {
  final int clientId;
  final int engagementId;
  _HabitTemplateList({
    this.clientId,
    this.engagementId,
  });

  @override
  _HabitTemplateListState createState() => new _HabitTemplateListState();
}

class _HabitTemplateListState extends State<_HabitTemplateList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  var _getHabitTemplateListAPI, _createHabitFromHabitTemplateAPI;
  List<Map> _habits;

  List<Widget> _listHabits() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_habits.length; i++) {
      final slideMenuKey = new GlobalKey<SlideMenuState>();
      SlideMenu _item = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(                  
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          title: new Container(   
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),  
            decoration: new BoxDecoration(                          
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),                                    
                  child: new Text(
                    _habits[i]["name"],
                    textAlign: TextAlign.start,
                  )
                ),                 
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),                                    
                  child: new Text(
                    "Schedule Type: " + _habits[i]["__schedule_type"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100
                    )
                  )
                ),                
              ]
            ),            
          )
        ),
        menuItems: <Widget>[
          new GestureDetector(
            onTap: () {       
              Map _params = new Map();
              _params["client_id"] = widget.clientId;
              _params["engagement_id"] = widget.engagementId;
              _params["habit_template_id"] = _habits[i]["id"];
              _createHabitFromHabitTemplateAPI(context, _params);              
            },
            child: new Container(
              color: Colors.blueAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    Icons.add_circle_outline,
                    color: Colors.white
                  ),                
                  new Text(
                    "ADD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500
                    )
                  )              
                ]
              )
            ),
          ),          
        ]
      );
      _list.add(_item);
    }
    return _list;
  }
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {  
        _getHabitTemplateListAPI = stateObject["getHabitTemplateList"];    
        _createHabitFromHabitTemplateAPI = stateObject["createHabitFromHabitTemplate"];
        Map _params = new Map();
        _params["show_published"] = true;
        _params["show_partner_templates"] = true;
        _getHabitTemplateListAPI(context, _params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();  
        returnObject["getHabitTemplateList"] = (BuildContext context, Map params) =>
            store.dispatch(getHabitTemplateList(context, params));     
        returnObject["createHabitFromHabitTemplate"] = (BuildContext context, Map params) =>
            store.dispatch(createHabitFromHabitTemplate(context, params));     
        returnObject["habitTemplateList"] = store.state.habitState.habitTemplateList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _habits = stateObject["habitTemplateList"];      
        if(_habits != null) {          
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
                'Habit Templates',
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0), 
                      child: _habits.length > 0
                      ? new Column(
                          children: _listHabits()
                        )
                      : new Center(
                        child: new Text(                          
                          "No habits templates are available.",
                          textAlign: TextAlign.center,
                        )
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
