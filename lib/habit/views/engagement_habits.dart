import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/habit/views/habit_template_list.dart';
import 'package:gomotive/habit/views/habit_edit.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/habit/habit_network.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementHabits extends StatelessWidget {
  final int clientId;
  final int engagementId;
  EngagementHabits({
    this.clientId,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementHabits(
          clientId: this.clientId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _EngagementHabits extends StatefulWidget {
  final int clientId;
  final int engagementId;
  _EngagementHabits({
    this.clientId,
    this.engagementId,
  });


  @override
  _EngagementHabitsState createState() => new _EngagementHabitsState();
}

class _EngagementHabitsState extends State<_EngagementHabits> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _deleteEngagementHabitAPI;

  Map _engagementObj;
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),                                    
                  child: new Text(
                    _habits[i]["name"],
                    textAlign: TextAlign.start,
                  )
                ), 
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),                                    
                  child: new Text(
                    "Start date: " + Utils.convertDateStringToDisplayStringDate(_habits[i]["start_date"]),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100
                    )
                  )
                ),               
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),                                    
                  child: new Text(
                    "Schedule Type: " + _habits[i]["__schedule_type"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100
                    )
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),                                    
                  child: new Text(
                    _habits[i]["is_published"] ? "Status: Published" : "Status: Draft",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                      color: _habits[i]["is_published"] ? Colors.green : Colors.blue,
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
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new HabitEdit(
                    clientId: widget.clientId,
                    engagementId: widget.engagementId,  
                    habitId: _habits[i]["id"],
                  ),
                ),
              );           
            },
            child: new Container(
              color: Colors.blueAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.edit,
                    color: Colors.white
                  ),                
                  new Text(
                    "EDIT",
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
          new GestureDetector(
            onTap: () async {  
              CustomDialog.confirmDialog(context, "Are you sure?", "Would you like to delete this habit assigned to game plan?", "Yes, I am", "No").then((int response) {
                if(response == 1) {
                  Map _params = new Map();
                  _params["engagement_id"] = widget.engagementId;
                  _params["habit_id"] = _habits[i]["id"];
                  _deleteEngagementHabitAPI(context, _params);            
                }
              });              
            },
            child: new Container(
              color: Colors.redAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.delete,
                    color: Colors.black87
                  ),                
                  new Text(
                    "DELETE",
                    style: TextStyle(
                      color: Colors.black87,
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
        _deleteEngagementHabitAPI = stateObject["deleteEngagementHabit"];     
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();  
        returnObject["deleteEngagementHabit"] = (BuildContext context, Map params) =>
            store.dispatch(deleteEngagementHabit(context, params));     
        returnObject["engagement"] = store.state.practitionerState.activeClientEngagement;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _engagementObj = stateObject["engagement"];        
        if(_engagementObj != null && _engagementObj.keys.length > 0){
          _habits = Utils.parseList(_engagementObj, "habits");
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
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new PractitionerClientHome(
                        clientId: widget.clientId,                           
                      ),
                    ),
                  );
                },
              ),     
              backgroundColor: Colors.white,
              title: new Text(
                'Habits',
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                     
              actions: <Widget>[                
              ],
            ),  
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {   
                CustomDialog.createHabit(context).then((int response){
                  if(response == 2) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new HabitTemplateList(
                          clientId: widget.clientId,
                          engagementId: widget.engagementId,                  
                        ),
                      ),
                    );
                  } else if(response == 1) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new HabitEdit(
                          clientId: widget.clientId,
                          engagementId: widget.engagementId,  
                          habitId: null,
                        ),
                      ),
                    );
                  }
                });    
              },
              child: new Text(
                "ADD",
                style: TextStyle(
                  color: primaryTextColor
                )
              ),            
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,                      
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
                          "No habits have been assigned. Kindly click on Add to assign one.",
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
